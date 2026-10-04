/**
 * Behavioural tests for the action authorization boundary (NAD-015, RT-001).
 *
 * Every case here fails against the checkout before this task: there was no
 * decision port and no execution gate at all, WF-10 computed
 * `execution_allowed` from fields of its own input, and WF-20's gate was
 * `if ($json.execution_allowed !== true) throw`. Section 5b executes that
 * pre-change body, inlined as a string, so the regression is demonstrated
 * rather than asserted - and without depending on a git ref.
 *
 * Nothing here pins source text. The port and the gate are called, the n8n
 * Code nodes are EXECUTED under stubs for `$json` and `items`, and the
 * assertions are on what came back. The store double has the `authorizations`
 * table's uuid and foreign-key constraints on its write path and the reserve
 * double has `private.reserve_idempotency`'s contract (migration 0003), so the
 * records are read back from storage rather than from the object the port
 * happened to return.
 */
import assert from "node:assert/strict";
import { randomUUID } from "node:crypto";
import { readdirSync, readFileSync } from "node:fs";
import { join } from "node:path";
import {
  ACTION_REQUEST_FIELDS,
  AUTHORIZATION_ROLE,
  type ActionProposal,
  type ActionRequest,
  type AuthorizationContext,
  type AuthorizationRecord,
  type AuthorizationStore,
  DEFAULT_TTL_SECONDS,
  EXECUTION_OPERATION,
  type ExecutionRequest,
  type NewAuthorizationRecord,
  type ReserveIdempotency,
  type UntrustedActionRequest,
  authorizeAction,
  requireAuthorizedExecution,
  workflowForRole,
} from "../../../platform/authorization/port";
import { createAuthorizationRepository } from "../../../platform/state/repositories/authorization-repository";

// --- doubles -----------------------------------------------------------------

const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

/**
 * The `authorizations` table. `id` and `created_at` are the database's
 * (0001_domain_state.sql:23,30), and rows are cloned in and out so a test
 * reads what was stored, not the caller's object.
 *
 * `action_id` is `uuid NOT NULL REFERENCES actions(id)` (`:24`), so `insert` -
 * the production path - rejects a non-uuid with Postgres's 22P02 and an
 * unknown action with 23503. Rows written through `put` deliberately bypass
 * that: it exists to put the gate in front of storage the port would never
 * have produced (tampered, or migrated from a laxer schema - 0006 made the
 * correlation columns nullable, so a null `idempotency_key` is a real state).
 *
 * `attempted()` is whatever the port last tried to write, recorded before the
 * constraints run. That is how a decision which cannot be stored is asserted:
 * the same real constraint decides storability, so a port that substituted a
 * sentinel uuid for a missing `action_id` would store the row, or fail the
 * foreign key instead, rather than look identical to a refusal.
 */
function createStoreDouble() {
  const rows = new Map<string, AuthorizationRecord>();
  let attempted: NewAuthorizationRecord | undefined;
  const checkUuid = (value: unknown, column: string) => {
    if (typeof value !== "string" || !UUID.test(value))
      throw new Error(`22P02: invalid input syntax for type uuid: ${column}=${String(value)}`);
  };
  const store: AuthorizationStore = {
    async insert(record: NewAuthorizationRecord) {
      attempted = record;
      checkUuid(record.action_id, "action_id");
      if (!ACTIONS.has(record.action_id))
        throw new Error("23503: insert on authorizations violates authorizations_action_id_fkey");

      const row: AuthorizationRecord = {
        ...record,
        authorization_id: randomUUID(),
        created_at: new Date(),
      };
      rows.set(row.authorization_id, structuredClone(row));
      return structuredClone(row);
    },
    async findById(id: string) {
      checkUuid(id, "id");
      const row = rows.get(id);
      return row && structuredClone(row);
    },
  };
  /** A row the port would never write, to test the gate against hostile or legacy storage. */
  const put = (record: Partial<AuthorizationRecord>): string => {
    const id = randomUUID();
    rows.set(id, {
      authorization_id: id,
      action_id: ACTION_ID,
      request_id: null,
      conversation_id: null,
      identity_level: SUFFICIENT_LEVEL,
      state_version: null,
      idempotency_key: IDEMPOTENCY_KEY,
      decision: "AUTHORIZED",
      execution_allowed: true,
      policy_version: "wf10-v4.1",
      scope: {},
      expires_at: new Date(Date.now() + 60_000),
      created_at: new Date(),
      ...record,
    });
    return id;
  };
  return { store, rows, put, attempted: () => attempted };
}

/**
 * `private.reserve_idempotency(key, operation, request_hash)`: the first caller
 * for a key gets CREATED, later callers get the stored status, a different
 * request hash for the same key raises. Semantics read off
 * platform/state/db/migrations/0003_private_schema.sql:9-35. The live
 * counterpart needs Docker; see the task notes.
 */
