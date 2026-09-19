# Idempotency Model

Every inbound message has a stable inbound event ID.

Every consequential action has:
- action_id
- idempotency_key
- correlation_id

Writes are not retried blindly.

For timeout/ambiguous outcomes:
1. retain correlation/idempotency identifiers;
2. query/reconcile authoritative commerce state;
3. determine whether mutation committed;
4. return only verified outcome;
5. escalate if reconciliation cannot establish a safe state.
