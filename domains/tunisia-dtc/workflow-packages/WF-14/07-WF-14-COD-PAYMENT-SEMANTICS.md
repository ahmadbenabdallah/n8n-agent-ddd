# WF-14 COD Semantics

Cash on Delivery is a payment method, not proof of payment.

Order creation with COD means:
- order exists if WooCommerce confirms creation;
- payment is not automatically completed;
- `payment_status=not_paid` unless authoritative commerce state says otherwise.

WF-14 must never tell the customer:
“payment confirmed”
merely because:
- checkout succeeded;
- an order number was created;
- a COD order was submitted.

Payment/transaction status belongs to WF-15 and authoritative commerce state.
