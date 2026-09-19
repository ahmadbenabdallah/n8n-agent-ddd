# n8n Implementation — WF-17

Recommended workflow:

```text
Trigger / Execute Workflow
 -> Validate Audit Event
 -> Redact Sensitive Fields
 -> Normalize Event
 -> Generate Event Hash
 -> Persist Append-Only Event
 -> Update Action Projection
 -> Update Operational Counters
 -> Security Event Branch
 -> Alert Evaluation
 -> Return Audit Ack
```

## Important architecture

WF-17 should be asynchronous where possible.

Consequential execution should not depend on analytics calculations completing synchronously.

Preferred pattern:

```text
business workflow
      |
      +--> critical audit event
      |
      +--> continue business path

WF-17
      |
      +--> durable event persistence
      +--> projections
      +--> analytics
      +--> alerts
```

If the audit sink is unavailable:
- do not silently lose consequential events;
- use a durable queue/outbox;
- apply bounded retry;
- alert operations;
- never grant authorization because audit is unavailable.

WF-17 must never call WF-10 to authorize an action.
