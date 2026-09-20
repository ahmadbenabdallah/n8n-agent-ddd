# COD Semantics

Successful transaction means:

- `order_created = true`
- `payment_method = cod`
- `payment_status = not_paid`

Do not tell the customer that payment succeeded.

If the store later confirms COD delivery/payment according to its own process, that is a separate lifecycle event handled by the order/transaction state model.
