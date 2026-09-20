# What to Log

### Log
- workflow/action lifecycle
- authorization result
- security flags
- tool operation type
- success/failure/result code
- order ID when operationally necessary
- source document IDs/versions for KB retrieval
- timestamps and latency metrics
- retry/idempotency identifiers

### Do not log
- passwords
- OTP/PIN
- payment card data
- CVV/PAN
- API keys/secrets
- Cart-Tokens/nonces
- complete addresses/phone numbers in general analytics
- internal credentials
- raw customer conversation text unless a separate, reviewed retention policy explicitly requires it

Use pseudonymous IDs and approved metadata.
