# Order Creation & COD Semantics

For Cash on Delivery:

```text
ORDER_CREATED != PAYMENT_COMPLETED
```

A newly created COD order should be represented as:
- order state: created/appropriate WooCommerce status;
- payment status: `not_paid` unless WooCommerce explicitly reports otherwise.

WF-20 must return the actual WooCommerce response.

It must not set a payment state merely because:
- order creation succeeded;
- checkout was confirmed;
- customer said they paid;
- LLM proposed payment completion.

`set_paid` or equivalent payment-changing behavior must not be accepted unless explicitly enabled, authorized, and appropriate to the configured payment flow.

For COD, it should normally not be used to mark an order as paid.
