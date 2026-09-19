# WF-14 Idempotency and Reconciliation

Order creation is highly consequential and must be idempotent/recoverable.

Use a deterministic idempotency key bound to:
- conversation;
- checkout action;
- cart;
- relevant state;
- request.

If the same request repeats:
- locate prior execution/result;
- reconcile before attempting another order creation.

On timeout:
1. mark execution `UNKNOWN`;
2. query commerce using safe reconciliation criteria;
3. identify whether an order was created;
4. verify candidate order against expected context;
5. if matched, mark verified;
6. if no safe match exists, escalate/recovery path;
7. never blindly duplicate the order.
