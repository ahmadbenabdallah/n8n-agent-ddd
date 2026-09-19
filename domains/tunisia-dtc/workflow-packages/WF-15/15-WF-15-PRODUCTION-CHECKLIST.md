# WF-15 Production Gate

### Semantics
- [ ] Order creation is separate from payment.
- [ ] COD order defaults to not_paid unless authoritative state differs.
- [ ] Payment status is sourced authoritatively.

### Authorization
- [ ] Mutations require WF-10.
- [ ] Order/transaction scope enforced.
- [ ] Human ownership enforced.

### Security
- [ ] PAN/CVV/OTP/PIN never enter LLM/customer context.
- [ ] Secret/token tests pass.
- [ ] Identity abuse tests pass.
- [ ] Payment hallucination tests pass.
- [ ] Replay tests pass.

### Reliability
- [ ] Idempotency implemented.
- [ ] Timeout reconciliation implemented.
- [ ] Provider outage handling implemented.
- [ ] Conflicting states fail safely.

### Escalation
- [ ] Payment disputes route to WF-08.
- [ ] Unknown high-impact payment state can escalate.

### Release
- [ ] COD E2E passes.
- [ ] Payment pending/failure E2E passes.
- [ ] Timeout/reconciliation E2E passes.
