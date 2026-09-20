# Security

- WF-10 is the authorization boundary.
- WF-14 cannot grant permission.
- WF-20 is the only privileged WooCommerce boundary.
- LLM output is proposal data only.
- Final totals must come from verified commerce state.
- Never trust customer-supplied price, stock, discount or total.
- Never accept a customer-supplied Cart-Token as proof of identity/authorization.
- Never expose WooCommerce secrets or internal errors.
- Checkout success requires a verified snapshot.
- Snapshot must explicitly state `order_created=false`.
- WF-15 must independently revalidate immediately before order creation.
- Never represent COD checkout as paid.
