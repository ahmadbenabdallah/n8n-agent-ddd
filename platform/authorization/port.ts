/**
 * Action authorization: the decision port and the execution gate.
 *
 * Before this module the boundary was written down five times and enforced
 * nowhere. `runtime/n8n/workflows/WF-10.json` computed `execution_allowed`
 * from fields of its own input, and WF-20's gate was
 * `if ($json.execution_allowed !== true) throw`, so any caller that sent
 * `execution_allowed: true` was authorized. The n8n graphs are placeholders
 * and the local n8n has no builtins allowlisted, so the decision lives here,
 * in TypeScript, under unit test, and the graphs only refuse to contradict it.
 *
 * Two functions:
 *
 *   authorizeAction()              decides and persists a record
 *   requireAuthorizedExecution()   loads that record back and gates execution
 *
 * `execution_allowed` is never an input. It is computed from the decision at
 * write time and read back from the database by `authorization_id`. Nothing
 * here looks at a payload flag.
 *
 * Scope (NAD-015): deny-by-default with the identity gate and the action
 * allowlist. The other nine gates of
 * `01-WF-10-AUTHORIZATION-SPEC.md:9-20` (ownership, freshness, business
 * policy, parameter constraints) are domain policy and follow.
 *
 * ponytail: no policy engine and no rule registry. Two checks, a reason list,
 * and one place that computes `execution_allowed`. Add the indirection when a
 * second domain needs a rule the first does not.
 */
import { EXTERNAL_EXECUTION_ROLE, readWorkflowRoles } from "../../scripts/lib/domain-roles";

/** `01-WF-10-AUTHORIZATION-SPEC.md:24-27`. `execution_allowed=true` is valid only with AUTHORIZED. */
export type AuthorizationDecision =
  | "AUTHORIZED"
  | "DENIED"
  | "NEEDS_CLARIFICATION"
  | "NEEDS_VERIFICATION"
  | "HUMAN_REQUIRED"
  | "RECONCILIATION_REQUIRED";

/** Platform role names. A domain maps them to its own workflow ids (ADR 0001). */
export const AUTHORIZATION_ROLE = "authorization";

/** Operation name this port reserves in `idempotency_keys` for a privileged execution. */
export const EXECUTION_OPERATION = "privileged_external_execution";

/** Identity levels that satisfy the identity gate. Anything else, including an absent or model-invented level, does not. */
export const SUFFICIENT_IDENTITY_LEVELS: readonly string[] = ["CHANNEL_LINKED", "VERIFIED"];

/** Default authorization lifetime. ponytail: one constant; make it domain policy when a domain needs another. */
export const DEFAULT_TTL_SECONDS = 300;

/** Fields of an action request: `contracts/platform/action.yaml:5-11`. */
export const ACTION_REQUEST_FIELDS = [
  "action_id",
  "action_type",
  "actor",
  "identity_assurance",
  "target",
  "requested_at",
  "idempotency_key",
] as const;

/**
 * Keys that belong to this port's *output*. A request carrying any of them is
 * trying to decide its own authorization, so it is stripped before the
 * decision and the attempt is itself a denial
 * (`08-WF-10-SECURITY-OWASP-TESTS.md:6`, RT-001).
 */
export const CALLER_FORBIDDEN_FIELDS = [
  "execution_allowed",
  "authorization_decision",
  "decision",
  "authorization_id",
  "expires_at",
] as const;

export interface ActionRequest {
  action_id: string;
  action_type: string;
  actor: string;
  identity_assurance: string;
  target: string;
  requested_at: string;
  idempotency_key: string;
}

/**
 * What an LLM path may produce. There is deliberately no `execution_allowed`
 * and no decision member: the model proposes an action, it does not carry
 * authority. `tests/unit/authorization/boundary.ts` pins that with
 * `@ts-expect-error`, so adding one breaks the build.
 */
export interface ActionProposal {
  action_type: string;
  target: string;
  normalized_parameters: Record<string, unknown>;
}

/** What actually arrives at the port: untrusted, possibly incomplete, possibly carrying extra keys. */
export type UntrustedActionRequest = Partial<ActionRequest> & Record<string, unknown>;

