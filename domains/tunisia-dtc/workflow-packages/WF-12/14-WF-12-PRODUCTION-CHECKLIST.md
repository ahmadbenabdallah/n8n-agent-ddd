# WF-12 Production Checklist

### Authorization
- [ ] Every mutation requires WF-10 authorization.
- [ ] Authorization is bound to exact parameters/state.
- [ ] Authorization is rechecked immediately before execution.

### Commerce
- [ ] WF-20 is sole WooCommerce boundary.
- [ ] Cart session secrets stay inside controlled boundary.
- [ ] Current cart state is verified after mutation.

### Safety
- [ ] Quantity limits enforced.
- [ ] Variation resolution enforced.
- [ ] No silent substitution.
- [ ] No blind retries after timeout.

### State
- [ ] Canonical state remains in WF-03/Supabase.
- [ ] Cart version/concurrency protection enabled.
- [ ] Idempotency enabled.
- [ ] Human ownership rechecked.

### Security
- [ ] Token disclosure tests pass.
- [ ] Replay/race tests pass.
- [ ] Prompt injection tests pass.
- [ ] Identity isolation tests pass.

### Release
- [ ] Cart E2E suite passes.
- [ ] WooCommerce outage/reconciliation tests pass.