function createReserveDouble() {
  const keys = new Map<string, { status: string; hash: string }>();
  const reserve: ReserveIdempotency = async (key, operation, requestHash) => {
    // The real function stores `p_operation` on insert and never reads it on
    // lookup, so a "wrong operation name" kill here is this double's contract,
    // not production behaviour. The assertion stays because the operation name
    // is what makes the key space this port's own.
    assert.equal(operation, EXECUTION_OPERATION, "executions reserve under their own operation name");
    const existing = keys.get(key);
    if (existing) {
      if (existing.hash !== requestHash) throw new Error("idempotency_key_conflict");
      return { status: existing.status };
    }
    keys.set(key, { status: "IN_PROGRESS", hash: requestHash });
    return { status: "CREATED" };
  };
  return { reserve, keys };
}

// --- fixtures ----------------------------------------------------------------

/**
 * A domain's declared `identity_ladder`, lowest assurance first. Read from the
 * domain rather than written here on purpose: the two shipped domains spell
 * their levels differently (`CHANNEL-LINKED` against `CHANNEL_VERIFIED`), and
 * a fixture that invents a spelling would pass against a port that invented
 * the same one. That is exactly how the deleted
 * `SUFFICIENT_IDENTITY_LEVELS = ["CHANNEL_LINKED", "VERIFIED"]` - a vocabulary
 * no domain uses - survived a full round of these tests.
 */
const identityLadder = (domain: string): string[] => {
  const block = readFileSync(`domains/${domain}/domain.yaml`, "utf8").split(/^identity_ladder:.*$/m)[1] ?? "";
  const levels: string[] = [];
  for (const line of block.split("\n")) {
    if (/^\S/.test(line)) break; // dedent ends the block
    const match = line.match(/^\s+-\s*([A-Z][A-Z0-9_-]*)/);
    if (match) levels.push(match[1]);
  }
  assert.ok(levels.length > 2, `${domain} declares an identity ladder to read`);
  assert.equal(levels[0], "ANONYMOUS", `${domain}'s ladder starts at ANONYMOUS`);
  return levels;
};

const TUNISIA_LADDER = identityLadder("tunisia-dtc");
const BOOKING_LADDER = identityLadder("demo-booking");
// The two domains disagree on every word above ANONYMOUS; the port must know none of them.
assert.deepEqual(
  TUNISIA_LADDER.filter((level) => BOOKING_LADDER.includes(level)),
  ["ANONYMOUS"],
  "the fixtures are only meaningful while the domains' vocabularies differ",
);

/** Domain policy for this fixture's action: everything above ANONYMOUS clears it. */
const SUFFICIENT_LEVELS = TUNISIA_LADDER.filter((level) => level !== "ANONYMOUS");
const SUFFICIENT_LEVEL = SUFFICIENT_LEVELS[0]; // CHANNEL-LINKED, as tunisia-dtc spells it
const HIGHER_LEVEL = SUFFICIENT_LEVELS[SUFFICIENT_LEVELS.length - 1];

// uuids, because `authorizations.action_id` is one and references `actions.id`.
const ACTION_ID = "6f1e7e8a-0b2c-4d3e-8f90-1a2b3c4d5e6f";
const OTHER_ACTION_ID = "9c8b7a65-4321-4fed-8cba-0987654321fe";
const ACTIONS = new Set([ACTION_ID, OTHER_ACTION_ID]);
const IDEMPOTENCY_KEY = "cart_add:conv_123:1";

const REQUEST: ActionRequest = {
  action_id: ACTION_ID,
  action_type: "cart_add",
  actor: "customer:cust_1",
  identity_assurance: SUFFICIENT_LEVEL,
  target: "cart:cart_1",
  requested_at: "2026-10-03T10:00:00.000Z",
  idempotency_key: IDEMPOTENCY_KEY,
};

const CONTEXT: AuthorizationContext = {
  domain: "tunisia-dtc",
  identity_assurance: SUFFICIENT_LEVEL,
  sufficient_identity_levels: SUFFICIENT_LEVELS,
  allowlisted_actions: ["cart_add", "cart_remove"],
  policy_version: "wf10-v4.1",
  request_id: "req_123",
  conversation_id: "conv_123",
  state_version: 27,
  normalized_parameters: { product_id: "123", quantity: 1 },
};

const execution = (over: Partial<ExecutionRequest> = {}): ExecutionRequest => ({
  authorization_id: "",
  action_id: ACTION_ID,
  idempotency_key: IDEMPOTENCY_KEY,
  request_hash: "h1",
  domain: "tunisia-dtc",
  workflow_id: "WF-20",
  ...over,
});

// --- 6. the LLM-reachable proposal type carries no authority -----------------

