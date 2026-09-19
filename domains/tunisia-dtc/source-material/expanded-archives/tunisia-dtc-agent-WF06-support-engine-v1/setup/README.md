# WF-06 — Support Engine

WF-06 handles post-purchase and support intents after WF-04 Intent Router.

## Supported standard support intents

- `shipping`
- `payment`
- `order_status`
- `return_exchange`

Specialist/escalation intents are handed to WF-08:
- `complaint`
- `payment_dispute`
- `human_request`
- `safety`
- `security_suspicion`

## Core principle

Support answers must be grounded in approved policies and verified transactional data. The LLM may explain facts, but it cannot invent status, delivery dates, refunds, payment success, or tool results.

Order-specific access requires the identity level produced by WF-02.
