# WF-14 Production Gate

### Authorization
- [ ] checkout_confirm requires WF-10 authorization.
- [ ] Authorization is bound to exact checkout context.
- [ ] Ownership is rechecked immediately before creation.

### Freshness
- [ ] Cart revalidated.
- [ ] Price revalidated.
- [ ] Stock revalidated.
- [ ] Promotion revalidated.
- [ ] Shipping/taxes/fees revalidated.
- [ ] Final total verified.

### Order creation
- [ ] WF-20 is sole privileged WooCommerce boundary.
- [ ] Idempotency implemented.
- [ ] Timeout reconciliation implemented.
- [ ] Order is post-verified.

### Payment
- [ ] COD ≠ payment.
- [ ] Payment status comes from WF-15/commerce.

### Security
- [ ] Race tests pass.
- [ ] Replay tests pass.
- [ ] Price/discount manipulation tests pass.
- [ ] Identity tests pass.
- [ ] Secret protection tests pass.

### Release
- [ ] Normal COD E2E passes.
- [ ] price/stock/promotion race tests pass.
- [ ] WooCommerce timeout/reconciliation passes.
