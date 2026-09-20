# Stale Cart Handling

A cart is stale when the current WooCommerce product/variation facts no longer match what the cart operation expects.

Before mutation:
- verify product exists
- verify variation exists
- verify current purchasability
- verify current stock/backorder rules

After mutation:
- re-read cart
- verify line item and quantity
- capture current cart totals

At checkout, WF-14 must perform a fresh validation regardless of what WF-12 previously verified.
