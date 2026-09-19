# WF-15 Idempotency and Reconciliation

Payment operations must be protected against duplicate execution.

For state-changing operations:
- bind idempotency to request/action/transaction context;
- store safe operation references;
- do not blindly retry after timeout.

## Unknown outcome
If a transaction operation times out:
`UNKNOWN → REQUIRES_RECONCILIATION`

Then:
1. query authoritative transaction/order state;
2. determine whether operation occurred;
3. verify matching transaction reference;
4. resolve to final known state where possible;
5. escalate when ambiguity cannot be safely resolved.

Never execute a second payment operation simply because the first response timed out.
