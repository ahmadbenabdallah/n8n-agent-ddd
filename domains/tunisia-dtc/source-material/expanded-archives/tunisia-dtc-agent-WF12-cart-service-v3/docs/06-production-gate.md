# Production Gate

- [ ] SQL migration passes
- [ ] RLS/server-role review complete
- [ ] WF-20 ID wired
- [ ] `cart_view` returns live verified cart
- [ ] `cart_add` validates current product/variation/stock
- [ ] `cart_update` validates current state
- [ ] `cart_remove` post-verifies
- [ ] `cart_clear` post-verifies empty state
- [ ] duplicate idempotency key does not duplicate mutation
- [ ] expired Cart-Token/session is safely recovered by WF-20
- [ ] raw Cart-Token never reaches LLM/renderer/audit
- [ ] WooCommerce outage blocks all cart mutations
- [ ] outage preserves purchase intent through WF-03
- [ ] recovery revalidates live product/price/stock
- [ ] checkout revalidation passes after cart mutation
- [ ] load/retry tests pass
