# Idempotency

`customer_id + action_id` is the durable idempotency key.

The same action must not create two orders.

For production, WF-20 should also carry the action ID into a commerce-safe idempotency mechanism where supported, because an n8n crash can occur after WooCommerce creates an order but before Supabase records success.

Recovery rule:
1. Retry with the same action ID.
2. WF-20 checks whether that action already produced an order.
3. If found, return the existing order.
4. Do not create another order.

Do not use timestamps alone as an idempotency key.
