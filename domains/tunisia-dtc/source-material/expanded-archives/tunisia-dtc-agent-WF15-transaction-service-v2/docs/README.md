# WF-15 Transaction Service v2

WF-15 is the transaction boundary for the Tunisia DTC agent's initial COD deployment.

It creates a WooCommerce order only after:
1. trusted customer confirmation,
2. transaction authorization,
3. fresh live preflight validation,
4. bounded WooCommerce order creation,
5. post-create order verification.

## Payment semantics

COD order creation is NOT payment capture.

The initial transaction result is:
- order_created=true
- payment_method=cod
- payment_status=not_paid

A later operational event may update order status. Payment must never be inferred from `order_created`.
