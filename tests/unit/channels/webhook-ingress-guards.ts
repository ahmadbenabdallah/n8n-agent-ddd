/**
 * Guards around the inbound webhook. All of these fail against the checkout
 * before NAD-016.
 *
 * 1. No workflow may decide its own request was authentic. The placeholders
 *    did: runtime/n8n/workflows/WF-01.json read `signature_valid` and
 *    `replay_detected` off the payload, and the messenger gateway's gate set
 *    `signature_valid: 'PENDING_HMAC_VALIDATION'` and continued.
 * 2. A correct verifier the graph does not use, or uses and ignores, is worth
 *    nothing. The gateway's wiring and its use of the result are asserted
 *    here: `const signed = true` in the Code node, rewiring the capture node
 *    straight to normalisation, and `const duplicate = false` in the dedupe
 *    node all survived the first round of these tests.
 * 3. Both copies of the gateway are checked. Only the platform copy was, so
 *    mutating the reference domain's copy alone survived.
 * 4. The local-development bypass must not survive staging preflight.
 */
import assert from "node:assert/strict";
import { spawnSync } from "node:child_process";
import crypto, { createHmac } from "node:crypto";
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

// The module's own comparison. The JSON copy is guarded below; without this
// the module itself could swap timingSafeEqual for === and stay green.
const module = readFileSync("platform/channels/meta-signature.ts", "utf8");
assert.match(module, /timingSafeEqual/, "the module compares in constant time");
assert.match(
  module,
  /createHmac\("sha256", appSecret\)/,
  "the module keys an HMAC-SHA256 with the app secret",
);

// Both copies of the gateway: the shared library's, and the reference
// domain's package copy. platform/workflows/README.md says they can drift.
const GATEWAYS = [
  "platform/workflows/channels/messenger-inbound/workflow.json",
  "domains/tunisia-dtc/workflow-packages/WF-00/tunisia-dtc-agent-wf00-inbound-gateway/workflow/WF-00-inbound-gateway-facebook-messenger.json",
];

// biome-ignore lint/suspicious/noExplicitAny: an n8n node's parameters are free-form JSON
type Node = { name: string; parameters: Record<string, any>; onError?: string };
type Workflow = { nodes: Node[]; connections: Record<string, { main: { node: string }[][] }> };

const POST = "META Events — POST"; // the node name carries an em dash
const verifiers: string[] = [];