/**
 * Durable context. These values come from stored state, never from the
 * request: `identity_assurance` is the level the identity port established and
 * `allowlisted_actions` is the domain's action catalog.
 */
export interface AuthorizationContext {
  domain: string;
  identity_assurance: string;
  allowlisted_actions: readonly string[];
  policy_version: string;
  request_id?: string | null;
  conversation_id?: string | null;
  state_version?: number | null;
  order_scope_id?: string | null;
  normalized_parameters?: Record<string, unknown>;
  ttl_seconds?: number;
  now?: Date;
}

/** The durable record. Field names are `04-WF-10-AUTHORIZATION-RECORD.md:3-25`'s. */
export interface AuthorizationRecord {
  authorization_id: string;
  action_id: string;
  request_id: string | null;
  conversation_id: string | null;
  identity_level: string | null;
  state_version: number | null;
  idempotency_key: string | null;
  decision: AuthorizationDecision;
  execution_allowed: boolean;
  policy_version: string | null;
  scope: Record<string, unknown>;
  expires_at: Date | null;
  created_at: Date;
}

/** Id and created_at belong to the store. */
export type NewAuthorizationRecord = Omit<AuthorizationRecord, "authorization_id" | "created_at">;

/** The `authorizations` table, as the port needs it. Implemented over Drizzle in platform/state/repositories. */
export interface AuthorizationStore {
  insert(record: NewAuthorizationRecord): Promise<AuthorizationRecord>;
  findById(authorizationId: string): Promise<AuthorizationRecord | undefined>;
}

/** The `private.reserve_idempotency(key, operation, request_hash)` call (migration 0003). */
export type ReserveIdempotency = (
  key: string,
  operation: string,
  requestHash: string,
) => Promise<{ status: string }>;

/** The domain's workflow id for a platform role, or undefined when the domain declares none. */
export function workflowForRole(domain: string, role: string): string | undefined {
  return readWorkflowRoles(domain)[role];
}

const isNonEmptyString = (value: unknown): value is string => typeof value === "string" && value.length > 0;

/** Strip the request down to the contract's fields. Everything else, including this port's own output keys, is dropped. */
function normalizeRequest(request: UntrustedActionRequest): Partial<ActionRequest> {
  const normalized: Record<string, string> = {};
  for (const field of ACTION_REQUEST_FIELDS) {
    const value = request[field];
    if (isNonEmptyString(value)) normalized[field] = value;
  }
  return normalized as Partial<ActionRequest>;
}

/**
 * Decide and persist. Denials are stored too: a decision nobody recorded is
 * not auditable, and the executor needs a row to refuse against.
 *
 * Deny-by-default: the reason list starts empty and the decision is AUTHORIZED
 * only when nothing added to it.
 */
export async function authorizeAction(
  store: AuthorizationStore,
  request: UntrustedActionRequest,
  context: AuthorizationContext,
): Promise<AuthorizationRecord> {
  const supplied = CALLER_FORBIDDEN_FIELDS.filter((field) => field in request);
  const normalized = normalizeRequest(request);
  const reasons: string[] = [];

  if (supplied.length > 0) reasons.push(`caller_supplied_authorization_fields:${supplied.join(",")}`);

  for (const field of ACTION_REQUEST_FIELDS) {
    if (!isNonEmptyString(normalized[field])) reasons.push(`action_request_incomplete:${field}`);
  }

  // The identity level is the stored one. A request that claims a different
  // level is a promotion attempt, not a disagreement to resolve.
  if (!SUFFICIENT_IDENTITY_LEVELS.includes(context.identity_assurance))
    reasons.push("identity_assurance_insufficient");
  else if (normalized.identity_assurance && normalized.identity_assurance !== context.identity_assurance)
    reasons.push("identity_claim_mismatch");

  if (!normalized.action_type || !context.allowlisted_actions.includes(normalized.action_type))
    reasons.push("action_not_allowlisted");

  const decision: AuthorizationDecision = reasons.length === 0 ? "AUTHORIZED" : "DENIED";
  const now = context.now ?? new Date();
  const ttl = context.ttl_seconds ?? DEFAULT_TTL_SECONDS;

  return store.insert({
    // `authorizations.action_id` is `uuid NOT NULL REFERENCES actions(id)`, so
    // against the real table a denial for a request with no valid action id
    // cannot be stored and the insert raises. Nothing is authorized either
    // way; what is lost is the audit row. Whoever wires this port into a
    // running system decides whether such a request gets an `actions` row
    // first or a denial event instead (grant path: NAD-006).
    action_id: normalized.action_id ?? "",
    request_id: context.request_id ?? null,
    conversation_id: context.conversation_id ?? null,
    identity_level: context.identity_assurance,
    state_version: context.state_version ?? null,
    idempotency_key: normalized.idempotency_key ?? null,
    decision,
    // The only place `execution_allowed` is produced. Never read from input.
    execution_allowed: decision === "AUTHORIZED",
    policy_version: context.policy_version,
    scope: {
      domain: context.domain,
      authorized_by_role: AUTHORIZATION_ROLE,
      // The stripped request, so what was decided on is in the record and a
      // key the caller smuggled in is visibly absent from it.
      action_request: normalized,
      normalized_parameters: context.normalized_parameters ?? {},
      order_scope_id: context.order_scope_id ?? null,
      reasons,
    },
    expires_at: decision === "AUTHORIZED" ? new Date(now.getTime() + ttl * 1000) : null,
  });
}

