/**
 * Guards around the inbound webhook. All of these fail against the checkout
 * before NAD-016.
 *
 * The gateway's Code nodes are EXECUTED here, under stubs for `$input`,
 * `$env`, `$`, `require` and `console`, and asserted on their behaviour. Two
 * earlier rounds of this file pinned source lines instead, and that is not the
 * same thing: with `if (!signed && !allowUnverified)` pinned, dropping the
 * `return` on the line below it accepted a forged webhook with the whole suite
 * green. Pinning text proves the text is there, never that it decides
 * anything. Only structural facts - wiring, response codes, node options - are
 * asserted as data, because those are not code.
 *
 * Both copies of the gateway are checked, the shared library's and the
 * reference domain's package copy: mutating only the domain copy survived a
 * round of these tests.
 */
import assert from "node:assert/strict";
import { spawnSync } from "node:child_process";
import crypto, { createHash, createHmac } from "node:crypto";
import { readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";
import { verifyMetaSignature } from "../../../platform/channels/meta-signature";

const ROOTS = ["runtime/n8n/workflows", "platform/workflows", "domains"];

const workflowJson = (root: string): string[] =>
  readdirSync(root, { recursive: true, encoding: "utf8" })
    .map((entry) => join(root, entry).replaceAll("\\", "/"))
    .filter((file) => file.endsWith(".json"));

const files = ROOTS.flatMap(workflowJson);
assert.ok(files.length > 20, "the scan must actually find the workflow files");

// A self-declared verdict in the payload is not evidence of anything: whoever
// posts the payload would be deciding. Verification happens in the channel
// port's verify operation, over the raw bytes, before normalisation.
const banned = [
  "PENDING_HMAC_VALIDATION",
  "$json.signature_valid",
  "$json.replay_detected",
  "signature_valid",
  "replay_detected",
];

const offenders: string[] = [];
for (const file of files) {
  const contents = readFileSync(file, "utf8");
  for (const token of banned) {
    if (contents.includes(token)) offenders.push(`${file}: ${token}`);
  }
}
assert.deepEqual(offenders, [], `workflow trusts a caller-supplied verdict:\n${offenders.join("\n")}`);

// Constant-time comparison is the one property no behavioural test can see:
// `provided.equals(expected)` returns the same booleans and leaks timing. It
// has to be read in the source, in the module and in the node's copy below.
const moduleSource = readFileSync("platform/channels/meta-signature.ts", "utf8");
assert.match(
  moduleSource,
  /timingSafeEqual\(provided, expected\)/,
  "the module compares the digests in constant time",
);

type NodeParameters = {
  jsCode?: string;
  responseBody?: string;
  options?: { rawBody?: boolean; responseCode?: number; queryReplacement?: string };
  conditions?: { boolean?: { value1?: string; operation?: string }[] };
};
type Node = { name: string; parameters: NodeParameters; onError?: string };
type Workflow = { nodes: Node[]; connections: Record<string, { main: { node: string }[][] }> };

/** What the two Code nodes under test put on the item. */
type GatewayJson = {
  security?: { decision?: string; reason?: string };
  event?: {
    page_id?: string;
    message_id?: string | null;
    idempotency_key?: string | null;
    operation?: string;
    request_hash?: string;
  };
  idempotency?: { status?: string; duplicate?: boolean; conflict?: boolean };
};
type Item = { json: Record<string, unknown>; binary?: Record<string, { data: string }> };

const SECRET = "e4f0f0c6a8b24d1f9c3e7a5b1d8f2c60";
const POST = "META Events — POST"; // the node name carries an em dash

const messaging = (event: Record<string, unknown>) => ({
  object: "page",
  entry: [
    {
      id: "P1",
      time: 1758579000000,
      messaging: [{ sender: { id: "U1" }, recipient: { id: "P1" }, timestamp: 1758578999000, ...event }],
    },
  ],
});
const TEXT = messaging({ message: { mid: "m_1", text: "bonjour" } });
const READ_RECEIPT = messaging({ read: { watermark: 1758578999000 } });
const REACTION = messaging({ reaction: { mid: "m_r", action: "react", emoji: "❤" } });

const bytes = (body: unknown) => Buffer.from(JSON.stringify(body), "utf8");
const sign = (body: unknown, secret = SECRET) =>
  `sha256=${createHmac("sha256", secret).update(bytes(body)).digest("hex")}`;

/** What the Capture Meta Request node hands the gate. */
const delivery = (body: unknown, header?: string, rawBodyPresent = true): Item => ({
  json: { request: { headers: header === undefined ? {} : { "x-hub-signature-256": header }, body } },
  binary: rawBodyPresent ? { data: { data: bytes(body).toString("base64") } } : undefined,
});

const stubRequire = (name: string) => {
  if (name === "crypto") return crypto;
  throw new Error(`the gate must not require '${name}'`);
};

const runVerify = (jsCode: string, item: Item, env: Record<string, string>) => {
  const logs: string[] = [];
  const out = new Function("$input", "$env", "require", "console", jsCode)(
    { first: () => item },
    env,
    stubRequire,
    { log: (line: string) => logs.push(String(line)) },
  ) as { json: GatewayJson }[];
  return { json: out[0].json, logs: logs.join("\n") };
};

const verifiers: string[] = [];
const classifiers: string[] = [];

const GATEWAYS = [
  "platform/workflows/channels/messenger-inbound/workflow.json",
  "domains/tunisia-dtc/workflow-packages/WF-00/tunisia-dtc-agent-wf00-inbound-gateway/workflow/WF-00-inbound-gateway-facebook-messenger.json",
];

for (const file of GATEWAYS) {
  const wf: Workflow = JSON.parse(readFileSync(file, "utf8"));
  const node = (name: string) => {
    const found = wf.nodes.find((n) => n.name === name);
    assert.ok(found, `${file}: node '${name}' exists`);
    return found as Node;
  };
  const code = (name: string) => {
    const jsCode = node(name).parameters.jsCode;
    assert.ok(jsCode, `${file}: node '${name}' has a code body`);
    return jsCode as string;
  };

  // --- structural: the raw bytes have to survive the webhook node ---
  assert.equal(node(POST).parameters.options?.rawBody, true, `${file}: the POST webhook keeps the raw body`);
  assert.ok(
    code("Capture Meta Request").includes("binary: $binary"),
    `${file}: the capture node carries the raw body forward, or the gate has nothing to hash`,
  );

  // --- behaviour: the gate, executed ---
  const verify = code("Verify Meta Signature");
  verifiers.push(verify);
  assert.match(
    verify,
    /crypto\.timingSafeEqual\(provided, expected\)/,
    `${file}: the gate's comparison is constant time`,
  );

  const forged = runVerify(verify, delivery(TEXT, `sha256=${"0".repeat(64)}`), { META_APP_SECRET: SECRET });
  assert.equal(forged.json.security?.decision, "reject", `${file}: a forged digest is rejected`);
  assert.equal(forged.json.security?.reason, "invalid_meta_signature", `${file}: and named as such`);
  assert.equal(
    forged.json.event,
    undefined,
    `${file}: a rejected request yields nothing to reserve or normalise`,
  );
  // Page id and reason only: the header is the attacker's input and the body
  // carries customer text.
  assert.match(forged.logs, /"page_id":"P1"/, `${file}: a rejection logs the page id`);
  assert.match(forged.logs, /"reason":"invalid_meta_signature"/, `${file}: a rejection logs the reason`);
  assert.ok(!forged.logs.includes("0".repeat(64)), `${file}: a rejection never logs the header value`);
  assert.ok(!forged.logs.includes("bonjour"), `${file}: a rejection never logs the message text`);

  const accepted = runVerify(verify, delivery(TEXT, sign(TEXT)), { META_APP_SECRET: SECRET });
  assert.equal(accepted.json.security?.decision, "accept", `${file}: a correct digest is accepted`);
  assert.equal(accepted.json.event?.page_id, "P1", `${file}: the page id is carried`);
  assert.equal(accepted.json.event?.message_id, "m_1", `${file}: the event id is read from message.mid`);
  assert.equal(
    accepted.json.event?.idempotency_key,
    "meta:P1:m_1",
    `${file}: key format meta:<page_id>:<mid>`,
  );
  assert.equal(
    accepted.json.event?.operation,
    "meta_webhook_event",
    `${file}: reserved under its own operation`,
  );
  assert.equal(
    accepted.json.event?.request_hash,
    createHash("sha256").update(bytes(TEXT)).digest("hex"),
    `${file}: the request hash is over the raw bytes`,
  );
  assert.equal(accepted.logs, "", `${file}: an accepted request logs nothing`);

  const hex = sign(TEXT).slice("sha256=".length);
  for (const [label, header] of [
    ["header absent", undefined],
    ["wrong secret", sign(TEXT, `${SECRET}0`)],
    ["tampered body", sign(messaging({ message: { mid: "m_1", text: "bonsoir" } }))],
    ["sha1 prefix", `sha1=${hex}`],
    // Right total length, wrong prefix: the only vectors that exercise the
    // prefix check rather than the digest length.
    ["upper-case prefix", `SHA256=${hex}`],
    ["near-miss prefix", `sha255=${hex}`],
    ["upper-case hex", `sha256=${hex.toUpperCase()}`],
    ["truncated hex", `sha256=${hex.slice(0, 32)}`],
  ] as const) {
    const run = runVerify(verify, delivery(TEXT, header), { META_APP_SECRET: SECRET });
    assert.equal(run.json.security?.decision, "reject", `${file}: rejects ${label}`);
  }

  assert.equal(
    runVerify(verify, delivery(TEXT, sign(TEXT), false), { META_APP_SECRET: SECRET }).json.security?.reason,
    "missing_raw_body",
    `${file}: without the raw bytes there is nothing to verify, so it fails closed`,
  );
  assert.equal(
    runVerify(verify, delivery(TEXT, sign(TEXT)), {}).json.security?.reason,
    "missing_app_secret",
    `${file}: without the app secret there is nothing to verify with`,
  );

  // The development bypass, and nothing wider than it.
  assert.equal(
    runVerify(verify, delivery(TEXT, "sha256=forged"), {
      META_APP_SECRET: SECRET,
      ALLOW_UNVERIFIED_META_WEBHOOK: "true",
    }).json.security?.decision,
    "development_only_accept",
    `${file}: the documented bypass is honoured`,
  );
  for (const value of ["false", "1", "yes", "", "maybe"]) {
    assert.equal(
      runVerify(verify, delivery(TEXT, "sha256=forged"), {
        META_APP_SECRET: SECRET,
        ALLOW_UNVERIFIED_META_WEBHOOK: value,
      }).json.security?.decision,
      "reject",
      `${file}: ALLOW_UNVERIFIED_META_WEBHOOK=${value} is not the bypass`,
    );
  }

  // A verified event with no event id: message_reads, message_deliveries and
  // messaging_optins carry no mid. Acknowledged and dropped at the
  // 'Event Has Id?' branch, never 403 - a 403 would claim the signature was
  // missing, and Meta disables a page subscription whose deliveries keep
  // failing.
  const receipt = runVerify(verify, delivery(READ_RECEIPT, sign(READ_RECEIPT)), { META_APP_SECRET: SECRET });
  assert.equal(
    receipt.json.security?.decision,
    "accept",
    `${file}: a read receipt verifies like any other event`,
  );
  assert.equal(receipt.json.event?.message_id, null, `${file}: and carries no event id`);
  assert.equal(receipt.json.event?.idempotency_key, null, `${file}: so there is nothing to reserve`);

  const reaction = runVerify(verify, delivery(REACTION, sign(REACTION)), { META_APP_SECRET: SECRET });
  assert.equal(reaction.json.event?.message_id, "m_r", `${file}: a reaction's event id is reaction.mid`);

  // --- behaviour: deduplication, executed ---
  const classify = code("Classify Event Delivery");
  classifiers.push(classify);

  const runClassify = (reserved: Record<string, unknown>) => {
    const logs: string[] = [];
    const out = new Function("$input", "$", "console", classify)(
      { first: () => ({ json: reserved }) },
      (name: string) => {
        assert.equal(name, "Verify Meta Signature", `${file}: the dedupe step reads the verified item`);
        return { first: () => ({ json: accepted.json, binary: undefined }) };
      },
      { log: (line: string) => logs.push(String(line)) },
    ) as { json: GatewayJson }[];
    return { json: out[0].json, logs: logs.join("\n") };
  };

  const first = runClassify({ status: "CREATED" });
  assert.equal(
    first.json.idempotency?.duplicate,
    false,
    `${file}: CREATED is the first delivery of this event`,
  );
  assert.equal(
    first.json.event?.message_id,
    "m_1",
    `${file}: the verified event is carried into normalisation`,
  );
  assert.equal(first.json.security?.decision, "accept", `${file}: with its verification verdict`);
  assert.equal(first.logs, "", `${file}: a first delivery logs nothing`);

  for (const status of ["IN_PROGRESS", "COMPLETED"]) {
    const again = runClassify({ status });
    assert.equal(again.json.idempotency?.duplicate, true, `${file}: ${status} means Meta is retrying`);
    assert.match(
      again.logs,
      new RegExp(`event_already_reserved:${status}`),
      `${file}: the log names the status`,
    );
  }

  // The Postgres node's continue-on-error item is { message, error: {...} }
  // with error an OBJECT. Reading error first and stringifying it yields
  // "[object Object]" and the conflict is never seen.
  const conflicted = runClassify({
    message: "idempotency_key_conflict",
    error: { message: "idempotency_key_conflict", code: "P0001" },
  });
  assert.equal(conflicted.json.idempotency?.conflict, true, `${file}: the key conflict is recognised`);
  assert.equal(
    conflicted.json.idempotency?.duplicate,
    true,
    `${file}: and dropped rather than retried forever`,
  );
  assert.match(conflicted.logs, /same_event_id_different_body/, `${file}: and logged as what it is`);

  // Every other reservation failure means the reservation did not happen.
  // Acknowledging it would lose a verified first-time message permanently,
  // because Meta saw success, and would record an outage as a replay.
  for (const broken of [
    { message: "connection terminated unexpectedly", error: { code: "ECONNRESET" } },
    { message: "timeout exceeded when trying to connect", error: {} },
    { error: { code: "42501", message: "permission denied for function reserve_idempotency" } },
    {},
  ]) {
    assert.throws(
      () => runClassify(broken),
      /reserve_idempotency failed/,
      `${file}: a reservation that did not happen must not be acknowledged: ${JSON.stringify(broken)}`,
    );
  }

  // --- structural: the branches that act on those verdicts ---
  for (const [name, value1] of [
    ["Reject Invalid Signature", "={{ $json.security?.decision === 'reject' }}"],
    ["Event Has Id?", "={{ Boolean($json.event?.message_id) }}"],
    ["Duplicate Delivery?", "={{ $json.idempotency?.duplicate === true }}"],
  ] as const) {
    assert.deepEqual(
      node(name).parameters.conditions?.boolean?.[0],
      { value1, operation: "isTrue" },
      `${file}: ${name} must branch on that expression, taken as true`,
    );
  }

  // --- structural: the reservation is made on the key AND the request hash ---
  const replacement = node("Reserve Meta Event").parameters.options?.queryReplacement ?? "";
  assert.match(replacement, /\$json\.event\.idempotency_key/, `${file}: the key is reserved`);
  assert.match(
    replacement,
    /\$json\.event\.request_hash/,
    `${file}: the request hash is reserved, so the same id with another body conflicts`,
  );
  assert.equal(
    node("Reserve Meta Event").onError,
    "continueRegularOutput",
    `${file}: a key conflict is classified rather than thrown as a 500`,
  );

  // --- structural: topology. A perfect gate the graph routes around is worth
  // nothing: rewiring Capture Meta Request straight to normalisation survived
  // an earlier round of these tests.
  const chain: [string, string[]][] = [
    [POST, ["Capture Meta Request"]],
    ["Capture Meta Request", ["Verify Meta Signature"]],
    ["Verify Meta Signature", ["Reject Invalid Signature"]],
    ["Reject Invalid Signature", ["403 Signature Response", "Event Has Id?"]],
    ["Event Has Id?", ["Reserve Meta Event", "200 Acknowledged Not Processed"]],
    ["Reserve Meta Event", ["Classify Event Delivery"]],
    ["Classify Event Delivery", ["Duplicate Delivery?"]],
    ["Duplicate Delivery?", ["200 Acknowledged Not Processed", "Normalize Messenger Event"]],
  ];
  for (const [from, outputs] of chain) {
    assert.deepEqual(
      wf.connections[from]?.main?.map((output) => output.map((c) => c.node)),
      outputs.map((name) => [name]),
      `${file}: ${from} must feed ${outputs.join(" | ")} in that order`,
    );
  }

  // --- structural: fixed bodies, no echo of the request ---
  assert.equal(
    node("403 Signature Response").parameters.responseBody,
    '={"received":false,"error":"webhook_signature_required"}',
    `${file}: a rejection answers a fixed body`,
  );
  assert.equal(node("403 Signature Response").parameters.options?.responseCode, 403);
  assert.equal(
    node("200 Acknowledged Not Processed").parameters.responseBody,
    '={"received":true,"processed":false}',
    `${file}: an acknowledged-and-dropped event answers a fixed body`,
  );
  assert.equal(node("200 Acknowledged Not Processed").parameters.options?.responseCode, 200);
}

// The two copies must verify and deduplicate identically, or the reference
// domain's gateway can be weakened on its own.
assert.equal(verifiers[0], verifiers[1], "both gateway copies run the same verification code");
assert.equal(classifiers[0], classifiers[1], "both gateway copies run the same deduplication code");

// The gate runs inside n8n and cannot import the module, so the algorithm is
// written twice. Lift the copy out of the workflow and hold it to the module's
// answers, so the two cannot drift apart unnoticed.
const start = verifiers[0].indexOf("function verifyMetaSignature");
const end = verifiers[0].indexOf("const item =");
assert.ok(start >= 0 && end > start, "extraction markers present in the gate's code");
const inNode = new Function("crypto", `${verifiers[0].slice(start, end)}; return verifyMetaSignature;`)(
  crypto,
) as typeof verifyMetaSignature;

const raw = bytes(TEXT);
const good = sign(TEXT);
const hex = good.slice("sha256=".length);
for (const [body, header, expected] of [
  [raw, good, true],
  [raw, `sha256=${hex.toUpperCase()}`, false],
  [raw, `sha1=${hex}`, false],
  [raw, `SHA256=${hex}`, false],
  [raw, `sha255=${hex}`, false],
  [raw, undefined, false],
  // Same JSON, one byte of insignificant whitespace more: proves the digest is
  // over the bytes that arrived, not over a reparsed object.
  [Buffer.concat([raw, Buffer.from(" ", "utf8")]), good, false],
] as const) {
  assert.equal(inNode(body, header, SECRET), expected, `the node's copy: ${String(header).slice(0, 16)}`);
  assert.equal(verifyMetaSignature(body, header, SECRET), expected, "the module agrees with the node's copy");
}

// Preflight: the bypass fails a deployed environment, and only the bypass does.
const filled = Object.fromEntries(
  [
    "SUPABASE_URL",
    "SUPABASE_SERVICE_ROLE_KEY",
    "WOOCOMMERCE_BASE_URL",
    "WOOCOMMERCE_CONSUMER_KEY",
    "WOOCOMMERCE_CONSUMER_SECRET",
    "META_PAGE_ID",
    "META_APP_SECRET",
    "META_VERIFY_TOKEN",
    "META_PAGE_ACCESS_TOKEN",
    "OPENAI_API_KEY",
    "OPENAI_MODEL",
  ].map((name) => [name, `test-${name.toLowerCase()}`]),
);

const preflight = (bypass?: string) =>
  spawnSync(process.execPath, ["--import", "tsx", "scripts/staging/preflight.ts"], {
    env: { ...process.env, ...filled, ALLOW_UNVERIFIED_META_WEBHOOK: bypass ?? "" },
    encoding: "utf8",
  });

const absent = preflight();
assert.equal(absent.status, 0, `preflight passes with the bypass absent:\n${absent.stderr}`);
assert.equal(preflight("false").status, 0, "preflight passes with the bypass explicitly false");

for (const value of ["true", "TRUE", "1", "yes", "maybe"]) {
  const run = preflight(value);
  assert.notEqual(run.status, 0, `preflight must fail with ALLOW_UNVERIFIED_META_WEBHOOK=${value}`);
  assert.match(
    run.stderr,
    /UNVERIFIED_META_WEBHOOK_NOT_ALLOWED=ALLOW_UNVERIFIED_META_WEBHOOK/,
    `preflight must name the bypass as the reason for ${value}`,
  );
}

console.log("PASS: inbound webhook ingress guards (both gateway copies executed, bypass fails preflight)");