const proposal: ActionProposal = {
  action_type: "cart_add",
  target: "cart:cart_1",
  normalized_parameters: { product_id: "123", quantity: 1 },
  // @ts-expect-error ActionProposal has no execution_allowed member: an LLM
  // path cannot even express authority. Adding one breaks `pnpm build` here.
  execution_allowed: true,
};

// --- the n8n placeholders, executed -----------------------------------------

type CodeNode = { name: string; parameters: { jsCode?: string } };
type Workflow = { nodes: CodeNode[] };

const codeOf = (file: string, nodeName: string): string => {
  const wf: Workflow = JSON.parse(readFileSync(file, "utf8"));
  const node = wf.nodes.find((n) => n.name === nodeName);
  assert.ok(node, `${file}: node '${nodeName}' exists`);
  const jsCode = node.parameters.jsCode;
  assert.ok(jsCode, `${file}: node '${nodeName}' has a code body`);
  return jsCode;
};

type Item = { json: Record<string, unknown> };
const runCode = (jsCode: string, json: Record<string, unknown>): Item[] =>
  new Function("$json", "items", jsCode)(json, [{ json }]) as Item[];

// --- 5. no workflow JSON reads authority out of its own payload --------------

const WORKFLOW_ROOTS = ["runtime/n8n/workflows", "platform/workflows"];
const workflowFiles = WORKFLOW_ROOTS.flatMap((root) =>
  readdirSync(root, { recursive: true, encoding: "utf8" })
    .map((entry) => join(root, entry).replaceAll("\\", "/"))
    .filter((file) => file.endsWith(".json")),
);
assert.ok(workflowFiles.length > 20, "the scan must actually find the workflow files");

