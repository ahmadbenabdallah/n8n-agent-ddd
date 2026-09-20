# Security Boundary

WF-20 assumes:

- WF-01 security gate ran
- WF-02 identity ran
- WF-10 authorization succeeded for mutations

WF-20 must never:
- interpret customer text as authorization
- accept arbitrary endpoint URLs
- expose WooCommerce credentials
- return private order metadata
- accept payment secrets
- claim success from an LLM proposal
- bypass idempotency
- treat timeout as success

Sensitive payment data prohibited:
PAN/card number, CVV, OTP, PIN, password.

Order access still requires the existing identity/order scope rules. An order number, name or phone number alone is not authorization.
