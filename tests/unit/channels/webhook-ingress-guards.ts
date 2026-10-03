/**
 * Guards around the inbound webhook, both of which fail against the checkout
 * before NAD-016.
 *
 * 1. No workflow may decide its own request was authentic. The placeholders
 *    did: runtime/n8n/workflows/WF-01.json read `signature_valid` and
 *    `replay_detected` off the payload, and the messenger gateway's gate set
 *    `signature_valid: 'PENDING_HMAC_VALIDATION'` and continued.
 * 2. The local-development bypass must not survive staging preflight.
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

// A rejection logs the page id and the reason. Not the body, not the header
// value: the header is the attacker's input and the body may carry customer text.
const gate = readFileSync("platform/workflows/channels/messenger-inbound/workflow.json", "utf8");
const gateNode = JSON.parse(gate).nodes.find((n: { name: string }) => n.name === "Verify Meta Signature");
assert.ok(gateNode, "the gateway has a signature verification node");
const jsCode: string = gateNode.parameters.jsCode;
assert.match(jsCode, /createHmac\('sha256'/, "the gate computes an HMAC-SHA256 itself");
assert.match(jsCode, /timingSafeEqual/, "the comparison is constant-time");
assert.ok(new Function(jsCode), "the gate's Code node parses as JavaScript");

// The gate runs inside n8n and cannot import the module, so the algorithm is
// written twice. Lift the copy out of the workflow and hold it to the same
// answers, so the two cannot drift apart unnoticed.
const lifted = jsCode.slice(jsCode.indexOf("function verifyMetaSignature"), jsCode.indexOf("const item ="));
const inNode = new Function("crypto", `${lifted}; return verifyMetaSignature;`)(
  crypto,
) as typeof verifyMetaSignature;

const secret = "e4f0f0c6a8b24d1f9c3e7a5b1d8f2c60";
const raw = Buffer.from('{"object": "page", "entry": []}', "utf8");
const good = `sha256=${createHmac("sha256", secret).update(raw).digest("hex")}`;
for (const [body, header, expected] of [
  [raw, good, true],
  [raw, good.toUpperCase().replace("SHA256=", "sha256="), false],
  [raw, good.replace("sha256=", "sha1="), false],
  [raw, undefined, false],
  [Buffer.from('{"object":"page","entry":[]}', "utf8"), good, false],
] as const) {
  assert.equal(inNode(body, header, secret), expected, "the node's copy agrees with the module");
  assert.equal(verifyMetaSignature(body, header, secret), expected, "the module agrees with itself");
}
assert.match(jsCode, /page_id: pageId, reason/, "a rejection logs the page id and the reason");
assert.doesNotMatch(jsCode, /console\.log\([^)]*header/, "a rejection never logs the header value");
assert.doesNotMatch(jsCode, /console\.log\([^)]*\bbody\b/, "a rejection never logs the request body");

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

console.log("PASS: inbound webhook ingress guards (no self-declared verdict, bypass fails preflight)");
