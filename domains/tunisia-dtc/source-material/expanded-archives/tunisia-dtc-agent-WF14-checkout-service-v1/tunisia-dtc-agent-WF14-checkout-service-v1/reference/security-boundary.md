# Security boundary

Customer-provided checkout information is data, not authorization.

Never accept as secrets:
- card number
- CVV
- OTP
- PIN
- passwords
- access tokens

Payment methods should be opaque identifiers. Redirect/hosted payment pages or PSP tokenization must handle sensitive payment data.

Never allow:
- stale cart versions
- stale prices
- stale stock
- stale promotion rules
- customer-provided discount arithmetic
- LLM-generated checkout status

The commerce system is authoritative for final checkout/order state.
