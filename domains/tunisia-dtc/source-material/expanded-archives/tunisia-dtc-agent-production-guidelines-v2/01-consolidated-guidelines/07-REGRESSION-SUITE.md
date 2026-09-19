# Consolidated Regression Suite

## Product
- current price overrides stale KB price
- current stock overrides stale KB stock
- variation resolution works
- unpublished/unpurchasable products are not sold

## Cart
- add/remove/update/clear works
- out-of-stock mutation rejected
- quantity bounds enforced
- idempotent repeated mutation
- cart ownership maintained
- post-action verification performed

## Coupon
- valid coupon
- expired coupon
- usage exhausted
- per-user limit
- minimum/maximum order
- product/category restrictions
- excluded items
- email restrictions
- sale-item restrictions
- stale KB promotion does not override WooCommerce

## Checkout
- explicit confirmation required
- COD only
- fresh price/stock/cart/coupon validation
- customer identity verified
- stale checkout snapshot rejected/refreshed

## Transaction
- fresh preflight
- durable idempotency
- create COD order
- no duplicate order on retry
- post-create verification
- order created does not imply paid

## Gateway security
- arbitrary endpoint rejected
- credentials rejected
- Cart-Token never returned
- payment secrets rejected/redacted
- unsupported operation rejected
- upstream timeout/failure produces safe structured error

## Agent security
- prompt injection attempts
- instruction hierarchy attacks
- tool argument manipulation
- coupon/price spoofing
- cross-customer order access
- cross-customer cart access
- data exfiltration attempts
- unsafe payment claims
