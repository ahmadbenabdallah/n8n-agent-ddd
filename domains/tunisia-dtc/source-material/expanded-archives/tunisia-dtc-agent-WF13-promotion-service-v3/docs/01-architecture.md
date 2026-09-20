# Architecture

```text
WF-04 Intent
   ↓
WF-05 Sales Engine
   ↓
WF-10 Authorization
   ↓
WF-13 Promotion Service
   ↓
WF-20 WooCommerce Gateway
   ↓
WooCommerce current coupon/cart rules
   ↓
Verified promotion result
   ↓
WF-14 Checkout revalidation
```

WF-13 does not calculate or invent a final discount.

For `coupon_validate`, WF-20 must evaluate the current live cart context when the Store API/cart path supports it, or use the authenticated WooCommerce coupon rules as an intermediate validation. The checkout layer remains authoritative for the final total.