// Reading the flag is a workflow deciding its own authorization; writing it is
// a workflow manufacturing one. Naming the key to REFUSE it
// (`'execution_allowed' in x`) is neither, so the patterns are member access,
// index access and property assignment - not the bare quoted name.
//
// ponytail: a syntactic scan, and its ceiling is named rather than chased. It
// does not see a computed key (`const k='execution_allowed'; $json[k]=true`),
// a destructured read, or a node this file never executes. That is accepted
// because it is defence in depth only: the enforcement is the port, and a
// workflow that manufactures the flag still gets nowhere, because the gate
// reads the column from the stored record and WF-20 refuses the key outright.
// Upgrade path if the graphs ever stop being placeholders: parse the jsCode
// and walk it, or execute every node and assert on the outputs.
const forbidden = [/\.execution_allowed\b/, /\[\s*["']execution_allowed["']\s*\]/, /execution_allowed\s*:/];
const offenders = workflowFiles.flatMap((file) => {
  const contents = readFileSync(file, "utf8");
  return forbidden.filter((re) => re.test(contents)).map((re) => `${file}: ${re}`);
});
assert.deepEqual(
  offenders,
  [],
  `a workflow reads or writes execution_allowed in its payload:\n${offenders.join("\n")}`,
);

// WF-10's authorization node cannot grant, and refuses a caller that tries to.
const WF10 = "runtime/n8n/workflows/WF-10.json";
const wf10Auth = codeOf(WF10, "Refuse Caller-Supplied Authority");
const PLAUSIBLE = {
  action: { allowlisted: true },
  scope: { valid: true },
  identity: { assurance: SUFFICIENT_LEVEL },
};

const granted = runCode(wf10Auth, { ...PLAUSIBLE });
for (const item of granted) {
  assert.equal(
    item.json.execution_allowed,
    undefined,
    "the authorization placeholder must not put execution_allowed on the item",
  );
  assert.equal(item.json.authorization_decision, undefined, "nor a decision: the port decides");
}

for (const [label, payload] of [
  ["the flag", { ...PLAUSIBLE, execution_allowed: true }],
  ["a decision", { ...PLAUSIBLE, authorization_decision: "AUTHORIZED" }],
  ["an authorization id", { ...PLAUSIBLE, authorization_id: randomUUID() }],
] as const) {
  assert.throws(
    () => runCode(wf10Auth, { ...payload }),
    /caller_supplied_authorization_fields/,
    `WF-10 refuses a caller supplying ${label}`,
  );
}

// The audit event type is not derived from a payload flag either: audit is not
// authorization (AGENTS.md:36).
const wf10Evidence = codeOf(WF10, "Authorization Evidence");
assert.equal(runCode(wf10Evidence, {})[0].json.audit_event_type, "AuthorizationRequested");
assert.equal(
  runCode(wf10Evidence, { execution_allowed: true })[0].json.audit_event_type,
  "AuthorizationRequested",
  "a payload flag must not promote the audit event to ActionAuthorized",
);

// WF-20's gate accepts an authorization_id as the only authority it carries.
const wf20Gate = codeOf("runtime/n8n/workflows/WF-20.json", "Execution Gate");
const EXEC_PAYLOAD = { allowlisted_operation: "cart_add", idempotency_key: IDEMPOTENCY_KEY };

// Each forbidden key, and each of them ALONGSIDE a well-formed authorization
// id: the refusal is of the key itself, not a side effect of the id being
// missing. Checking only `execution_allowed` left the other two droppable.
for (const key of ["execution_allowed", "authorization_decision", "decision"] as const) {
  assert.throws(
    () => runCode(wf20Gate, { ...EXEC_PAYLOAD, [key]: true }),
    /caller_supplied_authorization_fields/,
    `WF-20 refuses a payload carrying ${key}`,
  );
  assert.throws(
    () => runCode(wf20Gate, { ...EXEC_PAYLOAD, authorization_id: randomUUID(), [key]: "AUTHORIZED" }),
    /caller_supplied_authorization_fields/,
    `WF-20 refuses ${key} even next to a real authorization id`,
  );
}
assert.throws(
  () => runCode(wf20Gate, { ...EXEC_PAYLOAD }),
  /authorization_id_required/,
  "WF-20 requires an authorization id, not a flag",
);
assert.equal(
  runCode(wf20Gate, { ...EXEC_PAYLOAD, authorization_id: randomUUID() }).length,
  1,
  "an authorization id passes the graph; the record itself is verified in TypeScript",
);

// --- 5b. the pre-change gate, to show these cases are not vacuous ------------
//
// The body of WF-20's Execution Gate as it stood at f732d44, inlined. An
// earlier round read it out of `git show origin/main:` instead, which was
// wrong in both directions: once this merges, origin/main IS this change, the
// gate throws, and the suite goes red on main for everyone who fetched it;
// while in a shallow PR checkout the ref is absent and the whole block
// silently passed, proving nothing exactly where it runs. A string executed
// under the same `runCode` proves the same thing and depends on nothing.
const PRE_CHANGE_GATE =
  "const x=$json;if(x.execution_allowed!==true)throw new Error('execution_not_authorized');" +
  "if(!x.allowlisted_operation)throw new Error('operation_not_allowlisted');" +
  "if(x.client_supplied_credentials)throw new Error('client_credentials_forbidden');return items;";

assert.equal(
  runCode(PRE_CHANGE_GATE, { ...EXEC_PAYLOAD, execution_allowed: true }).length,
  1,
  "the pre-change gate granted execution on a payload flag: that is what this task removes",
);
assert.throws(
  () => runCode(PRE_CHANGE_GATE, { ...EXEC_PAYLOAD, authorization_id: randomUUID() }),
  /execution_not_authorized/,
  "and refused a real authorization id, having nothing to verify it against",
);

// --- the port and the gate ---------------------------------------------------

async function main() {
  // --- 1 / 3. a request that carries its own authorization is DENIED --------
  {
    const { store } = createStoreDouble();
    const record = await authorizeAction(
      store,
      { ...REQUEST, execution_allowed: true, authorization_decision: "AUTHORIZED" },
      CONTEXT,
    );

    assert.equal(record.decision, "DENIED", "a caller-supplied decision is a denial, not an input");
    assert.equal(record.execution_allowed, false);

    const stored = await store.findById(record.authorization_id);
    assert.ok(stored, "the decision is persisted, denials included");
    assert.equal(stored.decision, "DENIED");
    assert.equal(stored.execution_allowed, false, "the stored record must not carry authority");
    assert.equal(stored.expires_at, null, "a denial has no execution window");
    assert.match(String(stored.scope.reasons), /caller_supplied_authorization_fields/);
    // The record holds the request the port decided on, and it holds only the
    // contract's fields: the smuggled keys are gone, not carried along.
    assert.deepEqual(
      Object.keys(stored.scope.action_request as object).sort(),
      [...ACTION_REQUEST_FIELDS].sort(),
      "the supplied flag is stripped, not copied into the record",
    );
    // Nowhere in the stored record, at any depth, is there a true flag. (The
    // denial reason names the keys the caller sent, which is the point of it.)
    assert.equal(
      JSON.stringify(stored).includes('execution_allowed":true'),
      false,
      "no part of the record carries the authority the caller asked for",
    );

    // Same attempt via the LLM-reachable proposal type. The port's input is
    // untrusted JSON, so the cast is the real call shape. A proposal names no
    // action id, so the denial cannot be stored - what is asserted is the
    // decision the port tried to write.
    const proposed = createStoreDouble();
    await assert.rejects(
      () => authorizeAction(proposed.store, proposal as unknown as UntrustedActionRequest, CONTEXT),
      /22P02/,
      "a proposal has no action to bind a record to",
    );
    assert.equal(proposed.rows.size, 0, "and nothing was stored");
    assert.equal(proposed.attempted()?.decision, "DENIED", "an LLM proposal cannot authorize itself");
    assert.equal(proposed.attempted()?.execution_allowed, false);
    assert.match(
      String(proposed.attempted()?.scope.reasons),
      /caller_supplied_authorization_fields:execution_allowed/,
      "and the flag it carried is named as the reason, not honoured",
    );
  }

  // --- the AUTHORIZED path, so the denials above are not vacuous -----------
  {
    const { store } = createStoreDouble();
    const now = new Date("2026-10-03T10:00:01.000Z");
    const record = await authorizeAction(store, { ...REQUEST }, { ...CONTEXT, now });

    assert.equal(record.decision, "AUTHORIZED");
    assert.equal(record.execution_allowed, true);
    assert.equal(record.expires_at?.getTime(), now.getTime() + DEFAULT_TTL_SECONDS * 1000);

    const stored = await store.findById(record.authorization_id);
    assert.ok(stored);
    assert.equal(stored.execution_allowed, true, "the authority is in the row, not in a payload");
    assert.equal(
      stored.identity_level,
      SUFFICIENT_LEVEL,
      "the durable identity level is recorded, in the domain's own spelling",
    );
    assert.equal(stored.request_id, "req_123");
    assert.equal(stored.conversation_id, "conv_123");
    assert.equal(stored.state_version, 27);
    assert.equal(stored.idempotency_key, REQUEST.idempotency_key);
    assert.equal(stored.policy_version, "wf10-v4.1");
    assert.equal(stored.scope.authorized_by_role, AUTHORIZATION_ROLE, "a role, never a workflow id");
    assert.deepEqual(stored.scope.action_request, REQUEST, "the authorized request is in the record");
    assert.deepEqual(stored.scope.normalized_parameters, CONTEXT.normalized_parameters);
    assert.deepEqual(stored.scope.reasons, []);

    // The TTL is context, not a constant the caller can stretch from the request.
    const short = await authorizeAction(store, { ...REQUEST }, { ...CONTEXT, now, ttl_seconds: 30 });
    assert.equal(short.expires_at?.getTime(), now.getTime() + 30_000);
  }

  // --- deny-by-default: the two gates in scope, and completeness ------------
  {
    const { store } = createStoreDouble();
    const denied = async (request: UntrustedActionRequest, context: AuthorizationContext, why: string) => {
      const record = await authorizeAction(store, request, context);
      assert.equal(record.decision, "DENIED", why);
      assert.equal(record.execution_allowed, false, why);
      return String(record.scope.reasons);
    };

    assert.match(
      await denied({ ...REQUEST }, { ...CONTEXT, identity_assurance: "ANONYMOUS" }, "anonymous identity"),
      /identity_assurance_insufficient/,
    );
    // ANONYMOUS is the one level the platform rules out itself: a domain that
    // lists it as sufficient still gets a denial.
    assert.match(
      await denied(
        { ...REQUEST, identity_assurance: "ANONYMOUS" },
        {
          ...CONTEXT,
          identity_assurance: "ANONYMOUS",
          sufficient_identity_levels: [...TUNISIA_LADDER],
        },
        "a domain cannot make ANONYMOUS sufficient",
      ),
      /identity_assurance_insufficient/,
    );
    assert.match(
      await denied({ ...REQUEST }, { ...CONTEXT, identity_assurance: "" }, "absent identity level"),
      /identity_assurance_insufficient/,
    );
    assert.match(
      await denied(
        { ...REQUEST },
        { ...CONTEXT, identity_assurance: "SUPERUSER" },
        "a level invented by the model is in no ladder",
      ),
      /identity_assurance_insufficient/,
    );
    // The sufficient levels are the DOMAIN's, so another domain's vocabulary
    // does not clear this one's gate - in either direction. A port carrying its
    // own list of level names passes one of these and fails the other.
    assert.match(
      await denied(
        { ...REQUEST, identity_assurance: BOOKING_LADDER[1] },
        { ...CONTEXT, identity_assurance: BOOKING_LADDER[1] },
        "demo-booking's level against tunisia-dtc's ladder",
      ),
      /identity_assurance_insufficient/,
    );
    assert.match(
      await denied(
        { ...REQUEST },
        { ...CONTEXT, sufficient_identity_levels: BOOKING_LADDER.slice(1) },
        "tunisia-dtc's level against demo-booking's ladder",
      ),
      /identity_assurance_insufficient/,
    );
    assert.match(
      await denied(
        { ...REQUEST },
        { ...CONTEXT, sufficient_identity_levels: [] },
        "no sufficient level declared denies everything",
      ),
      /identity_assurance_insufficient/,
    );
    // The comparison is exact. Normalising separators - treating
    // CHANNEL_LINKED as CHANNEL-LINKED - is the same bug this round removed,
    // in the lenient direction: it would make one domain's spelling clear
    // another's gate.
    assert.notEqual(SUFFICIENT_LEVEL, SUFFICIENT_LEVEL.replace("-", "_"), "the level has a separator");
    assert.match(
      await denied(
        { ...REQUEST },
        { ...CONTEXT, sufficient_identity_levels: [SUFFICIENT_LEVEL.replace("-", "_")] },
        "the same level with the separator swapped is a different level",
      ),
      /identity_assurance_insufficient/,
    );
    // A level of the same ladder, one rung lower than the action needs.
    assert.match(
      await denied(
        { ...REQUEST },
        { ...CONTEXT, sufficient_identity_levels: [HIGHER_LEVEL] },
        "a level below what this action requires",
      ),
      /identity_assurance_insufficient/,
    );
    // Identity promotion by the model: the request claims a level the durable
    // context does not hold, and the claimed level is itself sufficient, so
    // only the comparison against the context catches it
    // (08-WF-10-SECURITY-OWASP-TESTS.md:7).
    assert.ok(SUFFICIENT_LEVELS.includes(HIGHER_LEVEL), "the claimed level is one that would pass");
    assert.match(
      await denied({ ...REQUEST, identity_assurance: HIGHER_LEVEL }, CONTEXT, "claimed identity promotion"),
      /identity_claim_mismatch/,
    );
    assert.match(
      await denied({ ...REQUEST, action_type: "refund_order" }, CONTEXT, "unknown action"),
      /action_not_allowlisted/,
    );
    assert.match(
      await denied({ ...REQUEST }, { ...CONTEXT, allowlisted_actions: [] }, "empty allowlist denies all"),
      /action_not_allowlisted/,
    );

    // Every contract field is required: dropping any one denies.
    for (const field of ACTION_REQUEST_FIELDS) {
      const partial: UntrustedActionRequest = { ...REQUEST };
      delete partial[field];

      if (field === "action_id") {
        // The decision is still a denial, but it cannot be STORED: the row has
        // no action to bind to and `action_id` is `uuid NOT NULL REFERENCES
        // actions(id)`, so the real table raises 22P02. Nothing is authorized
        // either way; what is lost is the audit row. Captured rather than
        // asserted through the store, so both halves are pinned - the port's
        // decision and the limitation. The fix belongs with the grant path
        // (NAD-006), and this case fails if it is ever changed quietly.
        const capture = createStoreDouble();
        await assert.rejects(
          () => authorizeAction(capture.store, partial, CONTEXT),
          /22P02/,
          "a denial with no action id cannot be stored against the real table",
        );
        assert.equal(capture.rows.size, 0, "no row exists, under any substituted id");
        assert.equal(
          capture.attempted()?.decision,
          "DENIED",
          "and the decision it tried to store was a denial",
        );
        assert.equal(capture.attempted()?.execution_allowed, false);
        assert.match(String(capture.attempted()?.scope.reasons), /action_request_incomplete:action_id/);
        continue;
      }

      assert.match(
        await denied(partial, CONTEXT, `missing ${field}`),
        new RegExp(`action_request_incomplete:${field}`),
      );
    }
  }

  // --- 2 / 4. the execution gate -------------------------------------------
  {
    const { store, put } = createStoreDouble();
    const { reserve } = createReserveDouble();
    const deps = { store, reserve };

    // A payload flag with no authorization id gets nowhere. This is the case
    // WF-20 passed before NAD-015.
    await assert.rejects(
      () =>
        requireAuthorizedExecution(deps, {
          ...execution(),
          execution_allowed: true,
        } as unknown as ExecutionRequest),
      /authorization_id_required/,
      "no stored authorization, no execution",
    );

    await assert.rejects(
      () => requireAuthorizedExecution(deps, execution({ authorization_id: randomUUID() })),
      /authorization_not_found/,
      "an id that is not in the table authorizes nothing",
    );

    // The idempotency reservation is what stops a replay, so its inputs are
    // required before anything executes: `idempotency_keys.request_hash` is
    // NOT NULL, and `request_hash <> NULL` is never true, so a missing hash
    // would make every replay look like a first delivery.
    for (const [label, over] of [
      ["no idempotency key", { idempotency_key: "" }],
      ["no request hash", { request_hash: "" }],
    ] as const) {
      await assert.rejects(
        () => requireAuthorizedExecution(deps, execution({ authorization_id: put({}), ...over })),
        label === "no request hash" ? /request_hash_required/ : /idempotency_key_required/,
        label,
      );
    }

    // The domain name becomes a path segment under domains/. Each character
    // class is pinned separately: '../../etc' alone needs both the dot and the
    // slash refused, so a regex that admitted only one of them survived it -
    // and '..' alone resolves to <repo>/domain.yaml, one level above domains/.
    // `undefined` is in the list because DOMAIN_NAME.test(undefined) coerces to
    // the string "undefined", which MATCHES, so the typeof guard is the only
    // thing refusing it.
    for (const domain of [
      "../../etc",
      "..",
      "a.b",
      "a/b",
      "a\b",
      "tunisia dtc",
      "Tunisia-DTC",
      "",
      undefined as unknown as string,
    ]) {
      await assert.rejects(
        () => requireAuthorizedExecution(deps, execution({ authorization_id: put({}), domain })),
        /domain_invalid/,
        `a domain name of '${String(domain)}' never reaches the filesystem`,
      );
    }

    // A DENIED record, and the same record with a payload flag alongside it:
    // the flag changes nothing because nothing reads it.
    const deniedId = put({ decision: "DENIED", execution_allowed: false, expires_at: null });
    for (const [label, extra] of [
      ["a denied record", {}],
      ["a denied record plus the flag", { execution_allowed: true }],
    ] as const) {
      await assert.rejects(
        () =>
          requireAuthorizedExecution(deps, {
            ...execution({ authorization_id: deniedId }),
            ...extra,
          } as unknown as ExecutionRequest),
        /execution_not_authorized/,
        label,
      );
    }

    // Hostile storage: AUTHORIZED without the column, or the column without
    // the decision. Both halves are required (01-WF-10-AUTHORIZATION-SPEC:27).
    await assert.rejects(
      () =>
        requireAuthorizedExecution(
          deps,
          execution({ authorization_id: put({ decision: "AUTHORIZED", execution_allowed: false }) }),
        ),
      /execution_not_authorized/,
      "AUTHORIZED without execution_allowed is not authority",
    );
    await assert.rejects(
      () =>
        requireAuthorizedExecution(
          deps,
          execution({
            authorization_id: put({ decision: "NEEDS_VERIFICATION", execution_allowed: true }),
          }),
        ),
      /execution_not_authorized/,
      "execution_allowed without AUTHORIZED is not authority",
    );

    await assert.rejects(
      () =>
        requireAuthorizedExecution(
          deps,
          execution({ authorization_id: put({ expires_at: new Date(Date.now() - 1000) }) }),
        ),
      /authorization_expired/,
      "an expired authorization is refused",
    );
    await assert.rejects(
      () => requireAuthorizedExecution(deps, execution({ authorization_id: put({ expires_at: null }) })),
      /authorization_expired/,
      "a record with no expiry has no execution window",
    );
    // The boundary itself: expiry is exclusive, so a record does not execute at
    // the instant it expires. `<` instead of `<=` reads the same on every other
    // case in this file.
    const expiresNow = new Date("2026-10-03T10:05:00.000Z");
    await assert.rejects(
      () =>
        requireAuthorizedExecution(
          { store, reserve, now: expiresNow },
          execution({ authorization_id: put({ expires_at: expiresNow }) }),
        ),
      /authorization_expired/,
      "an authorization does not execute at exactly its expiry instant",
    );
    await assert.rejects(
      () =>
        requireAuthorizedExecution(
          deps,
          execution({ authorization_id: put({ action_id: OTHER_ACTION_ID }) }),
        ),
      /authorization_action_mismatch/,
      "an authorization is bound to the action it was issued for",
    );
    await assert.rejects(
      () =>
        requireAuthorizedExecution(
          deps,
          execution({ authorization_id: put({ idempotency_key: "cart_add:conv_123:9" }) }),
        ),
      /authorization_idempotency_mismatch/,
      "and to the idempotency key it was issued against",
    );

    // Absent, not merely wrong. Every one of these is a row the port would
    // never write but storage can hold: 0006 made the correlation columns
    // nullable, and a tampered or part-migrated row can be missing anything.
    // Checks written as `!== expected` cover all three today; these cases stop
    // a later relaxation to `field && field !== expected` shipping green.
    for (const [label, record, expected] of [
      ["no decision at all", { decision: undefined }, /execution_not_authorized/],
      ["no action binding", { action_id: undefined }, /authorization_action_mismatch/],
      ["a null idempotency key", { idempotency_key: null }, /authorization_idempotency_mismatch/],
      // Unreachable from the real table - the column is `boolean NOT NULL` and
      // 0006 did not touch it - but `=== false` instead of `!== true` would let
      // it through, and the trio above would not notice.
      ["no execution_allowed column", { execution_allowed: undefined }, /execution_not_authorized/],
    ] as const) {
      await assert.rejects(
        () =>
          requireAuthorizedExecution(
            deps,
            execution({ authorization_id: put(record as Partial<AuthorizationRecord>) }),
          ),
        expected,
        `storage with ${label} authorizes nothing`,
      );
    }
  }

  // --- 5. role resolution comes from the domain, never from a literal ------
  {
    const { store, put } = createStoreDouble();
    const { reserve } = createReserveDouble();
    const authorized = put({});

    assert.equal(workflowForRole("tunisia-dtc", "privileged_external_execution"), "WF-20");
    assert.equal(workflowForRole("tunisia-dtc", AUTHORIZATION_ROLE), "WF-10");
    assert.equal(workflowForRole("demo-booking", AUTHORIZATION_ROLE), "BOOK-AUTHZ");
    // The guard is on the resolver, where every caller passes, not on the one
    // call site above it.
    assert.throws(() => workflowForRole("../../etc", AUTHORIZATION_ROLE), /domain_invalid/);
    assert.equal(
      workflowForRole("tunisia-dtc", "no_such_role"),
      undefined,
      "an unfilled role resolves to nothing",
    );

    await assert.rejects(
      () =>
        requireAuthorizedExecution(
          { store, reserve },
          execution({ authorization_id: authorized, workflow_id: "WF-05" }),
        ),
      /executor_role_mismatch/,
      "a workflow that does not fill the execution role may not execute",
    );

    // demo-booking declares no privileged_external_execution role, so no
    // workflow in it may execute - including one called WF-20. A hardcoded id
    // would pass this.
    await assert.rejects(
      () =>
        requireAuthorizedExecution(
          { store, reserve },
          execution({ authorization_id: authorized, domain: "demo-booking" }),
        ),
      /executor_role_not_declared/,
      "role resolution is read from the domain's own workflow_roles block",
    );
  }

  // --- 4. one execution per authorization, then the idempotency gate -------
  {
    const { store, put } = createStoreDouble();
    const { reserve, keys } = createReserveDouble();
    const deps = { store, reserve };
    const authorized = put({});

    const record = await requireAuthorizedExecution(deps, execution({ authorization_id: authorized }));
    assert.equal(record.authorization_id, authorized);
    assert.equal(record.execution_allowed, true, "the gate returns the record it verified");
    assert.equal(keys.size, 1, "a verified execution reserves its idempotency key");
    // WHICH key, not just how many. Reserving the authorization_id instead
    // counts the same and defends nothing: ids are unique per authorization, so
    // two authorizations of one operation would both execute.
    assert.deepEqual([...keys.keys()], [IDEMPOTENCY_KEY], "the key reserved is the action's idempotency key");
    assert.equal(keys.get(IDEMPOTENCY_KEY)?.hash, "h1", "and it is reserved under this request's hash");

    await assert.rejects(
      () => requireAuthorizedExecution(deps, execution({ authorization_id: authorized })),
      /execution_already_reserved/,
      "replaying an authorized execution is refused by the idempotency gate",
    );
    assert.equal(keys.size, 1, "and reserves nothing new");

    // A SECOND authorization record over the same idempotency key. This is the
    // replay that matters - one business operation authorized twice - and it is
    // caught only because the key, not the authorization, is what gets
    // reserved (IDEMP-001).
    const reauthorized = put({});
    assert.notEqual(reauthorized, authorized, "a distinct record for the same operation");
    await assert.rejects(
      () => requireAuthorizedExecution(deps, execution({ authorization_id: reauthorized })),
      /execution_already_reserved/,
      "a second authorization over the same key does not buy a second execution",
    );
    assert.equal(keys.size, 1);

    await assert.rejects(
      () => requireAuthorizedExecution(deps, execution({ authorization_id: authorized, request_hash: "h2" })),
      /idempotency_key_conflict/,
      "the same key with a different request body conflicts rather than executing",
    );
  }

  // --- the write seam holds the same invariant as the decision -------------
  {
    // No database is touched: the guard runs before the insert, which is the
    // point - a caller reaching the repository directly cannot store authority
    // without the decision that grants it.
    const repository = createAuthorizationRepository({} as never);
    const row: NewAuthorizationRecord = {
      action_id: REQUEST.action_id,
      request_id: null,
      conversation_id: null,
      identity_level: SUFFICIENT_LEVEL,
      state_version: null,
      idempotency_key: REQUEST.idempotency_key,
      decision: "DENIED",
      execution_allowed: true,
      policy_version: "wf10-v4.1",
      scope: {},
      expires_at: new Date(Date.now() + 60_000),
    };

    await assert.rejects(
      () => repository.insert(row),
      /execution_allowed_requires_authorized_decision/,
      "the repository refuses to write authority without AUTHORIZED",
    );
    // The guard is specific: an AUTHORIZED row gets past it and fails later, on
    // the absent database. A mutant that always throws the guard fails here.
    await assert.rejects(
      () => repository.insert({ ...row, decision: "AUTHORIZED" }),
      (error: Error) => !/execution_allowed_requires_authorized_decision/.test(error.message),
      "an AUTHORIZED row is not blocked by the write guard",
    );
  }
}

main().then(() => {
  console.log("PASS: action authorization boundary (port decides, executor verifies the stored record)");
});
