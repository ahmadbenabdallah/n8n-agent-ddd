# Status Semantics

Customer-facing language must distinguish:

- `order_created`: WooCommerce returned an order.
- `payment_status=not_paid`: COD has not been captured.
- `pending` / `processing` / etc.: WooCommerce order state.
- `paid`: only allowed when a trusted payment event/source establishes captured payment.

For this initial COD deployment, a newly created COD order must not be described as paid.
