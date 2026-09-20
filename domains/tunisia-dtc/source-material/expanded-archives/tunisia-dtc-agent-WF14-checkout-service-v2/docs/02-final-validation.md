# Final Validation

WF-14 must reject checkout if any of the following changed or cannot be verified:
- product deleted/unpublished
- variation invalid
- product no longer purchasable
- stock insufficient
- current price differs from expected conversational price
- coupon invalid/expired/restricted
- cart changed
- customer data invalid
- COD unavailable
- totals cannot be verified

A validation success means only `checkout_ready=true`. It does not mean `order_created` or `paid`.
