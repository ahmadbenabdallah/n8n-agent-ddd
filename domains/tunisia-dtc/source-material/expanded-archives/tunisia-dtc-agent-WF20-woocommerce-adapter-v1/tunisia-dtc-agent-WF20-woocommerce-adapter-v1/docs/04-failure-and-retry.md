# Failure / Retry Policy

## Safe to retry

GET product
GET variation
GET order
health checks

Use bounded retries for transient 5xx/timeouts.

## Never blind-retry

POST create order.

Order creation requires idempotency. Before retrying a timeout, first check the idempotency ledger and/or search/retrieve the resulting WooCommerce order using the recorded idempotency metadata.

## States

- `reserved`
- `succeeded`
- `failed`
- `awaiting_verification`

A timed-out order creation must become `awaiting_verification`, not `failed` and not `succeeded` until reconciliation is performed.
