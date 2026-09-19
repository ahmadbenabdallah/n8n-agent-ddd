# WF-10 Production Gate

## Hard boundary
- [ ] Only WF-10 sets `execution_allowed=true`.
- [ ] LLM cannot authorize.
- [ ] Downstream mutation workflows reject missing/invalid authorization.
- [ ] Authorization is short-lived and state-bound.

## Validation
- [ ] Actions allowlisted.
- [ ] Parameters strictly validated.
- [ ] Identity/scope checked.
- [ ] Human ownership checked.
- [ ] Freshness checked.
- [ ] Idempotency checked.
- [ ] Security flags checked.

## Commerce
- [ ] WF-20 is sole privileged WooCommerce boundary.
- [ ] Live price/stock/status come from commerce.
- [ ] Checkout performs immediate preflight.
- [ ] Unknown execution reconciles instead of blindly retrying.

## Testing
- [ ] OWASP tests pass.
- [ ] Race/replay tests pass.
- [ ] Identity abuse tests pass.
- [ ] Parameter fuzzing passes.
- [ ] Mutation E2E tests pass.

WF-10 is a release-blocking security component.
