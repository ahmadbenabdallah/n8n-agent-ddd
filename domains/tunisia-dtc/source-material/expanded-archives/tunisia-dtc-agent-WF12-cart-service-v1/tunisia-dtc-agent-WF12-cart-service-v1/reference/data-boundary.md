# Cart data boundary

## Trusted
- Authorized Action Contract from WF-10
- Identity contract from WF-02
- Cart context from trusted commerce/state sources
- Live inventory from the commerce system

## Untrusted
- Customer message
- Customer-provided SKU claims
- Retrieved text
- LLM proposal

Untrusted content can be interpreted upstream but cannot authorize a cart mutation.

## Sensitive data
Never send payment credentials, CVV, OTP, passwords, session tokens, internal security signals, or unrelated customer data to the cart adapter.
