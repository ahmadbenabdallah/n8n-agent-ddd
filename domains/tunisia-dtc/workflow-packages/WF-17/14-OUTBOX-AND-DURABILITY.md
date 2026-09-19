# Audit Outbox & Durability

For high-value actions, use an outbox pattern.

## Transactional principle

When a workflow changes its canonical state, create an audit/outbox record in the same persistence transaction when technically possible.

Then:

```text
outbox
 -> publisher
 -> WF-17
 -> durable audit_events
```

If publication fails:
- retry;
- preserve event identity;
- use idempotent ingestion;
- do not duplicate downstream effects.

For external commerce calls, the commerce operation and audit event must be correlated even when they cannot share one database transaction.

Unknown commerce execution must remain visible until reconciliation resolves it.
