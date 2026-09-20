# WF-20 Requirement

Current n8n WooCommerce native support should remain the preferred path for resources it exposes. Coupon handling must be explicitly implemented in WF-20 because WF-13 requires coupon validation and the WooCommerce REST API exposes `/wc/v3/coupons`.

Recommended WF-20 bounded operation:

`coupon_validate`

WF-20 may use a credentialed HTTP Request fallback for this operation against the WooCommerce REST API. Do not allow WF-13 to supply an arbitrary URL/path.

WF-20 should:
1. resolve the coupon by bounded code lookup,
2. evaluate WooCommerce coupon properties against the supplied cart/customer context,
3. return only the bounded validation contract,
4. never return coupon meta_data or internal store secrets.
