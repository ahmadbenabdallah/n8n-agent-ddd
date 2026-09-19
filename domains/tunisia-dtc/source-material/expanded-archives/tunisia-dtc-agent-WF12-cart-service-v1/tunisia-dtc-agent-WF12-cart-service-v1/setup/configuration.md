# Configuration

## Environment / credentials
Use n8n Credentials for the commerce API. Do not place tokens in JSON input.

Suggested environment names:
- `COMMERCE_CART_BASE_URL`
- `COMMERCE_CART_TIMEOUT_MS=5000`
- `CART_MAX_QTY=99`

## Timeouts
Keep commerce calls bounded (recommended 5 seconds). A timeout is a failed/unknown execution, not a success.

## Idempotency
The durable store must be authoritative. The in-memory `cart_context.idempotency_keys` check in this reference workflow is an additional guard, not a replacement for a database uniqueness constraint.

## Concurrency
Do not rely solely on a preflight stock check. The commerce adapter must enforce final stock/availability atomically where possible.
