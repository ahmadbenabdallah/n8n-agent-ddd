# Coupon Policy

WooCommerce may enforce:

- enabled/disabled state
- expiry
- usage limits
- minimum/maximum spend
- individual-use rules
- product restrictions
- category restrictions
- excluded products/categories
- customer/email restrictions
- coupon type and amount
- cart-level applicability

WF-13 must return the commerce result rather than reproduce business logic from KB.

Do not expose internal coupon configuration, usage counters, customer restriction details, or internal error metadata unless the renderer has an approved customer-safe mapping.
