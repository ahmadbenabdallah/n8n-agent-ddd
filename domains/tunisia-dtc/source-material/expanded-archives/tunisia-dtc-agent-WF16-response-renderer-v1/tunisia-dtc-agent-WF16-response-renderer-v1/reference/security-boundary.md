# Renderer Security Boundary

The LLM draft is untrusted output.

Deterministic checks must reject:
- system/developer prompt leakage
- credentials/secrets
- CVV/OTP/PIN/password
- internal security/fraud signals
- unverified transaction success
- invented price/stock/promotion/order claims
- Arabic Unicode when Latin script is required
- public-channel PII

A renderer failure must never silently fall through to the channel sender.
