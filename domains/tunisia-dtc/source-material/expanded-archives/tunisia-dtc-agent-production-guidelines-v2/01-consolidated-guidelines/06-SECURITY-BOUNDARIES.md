# Security Boundaries

## LLM boundary

The LLM can:
- interpret intent
- retrieve context
- propose an action
- propose identifiers such as a coupon code

The LLM cannot:
- authorize execution
- set final price
- set stock
- set discount
- set payment status
- select arbitrary API paths
- provide WooCommerce credentials
- directly execute commerce mutations

## WF-10

Hard authorization boundary.

Only its authorized branch may establish execution authorization.

## WF-20

Privileged integration boundary.

Reject/ignore:
- arbitrary URLs
- arbitrary paths
- arbitrary HTTP methods
- credentials
- raw Cart-Tokens
- payment secrets

## WF-16

Only verified facts may become customer-facing transactional claims.

## WF-17

Audit logs must redact:
- payment credentials
- PAN/CVV/OTP/PIN/passwords
- API keys/secrets
- Cart-Tokens
- unnecessary PII
- raw prompts/messages where policy requires minimization
