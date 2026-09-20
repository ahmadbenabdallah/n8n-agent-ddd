# Source of Truth Contract

### Connected
`commerce_status=connected` and `source_of_truth=woocommerce` → use live WooCommerce facts.

### Unavailable
`commerce_status=unavailable` or `source_of_truth=kb_only` → informational KB fallback is allowed only for read/search operations.

### Never fallback
Availability checks, cart operations, coupon validation, checkout, order status, and transaction/order creation must not be answered or executed from KB.
