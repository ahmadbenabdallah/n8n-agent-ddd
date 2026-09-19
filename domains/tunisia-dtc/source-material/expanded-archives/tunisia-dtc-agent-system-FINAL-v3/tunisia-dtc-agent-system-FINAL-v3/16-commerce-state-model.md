# Commerce State Model

## Authoritative live state
WooCommerce is authoritative for product price/stock, cart, coupon validity, checkout total, order status and payment status.

## Internal state
Supabase stores conversation/identity/orchestration state and safe snapshots.

## Freshness
Snapshots are advisory. Before consequential checkout/order mutations, obtain a fresh commerce snapshot.

## COD
`order_status` and `payment_status` are separate concepts. COD order creation does not imply payment.
