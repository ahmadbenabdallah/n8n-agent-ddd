# Idempotency

Order creation is a high-risk mutation and must be idempotent.

Recommended key:

`transaction:{customer_id}:{conversation_id}:{checkout_attempt_id}`

Persist the key before calling WooCommerce. If the same key is received again:
- return the previously recorded WooCommerce order ID if the first attempt succeeded,
- return the recorded safe failure state if the first attempt failed,
- never create a second order.

The persistence mechanism can use the existing `commerce_idempotency` table or an equivalent durable store. Do not rely only on in-memory n8n execution state.
