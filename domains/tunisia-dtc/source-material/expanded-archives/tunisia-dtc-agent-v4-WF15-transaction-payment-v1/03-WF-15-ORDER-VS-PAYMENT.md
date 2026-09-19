# WF-15 Order vs Payment Semantics

Order lifecycle and payment lifecycle are separate.

Example:

```text
Checkout confirmed
→ WooCommerce order created
→ order_status = processing/pending/etc. according to commerce
→ payment_status = not_paid for COD
```

An order number proves an order record exists only after verification. It does not prove:
- payment was authorized;
- payment was captured;
- money was received;
- transaction succeeded.

Customer responses must distinguish:
- order confirmation;
- payment confirmation;
- payment pending;
- payment failure.

If the authoritative source does not prove payment completion, do not claim it.
