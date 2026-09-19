# WF-00–WF-20 Contract Map

| WF | Boundary | Primary responsibility | Can mutate commerce? |
|---|---|---|---|
| 00 | Inbound | normalize/idempotency | No |
| 01 | Security | threat/rate controls | No |
| 02 | Identity | verification/scope | No |
| 03 | State | canonical state | No commerce |
| 04 | Intent | routing | No |
| 05 | Sales | sales logic | No direct |
| 06 | Support | support logic | No direct |
| 07 | Order | order orchestration | Via WF-20 only |
| 08 | Escalation | human ownership | No |
| 09 | LLM | proposal/reasoning | No |
| 10 | Authorization | hard policy gate | No |
| 11 | Product | product service | Via WF-20 |
| 12 | Cart | cart service | Via WF-20 |
| 13 | Promotion | promotion service | Via WF-20 |
| 14 | Checkout | checkout service | Via WF-20 |
| 15 | Transaction | reconcile/order transaction | Via WF-20 |
| 16 | Renderer | customer output | No |
| 17 | Audit | events/analytics | No |
| 18 | KB | ingestion/indexing | No |
| 19 | Ops | monitoring/maintenance | No |
| 20 | Commerce gateway | privileged WooCommerce adapter | Yes, only here |
