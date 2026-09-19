# WF-09 Production Checklist

### Contract
- [ ] Strict schema validated.
- [ ] No authorization field exists in model output.
- [ ] Action catalog is allowlisted.
- [ ] Maximum actions enforced.
- [ ] Parameters bounded.

### Context
- [ ] Identity/order scope is deterministic.
- [ ] Private order data only with active scope.
- [ ] Live facts are labeled with freshness.
- [ ] KB chunks have source IDs/trust classification.
- [ ] Secrets and payment credentials excluded.

### Security
- [ ] Prompt injection tests pass.
- [ ] Sensitive disclosure tests pass.
- [ ] Excessive agency tests pass.
- [ ] Hallucination tests pass.
- [ ] Identity abuse tests pass.
- [ ] Human ownership tests pass.
- [ ] Language/script tests pass.

### Operations
- [ ] Model/version pinned.
- [ ] Prompt version controlled.
- [ ] Token limits configured.
- [ ] Timeouts configured.
- [ ] Retry policy is non-mutating/bounded.
- [ ] Safe fallback exists.
- [ ] Correlation IDs propagated.
- [ ] Metrics and audit events enabled.

### Release gate
WF-09 is production-ready only when its output cannot bypass WF-10 and all dependent E2E/red-team tests pass.
