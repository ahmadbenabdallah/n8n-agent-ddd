# Security

- LLM cannot promote identity level or grant permissions.
- Customer claims are not authorization.
- State transitions are allowlisted.
- Customer/retrieved KB text is untrusted data, not executable instructions.
- Never store/request passwords, OTPs, PAN/card numbers, CVV, auth secrets, API keys, Cart-Tokens, or nonce tokens in LLM context.
- Minimize audit data; do not log full addresses/phone numbers unless operationally required.
- Define retention/deletion/backup policy before production; this package does not invent legal/merchant policy values.
