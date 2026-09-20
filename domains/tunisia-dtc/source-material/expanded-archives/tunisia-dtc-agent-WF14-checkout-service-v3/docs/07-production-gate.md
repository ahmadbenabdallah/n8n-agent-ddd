# Production Gate

- [ ] cart exists in live WooCommerce
- [ ] product/variation revalidated
- [ ] stock/purchasability revalidated
- [ ] current prices revalidated
- [ ] coupon/promotion revalidated
- [ ] shipping rules validated where configured
- [ ] total verified against WooCommerce
- [ ] currency verified
- [ ] COD explicitly selected
- [ ] `order_created=false`
- [ ] snapshot has opaque ID
- [ ] no Cart-Token/secret in snapshot
- [ ] outage fails closed
- [ ] customer confirmation required
- [ ] WF-15 fresh preflight before create
- [ ] race-condition price/stock test passes
