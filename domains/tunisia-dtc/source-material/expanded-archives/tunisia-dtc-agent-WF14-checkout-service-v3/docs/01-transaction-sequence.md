# Transaction Sequence

```text
WF-12 Live Cart
      ↓
WF-13 Live Promotion
      ↓
WF-14 Checkout Validation
      ↓
VERIFIED CHECKOUT SNAPSHOT
      ↓
customer confirmation
      ↓
WF-15 final fresh preflight
      ↓
WF-20 create COD order
      ↓
post-create get/verify
```

WF-14 is intentionally not the final authorization boundary. WF-15 must perform a fresh validation immediately before order creation because cart/price/stock/promotion state can change after the snapshot.
