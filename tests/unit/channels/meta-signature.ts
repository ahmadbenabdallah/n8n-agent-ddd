/**
 * Behavioural tests for inbound Meta webhook verification.
 *
 * Every negative case here fails against the checkout before NAD-016: there
 * was no verification at all, only `if(!$json.signature_valid)` reading a flag
 * the caller supplied.
 *
 * Digests are computed in the test from a fixed secret over fixed bytes, so
 * the test does not depend on the implementation's own HMAC call.
 */
import assert from "node:assert/strict";
import { createHmac } from "node:crypto";
import {
  META_EVENT_OPERATION,
  metaEventKey,
  metaRequestHash,
  reserveMetaEvent,
  verifyMetaSignature,
} from "../../../platform/channels/meta-signature";

const SECRET = "e4f0f0c6a8b24d1f9c3e7a5b1d8f2c60";

// Deliberately not what JSON.stringify would produce: extra spaces, newlines
// and a key order Meta's own serialiser happens to use. A verifier that
// reparses and re-serialises this body gets a different digest.
const RAW = Buffer.from(
  '{"object": "page",\n "entry": [{"id": "PAGE_1", "time": 1758579000000,\n' +
    '   "messaging": [{"sender": {"id": "USER_1"}, "recipient": {"id": "PAGE_1"},\n' +
    '     "timestamp": 1758578999000, "message": {"mid": "m_AAA111", "text": "bonjour"}}]}]}',
  "utf8",
);

const sign = (body: Buffer, secret = SECRET) =>
  `sha256=${createHmac("sha256", secret).update(body).digest("hex")}`;

// 1. Correct signature over the exact raw bytes.
assert.equal(verifyMetaSignature(RAW, sign(RAW), SECRET), true, "a correct sha256= digest verifies");

// 2a. One byte changed in the body.
const tampered = Buffer.from(RAW);
tampered[tampered.length - 3] = tampered[tampered.length - 3] ^ 0x01;
assert.equal(
  verifyMetaSignature(tampered, sign(RAW), SECRET),
  false,
  "a single changed body byte invalidates the signature",
);

// 2b. The body re-serialised through JSON.stringify. This is the case that
// proves raw bytes are hashed: the parsed object is identical, the bytes are not.
const reserialised = Buffer.from(JSON.stringify(JSON.parse(RAW.toString("utf8"))), "utf8");
assert.notEqual(reserialised.length, RAW.length, "the re-serialised body must differ in bytes");
assert.deepEqual(
  JSON.parse(reserialised.toString("utf8")),
  JSON.parse(RAW.toString("utf8")),
  "the re-serialised body must parse to the same object",
);
assert.equal(
  verifyMetaSignature(reserialised, sign(RAW), SECRET),
  false,
  "re-serialising the body breaks the digest: verification must hash the received bytes",
);

// 3. Malformed header material: false, never a throw, never an exception path
// a caller could read as success.
const valid = sign(RAW);
const hex = valid.slice("sha256=".length);
for (const [label, header] of [
  ["header absent", undefined],
  ["header empty", ""],
  ["no prefix", hex],
  ["sha1 prefix", `sha1=${hex}`],
  // Right total length, wrong prefix. Without these the prefix check is
  // shadowed by the digest-length check and never exercised: dropping
  // startsWith(PREFIX) while keeping slice(PREFIX.length) survived everything
  // else in this file.
  ["upper-case prefix", `SHA256=${hex}`],
  ["near-miss prefix", `sha255=${hex}`],
  ["prefix without the equals", `sha256${hex}`],
  ["prefix only", "sha256="],
  ["truncated hex", `sha256=${hex.slice(0, 32)}`],
  ["over-long hex", `sha256=${hex}00`],
  ["upper-case hex", `sha256=${hex.toUpperCase()}`],
  ["non-hex characters", `sha256=${"z".repeat(64)}`],
  ["leading whitespace", ` ${valid}`],
] as const) {
  assert.equal(verifyMetaSignature(RAW, header, SECRET), false, `rejects: ${label}`);
}

// 3b. Missing signing material is a rejection, not a crash and not a pass.
assert.equal(verifyMetaSignature(RAW, valid, ""), false, "an empty app secret cannot verify anything");
assert.equal(
  verifyMetaSignature(undefined as unknown as Buffer, valid, SECRET),
  false,
  "an absent raw body cannot verify",
);
assert.equal(
  verifyMetaSignature(RAW.toString("utf8") as unknown as Buffer, valid, SECRET),
  false,
  "a string body is refused: only the raw bytes are trusted",
);

// 4. Wrong secret.
assert.equal(
  verifyMetaSignature(RAW, sign(RAW, `${SECRET}0`), SECRET),
  false,
  "a digest made with another secret does not verify",
);
assert.equal(
  verifyMetaSignature(RAW, sign(RAW), `${SECRET}0`),
  false,
  "verification under the wrong secret fails",
);

// 5. Replay: a verified event delivered twice is processed once.
//
// The live counterpart runs against the Docker Postgres and the real
// private.reserve_idempotency; this in-memory double has that function's
// contract (first caller CREATED, later callers see the existing status) so
// the accepted/duplicate mapping is testable without the stack.
const rows = new Map<string, { status: string; hash: string }>();
const reserve = async (key: string, operation: string, requestHash: string) => {
  assert.equal(operation, META_EVENT_OPERATION, "events are reserved under their own operation name");
  const existing = rows.get(key);
  if (existing) {
    // private.reserve_idempotency raises on a different body under the same key.
    if (existing.hash !== requestHash) throw new Error("idempotency_key_conflict");
    return { status: existing.status };
  }
  rows.set(key, { status: "IN_PROGRESS", hash: requestHash });
  return { status: "CREATED" };
};

assert.equal(
  metaEventKey("PAGE_1", "m_AAA111"),
  "meta:PAGE_1:m_AAA111",
  "key format is meta:<page_id>:<mid>",
);

// tsx runs this file as CommonJS, so the awaits live in an async main().
// A rejected assertion here still exits non-zero.
async function replay() {
  const hash = metaRequestHash(RAW);
  assert.equal(await reserveMetaEvent(reserve, "PAGE_1", "m_AAA111", hash), "accepted", "first delivery");
  assert.equal(
    await reserveMetaEvent(reserve, "PAGE_1", "m_AAA111", hash),
    "duplicate",
    "the same event id redelivered is a duplicate, acknowledged and dropped",
  );
  assert.equal(rows.size, 1, "a redelivery reserves nothing new");
  assert.equal(
    await reserveMetaEvent(reserve, "PAGE_2", "m_AAA111", hash),
    "accepted",
    "the same mid under another page is a different event",
  );
  await assert.rejects(
    () => reserveMetaEvent(reserve, "PAGE_1", "m_AAA111", metaRequestHash(tampered)),
    /idempotency_key_conflict/,
    "the same event id with a different body conflicts rather than being accepted",
  );
}

replay().then(() => {
  console.log("PASS: Meta webhook signature verification and event deduplication");
});
