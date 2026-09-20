# WF-20 Requirements

WF-20 should expose a bounded `checkout_validate` operation.

It should use WooCommerce as the source of truth and return a normalized validation result.

Suggested result:

```json
{
  "valid": true,
  "cart": {},
  "coupon": {},
  "totals": {},
  "customer": {},
  "errors": []
}
```

The exact WooCommerce Store API / REST implementation belongs to WF-20.
WF-14 should not know credentials, URLs, session headers or arbitrary endpoint paths.
