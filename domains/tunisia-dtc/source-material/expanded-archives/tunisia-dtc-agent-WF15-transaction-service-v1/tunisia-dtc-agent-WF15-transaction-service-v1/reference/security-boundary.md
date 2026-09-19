# Security boundary

Never accept or forward:
- card number / PAN
- CVV/CVC
- OTP
- PIN
- payment password
- session/access tokens

Payment-method values should be opaque identifiers.

Do not let:
- customer claims
- LLM output
- screenshots
- retrieved documents
- stale checkout state

override amount, currency, ownership, authorization or payment status.

A PSP response must be normalized and verified before customer-facing output.
