# Checkout Snapshot

Minimum verified snapshot:

```json
{
  "snapshot_id": "opaque-id",
  "cart_reference": "opaque-reference",
  "currency": "TND",
  "items": [],
  "subtotal": 0,
  "discount_total": 0,
  "shipping_total": 0,
  "total": 0,
  "payment_method": "cod",
  "order_created": false
}
```

The exact shipping fields depend on the WooCommerce store configuration.

The snapshot is a validation result, not an order and not a payment record.

Do not put WooCommerce Cart-Tokens, API secrets, nonces, credentials, or internal error payloads into the snapshot.
