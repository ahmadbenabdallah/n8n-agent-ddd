# Fresh Preflight

WF-14's checkout snapshot is not sufficient for order creation.

Immediately before creating the order, WF-15 requires WF-20 to revalidate:
- live cart
- product/variation
- stock
- current price
- promotion/coupon
- shipping/checkout constraints
- total
- customer/order fields
- COD availability

This protects against state changes between customer confirmation and order creation.
