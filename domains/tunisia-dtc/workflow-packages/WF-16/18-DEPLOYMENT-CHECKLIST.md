# Deployment Checklist

- [ ] WF-16 receives only validated orchestration envelopes.
- [ ] WF-10 is not bypassed.
- [ ] WF-20 is not reachable as a renderer tool.
- [ ] Human ownership gate is active.
- [ ] Unknown execution mode is active.
- [ ] Fact provenance is mandatory.
- [ ] Privacy filter is active.
- [ ] Language/script validator is active.
- [ ] Deterministic fallback exists.
- [ ] Response idempotency is active.
- [ ] Messenger delivery retries are isolated from commerce retries.
- [ ] Secrets are absent from logs.
- [ ] Cart-Tokens/Nonce Tokens are excluded.
- [ ] WF-17 audit events are emitted.
- [ ] Red-team suite passes.
- [ ] E2E suite passes.
- [ ] Rollback version is available.
