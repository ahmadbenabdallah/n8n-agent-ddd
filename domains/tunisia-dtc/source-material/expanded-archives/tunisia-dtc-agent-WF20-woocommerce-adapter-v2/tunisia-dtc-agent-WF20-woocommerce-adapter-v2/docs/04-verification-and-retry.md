# Verification and Retry

## Product GET

Safe to retry boundedly on transient errors.

## Order GET

Safe to retry boundedly.

## Create order

Never blindly retry a timed-out POST.

Sequence:

1. reserve idempotency key in DB
2. create COD order
3. if confirmed → retrieve order
4. compare:
   - order ID
   - line items
   - quantity
   - currency
   - total
   - payment method
   - paid flag
5. mark succeeded only after verification
6. timeout → `awaiting_verification`
7. reconcile before retrying

## Important

WooCommerce response success means the API accepted/created a resource. The agent still needs post-action verification before telling the customer the order is confirmed.
