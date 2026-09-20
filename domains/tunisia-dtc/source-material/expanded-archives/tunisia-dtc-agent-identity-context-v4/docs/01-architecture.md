# Architecture

## Ownership
- Messenger external identity -> Supabase `customer_identities`
- Internal customer -> Supabase `customers`
- Conversation continuity -> Supabase `conversations` + `conversation_context`
- Explicit customer details -> Supabase
- Purchase intent -> Supabase
- Stable product education -> KB
- Live price/stock/availability/cart/checkout/order/payment -> WooCommerce

## Returning Messenger user
1. WF-02 resolves `(channel, external_user_id)` to the same internal customer.
2. WF-03 loads durable state.
3. Purchase intent and explicitly collected details can be reused.
4. If WooCommerce is available, live product/variation/price/stock/cart state is fetched.
5. Transaction workflows revalidate live facts before execution.

`customer_id` is persistent; `conversation_id` is separate.

## WooCommerce unavailable
Allowed: product education, stable FAQ/policy answers, product discovery, collecting name/phone/address, collecting product/variant/quantity intent, persisting context.

Blocked: live stock confirmation, live price confirmation, coupon authorization, cart mutation, checkout confirmation, order creation, payment confirmation.

When WooCommerce returns, all dynamic facts are revalidated.
