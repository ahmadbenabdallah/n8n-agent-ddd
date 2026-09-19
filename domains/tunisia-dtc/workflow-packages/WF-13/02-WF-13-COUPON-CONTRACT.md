# WF-13 Coupon Contract

A coupon/promotion result should normalize fields such as:

```json
{
  "valid": true,
  "code": "WELCOME10",
  "type": "percent",
  "amount": "10",
  "currency": "TND",
  "discount_effect": "10%",
  "applicable": true,
  "reason_code": null,
  "source": "woocommerce",
  "observed_at": "..."
}
```

Do not expose raw WooCommerce administrative metadata.

Supported rule dimensions may include:
- code;
- discount type;
- amount;
- expiry;
- minimum/maximum order;
- usage limits;
- product restrictions;
- category restrictions;
- customer/email restrictions.

The final discount applied to an actual checkout must be confirmed by the commerce/checkout path.
