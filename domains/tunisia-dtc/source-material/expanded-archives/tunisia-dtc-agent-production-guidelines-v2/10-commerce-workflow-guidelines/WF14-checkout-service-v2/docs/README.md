# WF-14 Checkout Service v2

WF-14 is the final checkout-validation service before WF-15 creates a WooCommerce COD order.

It does NOT create the order.

## Final validation boundary

WF-14 asks WF-20 to validate the current WooCommerce state for:
- cart
- products and variations
- current prices
- stock / purchasability
- coupon
- customer data
- COD payment method
- current totals

The returned snapshot is short-lived. WF-15 must perform another live validation immediately before order creation to close the time-of-check/time-of-use gap.
