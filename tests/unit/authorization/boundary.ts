/**
 * Behavioural tests for the action authorization boundary (NAD-015, RT-001).
 *
 * Every case here fails against the checkout before this task: there was no
 * decision port and no execution gate at all, WF-10 computed
 * `execution_allowed` from fields of its own input, and WF-20's gate was
 * `if ($json.execution_allowed !== true) throw`. The last section re-runs the
 * pre-change gate out of `git show origin/main:` to prove exactly that, so the
 * regression this file pins is demonstrated rather than asserted.
 *
 * Nothing here pins source text. The port and the gate are called, the n8n
 * Code nodes are EXECUTED under stubs for `$json` and `items`, and the
 * assertions are on what came back. The store double mirrors the
 * `authorizations` table and the reserve double mirrors
 * `private.reserve_idempotency` (migration 0003), so the records are read back
 * from storage rather than from the object the port happened to return.
 */
import assert from "node:assert/strict";
import { spawnSync } from "node:child_process";
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

/**
 * The `authorizations` table. `id` and `created_at` are the database's
 * (0001_domain_state.sql:23,30), and rows are cloned in and out so a test
 * reads what was stored, not the caller's object.
 */
function createStoreDouble() {
  const rows = new Map<string, AuthorizationRecord>();
  const store: AuthorizationStore = {
    async insert(record: NewAuthorizationRecord) {
      const row: AuthorizationRecord = {
        ...record,
        authorization_id: randomUUID(),
        created_at: new Date(),
      };
      rows.set(row.authorization_id, structuredClone(row));
      return structuredClone(row);
    },
    async findById(id: string) {
      const row = rows.get(id);
      return row && structuredClone(row);
    },
  };
  /** Write a row the port would never write, to test the gate against hostile storage. */
  const put = (record: Partial<AuthorizationRecord>): string => {
    const id = randomUUID();
    rows.set(id, {
      authorization_id: id,
      action_id: REQUEST.action_id,
      request_id: null,
      conversation_id: null,
      identity_level: "CHANNEL_LINKED",
      state_version: null,
      idempotency_key: REQUEST.idempotency_key,
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
  return { store, rows, put };
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

const REQUEST: ActionRequest = {
  action_id: "act_123",
  action_type: "cart_add",
  actor: "customer:cust_1",
  identity_assurance: "CHANNEL_LINKED",
  target: "cart:cart_1",
  requested_at: "2026-10-03T10:00:00.000Z",
  idempotency_key: "cart_add:conv_123:1",
};

const CONTEXT: AuthorizationContext = {
  domain: "tunisia-dtc",
  identity_assurance: "CHANNEL_LINKED",
  allowlisted_actions: ["cart_add", "cart_remove"],
  policy_version: "wf10-v4.1",
  request_id: "req_123",
  conversation_id: "conv_123",
  state_version: 27,
  normalized_parameters: { product_id: "123", quantity: 1 },
};

const execution = (over: Partial<ExecutionRequest> = {}): ExecutionRequest => ({
  authorization_id: "",
  action_id: REQUEST.action_id,
  idempotency_key: REQUEST.idempotency_key,
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
  identity: { assurance: "CHANNEL_LINKED" },
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
const EXEC_PAYLOAD = { allowlisted_operation: "cart_add", idempotency_key: REQUEST.idempotency_key };

assert.throws(
  () => runCode(wf20Gate, { ...EXEC_PAYLOAD, execution_allowed: true }),
  /caller_supplied_authorization_fields/,
  "WF-20 refuses a payload flag outright",
);
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

const show = spawnSync("git", ["show", "origin/main:runtime/n8n/workflows/WF-20.json"], {
  encoding: "utf8",
});
if (show.status === 0) {
  const before: Workflow = JSON.parse(show.stdout);
  const beforeGate = before.nodes.find((n) => n.name === "Execution Gate")?.parameters.jsCode;
  assert.ok(beforeGate, "origin/main has an Execution Gate to compare against");
  assert.equal(
    runCode(beforeGate, { ...EXEC_PAYLOAD, execution_allowed: true }).length,
    1,
    "the gate on origin/main granted execution on a payload flag: that is what this file removes",
  );
  assert.throws(
    () => runCode(beforeGate, { ...EXEC_PAYLOAD, authorization_id: randomUUID() }),
    /execution_not_authorized/,
    "and refused a real authorization id, having nothing to verify it against",
  );
} else {
  console.log("note: origin/main not available; the pre-change comparison was skipped");
}

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

    // Same request, via the LLM-reachable proposal type. The port's input is
    // untrusted JSON, so the cast is the real call shape.
    const fromProposal = await authorizeAction(store, proposal as unknown as UntrustedActionRequest, CONTEXT);
    assert.equal(fromProposal.decision, "DENIED", "an LLM proposal cannot authorize itself");
    assert.equal(fromProposal.execution_allowed, false);
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
    assert.equal(stored.identity_level, "CHANNEL_LINKED", "the durable identity level is recorded");
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
    assert.match(
      await denied({ ...REQUEST }, { ...CONTEXT, identity_assurance: "" }, "absent identity level"),
      /identity_assurance_insufficient/,
    );
    assert.match(
      await denied(
        { ...REQUEST },
        { ...CONTEXT, identity_assurance: "SUPERUSER" },
        "a level the platform does not recognise",
      ),
      /identity_assurance_insufficient/,
    );
    // Identity promotion by the model: the request claims a level the durable
    // context does not hold (08-WF-10-SECURITY-OWASP-TESTS.md:7).
    assert.match(
      await denied({ ...REQUEST, identity_assurance: "VERIFIED" }, CONTEXT, "claimed identity promotion"),
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
    await assert.rejects(
      () => requireAuthorizedExecution(deps, execution({ authorization_id: put({ action_id: "act_999" }) })),
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
  }

  // --- 5. role resolution comes from the domain, never from a literal ------
  {
    const { store, put } = createStoreDouble();
    const { reserve } = createReserveDouble();
    const authorized = put({});

    assert.equal(workflowForRole("tunisia-dtc", "privileged_external_execution"), "WF-20");
    assert.equal(workflowForRole("tunisia-dtc", AUTHORIZATION_ROLE), "WF-10");
    assert.equal(workflowForRole("demo-booking", AUTHORIZATION_ROLE), "BOOK-AUTHZ");

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

    await assert.rejects(
      () => requireAuthorizedExecution(deps, execution({ authorization_id: authorized })),
      /execution_already_reserved/,
      "replaying an authorized execution is refused by the idempotency gate",
    );
    assert.equal(keys.size, 1, "and reserves nothing new");

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
      identity_level: "CHANNEL_LINKED",
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
