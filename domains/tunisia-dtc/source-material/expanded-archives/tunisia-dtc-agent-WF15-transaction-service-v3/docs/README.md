# WF-15 Transaction Service v3

This is the **order-creation boundary** for the DTC agent.

For the current business model:
- payment method = Cash on Delivery (COD);
- order creation is not payment;
- a newly created COD order is `payment_status=not_paid`.

## Sequence

```text
Customer confirmation
       ↓
WF-10 authorization
       ↓
Idempotency check
       ↓
Fresh transaction preflight
       ↓
WF-20 bounded COD order creation
       ↓
GET order from WooCommerce
       ↓
Post-create semantic verification
       ↓
Persist idempotent result
       ↓
WF-16 renderer
```

Only WF-15 may request order creation.
