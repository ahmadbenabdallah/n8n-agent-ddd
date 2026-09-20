# WooCommerce Cart / Store API Design

WooCommerce's Store API is the customer-facing API surface for products, cart and checkout.

For the Messenger deployment, do not assume a browser cookie exists. WF-20 must maintain the mapping between the agent customer/conversation and the WooCommerce cart/session mechanism.

Recommended pattern:

1. Resolve durable agent customer identity.
2. Resolve or create the WooCommerce cart/session context.
3. Fetch current cart.
4. For add/update/remove, validate the product/variation with WF-11.
5. Execute the bounded cart operation.
6. Re-fetch cart.
7. Verify the resulting quantity/line item.
8. Return only verified cart fields.

Do not expose session cookies/tokens to the LLM or customer-facing renderer.