for (const file of GATEWAYS) {
  const wf: Workflow = JSON.parse(readFileSync(file, "utf8"));
  const node = (name: string) => {
    const found = wf.nodes.find((n) => n.name === name);
    assert.ok(found, `${file}: node '${name}' exists`);
    return found as Node;
  };

  // Raw bytes are the only thing worth hashing, and this option is what makes
  // them available. Without it every request is rejected missing_raw_body.
  assert.equal(node(POST).parameters.options?.rawBody, true, `${file}: the POST webhook keeps the raw body`);

  const jsCode: string = node("Verify Meta Signature").parameters.jsCode;
  verifiers.push(jsCode);

  assert.match(jsCode, /createHmac\('sha256'/, `${file}: the gate computes an HMAC-SHA256 itself`);
  assert.match(jsCode, /timingSafeEqual/, `${file}: the comparison is constant-time`);
  assert.ok(new Function(jsCode), `${file}: the gate's Code node parses as JavaScript`);

  // The result has to be the one the verifier produced, and the bypass has to
  // be the documented one. Each of these lines was mutated and survived.
  assert.ok(
    jsCode.includes("const signed = verifyMetaSignature(rawBody, header, appSecret);"),
    `${file}: the verdict comes from the verifier, over the raw body and the header`,
  );
  assert.ok(
    jsCode.includes(
      "const allowUnverified = String($env.ALLOW_UNVERIFIED_META_WEBHOOK ?? '').toLowerCase() === 'true';",
    ),
    `${file}: the development bypass is opt-in on the documented value`,
  );
  assert.ok(
    jsCode.includes("if (!signed && !allowUnverified)"),
    `${file}: an unverified request is rejected unless the bypass is on`,
  );

  // A verified event with no provider event id is acknowledged, not rejected.
  // message_reads, message_deliveries and messaging_optins carry no mid; 403
  // would claim the signature was missing and Meta disables a page
  // subscription whose deliveries keep failing.
  assert.ok(
    !jsCode.includes("reject('missing_event_id')"),
    `${file}: a verified event without an id must not be sent to the 403 responder`,
  );
  assert.match(
    jsCode,
    /messaging\.reaction\?\.mid/,
    `${file}: a reaction's event id is read from reaction.mid`,
  );

  // A rejection logs the page id and the reason. Not the body, not the header
  // value: the header is the attacker's input and the body carries customer text.
  assert.match(jsCode, /page_id: pageId, reason/, `${file}: a rejection logs the page id and the reason`);
  assert.doesNotMatch(
    jsCode,
    /console\.log\([^)]*header/,
    `${file}: a rejection never logs the header value`,
  );
  assert.doesNotMatch(
    jsCode,
    /console\.log\([^)]*\bbody\b/,
    `${file}: a rejection never logs the request body`,
  );

  // The branch that acts on the verdict.
  assert.equal(
    node("Reject Invalid Signature").parameters.conditions?.boolean?.[0]?.value1,
    "={{ $json.security?.decision === 'reject' }}",
    `${file}: the reject branch tests the verifier's decision`,
  );
  assert.equal(
    node("Event Has Id?").parameters.conditions?.boolean?.[0]?.value1,
    "={{ Boolean($json.event?.message_id) }}",
    `${file}: the acknowledge-and-drop branch tests for an event id`,
  );
  assert.equal(
    node("Duplicate Delivery?").parameters.conditions?.boolean?.[0]?.value1,
    "={{ $json.idempotency?.duplicate === true }}",
    `${file}: the duplicate branch tests the dedupe verdict`,
  );

  // Deduplication: the reservation is made on the key AND the request hash,
  // and the verdict comes from reserve_idempotency's own status.
  const replacement: string = node("Reserve Meta Event").parameters.options?.queryReplacement ?? "";
  assert.match(replacement, /\$json\.event\.idempotency_key/, `${file}: the key is reserved`);
  assert.match(
    replacement,
    /\$json\.event\.request_hash/,
    `${file}: the request hash is reserved, so the same id with another body conflicts`,
  );
  assert.equal(
    node("Reserve Meta Event").onError,
    "continueRegularOutput",
    `${file}: an idempotency_key_conflict is classified, not thrown as a 500`,
  );

  const dedupe: string = node("Classify Event Delivery").parameters.jsCode;
  assert.ok(
    dedupe.includes("status !== 'CREATED'"),
    `${file}: only reserve_idempotency's CREATED means this delivery is the first`,
  );
  assert.match(dedupe, /idempotency_key_conflict/, `${file}: a key conflict is handled explicitly`);
  assert.match(dedupe, /ponytail:/, `${file}: the at-most-once ceiling is named where it is taken`);

  // Topology. A perfect verifier the graph routes around is worth nothing:
  // rewiring Capture Meta Request straight to normalisation survived the
  // first round of these tests.
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

  // Fixed bodies, no echo of the request.
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

// The two copies must verify identically, or the reference domain's gateway
// can be weakened on its own.
assert.equal(verifiers[0], verifiers[1], "both gateway copies run the same verification code");

// The gate runs inside n8n and cannot import the module, so the algorithm is
// written twice. Lift the copy out of the workflow and hold it to the same
// answers, so the two cannot drift apart unnoticed.
const start = verifiers[0].indexOf("function verifyMetaSignature");
const end = verifiers[0].indexOf("const item =");
assert.ok(start >= 0 && end > start, "extraction markers present in the gate's code");
const lifted = verifiers[0].slice(start, end);
const inNode = new Function("crypto", `${lifted}; return verifyMetaSignature;`)(
  crypto,
) as typeof verifyMetaSignature;

const secret = "e4f0f0c6a8b24d1f9c3e7a5b1d8f2c60";
const raw = Buffer.from('{"object": "page", "entry": []}', "utf8");
const good = `sha256=${createHmac("sha256", secret).update(raw).digest("hex")}`;
const hex = good.slice("sha256=".length);
for (const [body, header, expected] of [
  [raw, good, true],
  [raw, good.toUpperCase().replace("SHA256=", "sha256="), false],
  [raw, good.replace("sha256=", "sha1="), false],
  // Right length, wrong prefix: the only vectors that exercise the prefix
  // check rather than the digest length.
  [raw, `SHA256=${hex}`, false],
  [raw, `sha255=${hex}`, false],
  [raw, undefined, false],
  [Buffer.from('{"object":"page","entry":[]}', "utf8"), good, false],
] as const) {
  assert.equal(inNode(body, header, secret), expected, `the node's copy: ${String(header).slice(0, 16)}`);
  assert.equal(verifyMetaSignature(body, header, secret), expected, "the module agrees with the node's copy");
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

console.log(
  "PASS: inbound webhook ingress guards (verifier bound to both gateway copies, bypass fails preflight)",
);
