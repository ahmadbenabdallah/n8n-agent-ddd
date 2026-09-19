# WF-00..WF-20 Production Workflow Map

```text
Meta Messenger
    ↓
WF-00 Inbound Gateway
    ↓
WF-01 Security Gate
    ↓
WF-02 Identity
    ↓
WF-03 Conversation State
    ↓
WF-04 Intent Router
    ├───────────────┐
    ↓               ↓
WF-05 Sales      WF-06 Support
    ↓               ↓
WF-07 Order       WF-08 Escalation
    ↓
WF-09 LLM Reasoning
    ↓
WF-10 Action Validator  ← hard authorization boundary
    ↓
┌─────────────────────────────────────────────┐
│ WF-11 Product Service                       │
│ WF-12 Cart Service                          │
│ WF-13 Promotion Service                     │
│ WF-14 Checkout Service                      │
│ WF-15 Transaction Service                   │
└──────────────────────┬──────────────────────┘
                       ↓
              WF-20 WooCommerce Gateway
                       ↓
                  WooCommerce
                       ↓
              verified result
                       ↓
WF-16 Response Renderer
                       ↓
                   Messenger

Cross-cutting:
WF-17 Audit & Analytics
WF-18 KB Ingestion → Supabase/pgvector
WF-19 Maintenance & Monitoring
```

## Dependency rules

- WF-09 may propose; WF-10 decides.
- WF-11 never authorizes a mutation.
- WF-12/13/14/15 may not bypass WF-10.
- WF-20 cannot be called by customer-facing logic without an authorized bounded operation.
- WF-16 never calls commerce directly.
- WF-17 never authorizes.
- WF-18 never becomes live-commerce authority.
- WF-19 may detect and report; it must not perform unrestricted “retry everything” healing.

## Failure containment

A failure in one workflow must not cause another workflow to invent a successful result.

All inter-workflow calls must have:
- versioned contract
- bounded operation names
- correlation ID
- action ID where applicable
- timeout
- explicit success/failure status
- normalized error code
- no credential leakage
