# Rendering Boundary

```text
WF-15 verified transaction
          ↓
      WF-16 Renderer
          ↓
   public customer message
          ↓
       Messenger
```

WF-16 receives a verified result, not raw WooCommerce credentials or arbitrary tool output.

The renderer strips internal structured fields from the final channel payload.

Customer-facing claims must map to a field in the verified result.

Examples:
- `order_created=true` + verified order ID -> may say order created.
- `payment_method=cod` -> may say cash on delivery.
- `payment_status=not_paid` -> must not say paid.
- no verified stock field -> must not claim stock availability.
