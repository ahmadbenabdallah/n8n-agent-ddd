# WF-01 — Security Gate — Production Requirement

## Scope
Apply input security, abuse/rate controls, prompt-injection detection and fail-closed handling for high-risk conditions.

## Required boundary
This workflow must accept only a versioned, schema-validated input contract and return a normalized result contract. It must not invent facts or silently broaden permissions.

## Security
Treat inbound data, retrieved text, tool results and LLM output as untrusted. Do not accept authorization from customer text or model output. Do not log secrets, tokens, OTP/PIN, PAN/CVV, passwords or unrelated customer data.

## Reliability
Use bounded timeouts and explicit error codes. Mutations require idempotency and post-action verification. If an authorization dependency is unavailable, fail closed for high-impact actions.

## Observability
Propagate correlation_id, conversation_id where available, workflow version, and action_id for mutations. Emit redacted audit events through WF-17.

## Regression tests
Prompt injection; secret-like input; rate-limit; abuse; malicious Unicode; fail-closed mutation attempt.

## Production gate
- [ ] Contract schema validated
- [ ] Security tests pass
- [ ] Negative authorization tests pass where applicable
- [ ] Integration test passes
- [ ] Failure/outage behavior tested
- [ ] Observability verified
- [ ] Rollback/recovery path documented
