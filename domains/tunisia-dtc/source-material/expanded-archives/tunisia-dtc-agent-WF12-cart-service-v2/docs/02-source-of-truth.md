# Source of Truth

### WooCommerce
Authoritative:
- product existence
- variation
- current price
- stock
- purchasability
- cart contents
- line item quantities
- cart totals used at checkout

### WF-12
Owns:
- operation contract
- identity context
- authorization gate
- idempotency key propagation
- response normalization

### KB
Informational only. It must never override live cart/product/price/stock facts.
