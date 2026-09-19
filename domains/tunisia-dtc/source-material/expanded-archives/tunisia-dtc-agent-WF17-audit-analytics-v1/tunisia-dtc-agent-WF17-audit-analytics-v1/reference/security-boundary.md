# Security Boundary

Audit is not a dumping ground.

The audit workflow must reject events containing:
- card/PAN data
- CVV/CVC
- OTP/PIN/password
- API keys/tokens
- bearer authorization
- system/developer prompts

Prefer structured fields over raw text.

Customer-facing workflows must not query audit records to answer ordinary customer questions.
