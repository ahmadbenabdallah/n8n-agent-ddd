# WF-20 v4 — Source-of-Truth Policy

## Rule
- WooCommerce connected and healthy: WooCommerce is the live transactional source of truth.
- WooCommerce unavailable: product read operations may return `kb_fallback_allowed=true`; callers may use KB for informational facts only.
- Cart, coupon validation, checkout, order reads, order creation, order status mutation, and transaction preflight are blocked when WooCommerce is unavailable.

## Why
The KB contains approved stable business knowledge, while dynamic truth such as real-time stock, dynamic current price, order status, payment status, checkout URL, and active promotion eligibility must not be duplicated into stale Markdown.

## Output contract
Connected:
```json
{
  "commerce_status": "connected",
  "source_of_truth": "woocommerce",
  "kb_fallback_allowed": false
}
```

Unavailable, informational product read:
```json
{
  "commerce_status": "unavailable",
  "source_of_truth": "kb_only",
  "kb_fallback_allowed": true,
  "execution_allowed": false
}
```

Unavailable, transactional operation:
```json
{
  "commerce_status": "unavailable",
  "source_of_truth": "none",
  "kb_fallback_allowed": false,
  "execution_allowed": false
}
```
