/**
 * Meta (Messenger/WhatsApp) inbound webhook verification.
 *
 * This is the only network-facing entry point the system has. Before this
 * module the sole check was a `signature_valid` flag read from the payload,
 * so the caller decided whether its own request was authentic.
 *
 * Meta signs the RAW request body with the App Secret and sends the digest in
 * `X-Hub-Signature-256: sha256=<lowercase hex>`. Re-serialising parsed JSON
 * changes whitespace and key order, so verification must hash the bytes that
 * arrived, never a reparsed object.
 *
 * ponytail: no signature-provider abstraction. One scheme, one function; add
 * the indirection when a channel with a different scheme (Telegram) arrives.
 * WhatsApp uses this same scheme and can call this function as it is.
 */
import { createHash, createHmac, timingSafeEqual } from "node:crypto";

const PREFIX = "sha256=";

/** Operation name recorded in `idempotency_keys` for an inbound Meta event. */
export const META_EVENT_OPERATION = "meta_webhook_event";

/**
 * True only when `header` carries the HMAC-SHA256 of `rawBody` under
 * `appSecret`. Every other outcome - missing header, missing `sha256=`
 * prefix, wrong digest length, upper-case hex, wrong secret, mismatch - is
 * false. There is no throwing path, so there is no failure mode a caller can
 * mistake for success.
 *
 * The comparison is over the hex text rather than the decoded bytes: that is
 * still constant-time, and it rejects any encoding Meta does not send
 * (upper-case hex, short hex, non-hex characters) instead of silently
 * normalising it.
 */
export function verifyMetaSignature(rawBody: Buffer, header: string | undefined, appSecret: string): boolean {
  if (!Buffer.isBuffer(rawBody)) return false;
  if (typeof appSecret !== "string" || appSecret.length === 0) return false;
  if (typeof header !== "string" || !header.startsWith(PREFIX)) return false;

  const provided = Buffer.from(header.slice(PREFIX.length), "utf8");
  const expected = Buffer.from(createHmac("sha256", appSecret).update(rawBody).digest("hex"), "utf8");

  return provided.length === expected.length && timingSafeEqual(provided, expected);
}

/**
 * Meta's signature covers the body only: no timestamp, no nonce, so a
 * captured valid request replays forever. Replay defence is therefore
 * deduplication of the event id, not signature verification.
 *
 * Key format, decided here and recorded in contracts/platform/channel-port.yaml.
 */
export function metaEventKey(pageId: string, mid: string): string {
  return `meta:${pageId}:${mid}`;
}

/** Request hash stored alongside the key, so the same mid with a different body conflicts. */
export function metaRequestHash(rawBody: Buffer): string {
  return createHash("sha256").update(rawBody).digest("hex");
}

/** The `private.reserve_idempotency(key, operation, request_hash)` call. */
export type ReserveIdempotency = (
  key: string,
  operation: string,
  requestHash: string,
) => Promise<{ status: string }>;

/**
 * Reserves a verified event. `CREATED` means this delivery is the first and
 * may be processed; any existing row means Meta is retrying a delivery we
 * already have, which is acknowledged 200 and dropped before normalisation.
 */
export async function reserveMetaEvent(
  reserve: ReserveIdempotency,
  pageId: string,
  mid: string,
  requestHash: string,
): Promise<"accepted" | "duplicate"> {
  const { status } = await reserve(metaEventKey(pageId, mid), META_EVENT_OPERATION, requestHash);
  return status === "CREATED" ? "accepted" : "duplicate";
}
