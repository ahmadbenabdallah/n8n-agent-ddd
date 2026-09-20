# Messenger Cart Token Design

WooCommerce Store API supports headless cart sessions using a `Cart-Token` header. A GET cart response can provide a Cart-Token that can later identify the cart without browser cookies. citeturn0search6turn0search3

Recommended durable mapping:

`agent_customer_id + channel + store_id -> encrypted WooCommerce Cart-Token`

Rules:
- Store the token in a protected persistence layer, not in the LLM context.
- Never log the token.
- Never return the token to WF-16/customer.
- Resolve the token inside WF-20 from the trusted customer/session context.
- Rotate/recreate when invalid or expired according to the store's behavior.
- A supplied `cart_reference` is an opaque internal reference, not a Store API token.

All Store API cart POST operations require a valid Cart-Token or Nonce Token. citeturn0search3turn0search6
