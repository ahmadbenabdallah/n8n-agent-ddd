# Preflight and TOCTOU

WF-14's checkout snapshot is NOT trusted as final truth.

WF-15 performs a fresh `transaction_preflight` through WF-20 immediately before order creation.

Required checks:
- cart still exists and belongs to customer/session
- product and variation still valid
- current price
- stock/purchasability
- coupon validity and discount
- current totals
- COD availability
- customer/shipping validation

If anything changes, do not create the order. Return `revalidation_required`.
