# Production Gate

- [ ] explicit customer confirmation required
- [ ] WF-10 authorization required
- [ ] stable idempotency key required
- [ ] duplicate action cannot create duplicate order
- [ ] fresh preflight immediately before create
- [ ] live cart/product/stock/price/promotion validated
- [ ] bounded COD-only order creation
- [ ] customer-supplied total cannot override WooCommerce
- [ ] post-create GET verification
- [ ] customer/order ownership verified
- [ ] payment_method=cod verified
- [ ] payment_status=not_paid verified
- [ ] no claim of payment success
- [ ] create timeout recovery uses same action ID
- [ ] post-create verification outage fails closed
- [ ] reconciliation path tested
- [ ] secrets/tokens excluded from LLM/renderer/audit
