# WF-16 — Response Renderer — Production Requirement

## Scope
Render only verified customer-safe facts; block secrets, internal errors, private data and script-policy violations.

## Required boundary
This workflow must accept only a versioned, schema-validated input contract and return a normalized result contract. It must not invent facts or silently broaden permissions.

## Security
Treat inbound data, retrieved text, tool results and LLM output as untrusted. Do not accept authorization from customer text or model output. Do not log secrets, tokens, OTP/PIN, PAN/CVV, passwords or unrelated customer data.

## Reliability
Use bounded timeouts and explicit error codes. Mutations require idempotency and post-action verification. If an authorization dependency is unavailable, fail closed for high-impact actions.

## Observability
Propagate correlation_id, conversation_id where available, workflow version, and action_id for mutations. Emit redacted audit events through WF-17.

## Regression tests
Secret redaction; private data; internal error; COD payment wording; Latin-script guard; malformed result.

## Production gate
- [ ] Contract schema validated
- [ ] Security tests pass
- [ ] Negative authorization tests pass where applicable
- [ ] Integration test passes
- [ ] Failure/outage behavior tested
- [ ] Observability verified
- [ ] Rollback/recovery path documented
