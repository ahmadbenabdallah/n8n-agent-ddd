# Master Implementation Plan

## 0. Target system

```text
Meta Messenger
      |
      v
WF-00 Inbound Gateway
      |
WF-01 Security Gate
      |
WF-02 Customer Identity
      |
WF-03 Conversation State
      |
WF-04 Intent Router
      |
  +---+------------------+
  |                      |
WF-05 Sales          WF-06 Support
  |                      |
  +----------+-----------+
             |
          WF-09 LLM
             |
          WF-10 AUTHORIZATION  <--- hard boundary
             |
   +---------+----------------------+
   |         |        |       |     |
 WF-11     WF-12    WF-13   WF-14  WF-15
Product     Cart     Promo  Checkout Tx/Payment
   |         |        |       |     |
   +---------+--------+-------+-----+
             |
          WF-20 WooCommerce Gateway
             |
         WooCommerce
             |
         Verification
             |
          WF-16 Renderer
             |
          Messenger

Cross-cutting:
WF-08 Human Ownership
WF-17 Audit
WF-18 Knowledge
WF-19 Operations
```

## 1. Build order

### Phase A — Foundation
- Self-host n8n.
- Configure encryption and credentials.
- Provision Supabase.
- Create application schemas.
- Configure WooCommerce API credentials.
- Configure OpenAI credentials.
- Configure Meta Messenger webhook/app.
- Establish staging WooCommerce store.

### Phase B — Deterministic control plane
Build and test:
1. WF-00
2. WF-01
3. WF-02
4. WF-03
5. WF-04
6. WF-08
7. WF-17
8. WF-19

Do not expose commerce mutations yet.

### Phase C — Domain services
Build:
9. WF-11 Product
10. WF-12 Cart
11. WF-13 Promotion
12. WF-14 Checkout
13. WF-15 Transaction
14. WF-07 Order
15. WF-20 WooCommerce Gateway

### Phase D — Intelligence
Build:
16. WF-05 Sales
17. WF-06 Support
18. WF-09 LLM Reasoning
19. WF-10 Action Authorization

### Phase E — Customer response
20. WF-16 Response Renderer

### Phase F — Knowledge
21. WF-18 KB Ingestion

### Phase G — Full integration
- Connect workflows.
- Enable idempotency.
- Enable post-action verification.
- Run red-team tests.
- Run failure/recovery tests.
- Run load tests.
- Promote staging → production.

## 2. Implementation gate

A workflow is not considered complete because its JSON imports successfully.

Every workflow must have:
- defined input contract;
- defined output contract;
- deterministic validation;
- explicit error states;
- idempotency where mutation is possible;
- timeout/retry policy;
- audit event;
- security tests;
- production logging;
- recovery procedure;
- owner;
- version.

## 3. Golden rule

No node after WF-10 may reinterpret authorization. Domain services may validate their own business rules, but cannot expand the authorized action.

## 4. Production rollout

Use:
`DEV → STAGING → PILOT → PRODUCTION`

At each promotion:
- freeze workflow versions;
- export n8n workflows;
- record hashes/versions;
- verify credentials are environment-scoped;
- execute smoke tests;
- verify audit events;
- verify WooCommerce reconciliation;
- verify human handoff.
