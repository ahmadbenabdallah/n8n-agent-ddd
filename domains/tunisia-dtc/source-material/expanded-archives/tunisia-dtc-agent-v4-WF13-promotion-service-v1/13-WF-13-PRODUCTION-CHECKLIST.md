# WF-13 Production Checklist

### Authority
- [ ] Live promotion validity comes from authoritative commerce/config.
- [ ] Checkout total comes from WF-14/commerce.
- [ ] KB cannot override live promotion state.

### Eligibility
- [ ] Product/category restrictions validated.
- [ ] Customer restrictions validated.
- [ ] Usage/expiry rules validated.
- [ ] Cart-dependent conditions rechecked.

### Security
- [ ] LLM cannot set discount.
- [ ] Prompt injection tests pass.
- [ ] KB poisoning tests pass.
- [ ] Identity abuse tests pass.
- [ ] Secret protection tests pass.
- [ ] Coupon abuse/rate tests pass.

### Integration
- [ ] WF-10 controls consequential mutations.
- [ ] WF-20 is sole privileged WooCommerce boundary.
- [ ] WF-14 performs final checkout validation.
- [ ] WF-16 renders verified results.

### Operations
- [ ] Timeouts handled.
- [ ] Correlation IDs propagated.
- [ ] Structured error codes implemented.
