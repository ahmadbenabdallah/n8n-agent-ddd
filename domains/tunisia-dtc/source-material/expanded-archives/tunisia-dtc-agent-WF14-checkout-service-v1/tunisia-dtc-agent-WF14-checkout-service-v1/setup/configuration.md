# Configuration

Suggested variables:
- `COMMERCE_CHECKOUT_BASE_URL`
- `COMMERCE_CHECKOUT_TIMEOUT_MS=5000`
- `CHECKOUT_SESSION_TTL_MINUTES=30`

Use n8n Credentials for API authentication.

Never put secrets in:
- authorized_action
- customer messages
- cart metadata
- LLM output
- execution logs

A timeout or unknown adapter result is NOT success.
