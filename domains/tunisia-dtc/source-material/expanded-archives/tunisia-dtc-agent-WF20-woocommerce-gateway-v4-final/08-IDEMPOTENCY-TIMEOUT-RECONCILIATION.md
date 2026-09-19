# Idempotency, Timeout & Reconciliation

## Idempotency

Every consequential operation receives an idempotency key.

For order creation:
- derive from the authorized action/request;
- persist execution state;
- prevent duplicate creation;
- do not generate a new order on a delivery retry.

## Timeout

A timeout after request submission is:

`UNKNOWN`

not `FAILED`.

Recovery:
1. persist unknown operation;
2. do not blindly retry creation;
3. query authoritative WooCommerce state;
4. identify matching operation/order using controlled correlation data;
5. resolve to verified success/failure or keep reconciliation required.

## Verification

After consequential mutation:
- fetch authoritative state;
- compare expected operation/result;
- record verification outcome.

If verification fails:
`RECONCILIATION_REQUIRED`.
