# WF-11 Production Checklist

### Authority
- [ ] WooCommerce is authoritative for live price/stock/purchasability.
- [ ] WF-20 is the only privileged WooCommerce boundary.
- [ ] Stable KB content cannot override live commerce.

### Data
- [ ] Product fields are allowlisted.
- [ ] Private/admin metadata is stripped.
- [ ] Variation resolution is deterministic.
- [ ] Freshness policy is enforced.

### Security
- [ ] Prompt injection tests pass.
- [ ] Arbitrary endpoint tests pass.
- [ ] Hallucination tests pass.
- [ ] KB poisoning tests pass.
- [ ] Privacy tests pass.
- [ ] Resource limits pass.

### Integration
- [ ] WF-10 remains authorization boundary.
- [ ] WF-12 owns cart mutation.
- [ ] WF-14 owns checkout.
- [ ] WF-16 renders verified facts.
- [ ] Errors are structured and correlation IDs propagate.

### Release
- [ ] Product E2E flows pass.
- [ ] Variation tests pass.
- [ ] Stale-data tests pass.
- [ ] WooCommerce outage tests pass.