/** What an executor presents. No `execution_allowed`: the authorization_id is the only authority it may carry. */
export interface ExecutionRequest {
  authorization_id: string;
  action_id: string;
  idempotency_key: string;
  request_hash: string;
  /** The domain whose role map decides which workflow may execute, and the id of the caller. */
  domain: string;
  workflow_id: string;
}

export interface ExecutionGateDeps {
  store: AuthorizationStore;
  reserve: ReserveIdempotency;
  /** Injectable for tests; defaults to the domain's own `workflow_roles` block. */
  resolveRole?: (domain: string, role: string) => string | undefined;
  now?: Date;
}

/**
 * The gate every privileged external mutation passes. Loads the stored record
 * by id and requires: AUTHORIZED, `execution_allowed` true, unexpired, bound
 * to this action, and a caller that fills the domain's
 * `privileged_external_execution` role. Then it reserves the idempotency key,
 * so a replay of an authorized execution is refused rather than repeated.
 *
 * Every failure throws. There is no falsy return a caller could ignore, and no
 * payload flag is consulted anywhere in it.
 */
export async function requireAuthorizedExecution(
  deps: ExecutionGateDeps,
  request: ExecutionRequest,
): Promise<AuthorizationRecord> {
  if (!isNonEmptyString(request?.authorization_id)) throw new Error("authorization_id_required");
  if (!isNonEmptyString(request.action_id)) throw new Error("action_id_required");
  if (!isNonEmptyString(request.idempotency_key)) throw new Error("idempotency_key_required");

  const resolveRole = deps.resolveRole ?? workflowForRole;
  const executor = resolveRole(request.domain, EXTERNAL_EXECUTION_ROLE);
  if (!executor) throw new Error("executor_role_not_declared");
  if (executor !== request.workflow_id) throw new Error("executor_role_mismatch");

  const record = await deps.store.findById(request.authorization_id);
  if (!record) throw new Error("authorization_not_found");
  if (record.decision !== "AUTHORIZED" || record.execution_allowed !== true)
    throw new Error("execution_not_authorized");
  if (record.action_id !== request.action_id) throw new Error("authorization_action_mismatch");
  // The key the authorization was issued against is the key the execution must
  // reserve, or the replay shield guards a different identity than the one
  // authorized. An AUTHORIZED record always carries one: the port denies a
  // request without it.
  if (record.idempotency_key !== request.idempotency_key)
    throw new Error("authorization_idempotency_mismatch");

  const now = deps.now ?? new Date();
  if (!record.expires_at || record.expires_at.getTime() <= now.getTime())
    throw new Error("authorization_expired");

  const { status } = await deps.reserve(request.idempotency_key, EXECUTION_OPERATION, request.request_hash);
  if (status !== "CREATED") throw new Error("execution_already_reserved");

  return record;
}
