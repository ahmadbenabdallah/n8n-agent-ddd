# Security

- WF-15 is the only workflow in this sequence allowed to request order creation.
- `execution_allowed=true` is set only after fresh preflight succeeds and trusted authorization is present.
- Customer-provided or LLM-provided `authorized=true` is not trusted unless propagated from the trusted WF-10 path.
- No arbitrary endpoint/path is accepted.
- No PAN, CVV, OTP or PIN is accepted or logged.
- COD is the only payment method.
- `order_created` never means `paid`.
- Duplicate customer messages must be absorbed by idempotency.
- Post-create verification is mandatory.
