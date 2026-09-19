# Requirements

Upstream:
- WF-01 Security
- WF-02 Identity
- WF-03 State
- WF-04 Intent
- WF-05 Sales
- WF-09 LLM Reasoning

Downstream:
- WF-12 Cart Service
- WF-14 Checkout Service
- WF-15 Transaction Service
- WF-17 Audit

## Identity policy

- cart operations require `channel_linked`, `order_verified`, or `high_assurance`.
- checkout confirmation requires `order_verified` or `high_assurance`.
- anonymous users cannot mutate carts or confirm checkout.

## Security

Never accept authorization parameters from customer text directly.
Never accept arbitrary action names.
Never accept arbitrary tool names, URLs, database queries, or code.
Never treat LLM confidence as permission.

## Idempotency

Persist `idempotency_key` in a durable store. The example input accepts `idempotency_record`; production should query the persistent action ledger.
