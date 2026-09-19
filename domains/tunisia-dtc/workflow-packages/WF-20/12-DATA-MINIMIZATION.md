# Data Minimization

WF-20 should request only fields required for the operation.

Examples:
- product lookup does not need customer profile;
- order status needs only the scoped order fields;
- coupon validation needs only eligibility-relevant fields;
- order creation uses only checkout-authorized fields.

Avoid returning complete WooCommerce objects upstream.

Customer data should be filtered before leaving WF-20.
Order data should be filtered according to verified order scope.
