# Idempotency & Delivery

## Response identity

`response_id` is unique per customer-visible response.

Persist:
- response_id
- conversation_id
- channel
- outbound payload hash
- delivery status
- provider message ID when available
- created_at
- last_attempt_at

## Retry rules

A channel retry may resend the same response only when the provider/channel semantics permit it.

Never generate a new commerce action because message delivery failed.

Delivery retry and commerce retry are separate domains.

## Duplicate prevention

Before send:
- check whether `response_id` has already reached terminal delivery state;
- if yes, do not resend;
- if pending, follow delivery retry policy.
