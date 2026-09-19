# WF-07 Production Checklist

- [ ] Discovery separated from authorization.
- [ ] Website-originated orders supported.
- [ ] Candidate lookup bounded and rate-limited.
- [ ] Multiple candidates handled safely.
- [ ] Order scope persisted only after application verification.
- [ ] WF-10 authorization required for protected reads.
- [ ] WF-20 is the only WooCommerce boundary.
- [ ] Fresh WooCommerce read for live status.
- [ ] Minimum-field response enforced.
- [ ] Human ownership respected.
- [ ] Unknown/unavailable outcomes cannot become success.
- [ ] Mutation idempotency/reconciliation integrated.
- [ ] Public-channel privacy enforced.
- [ ] Identity collision fails closed.
- [ ] Red-team tests pass.
