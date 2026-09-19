# Configuration

Suggested:
- `COMMERCE_TRANSACTION_BASE_URL`
- `COMMERCE_TRANSACTION_TIMEOUT_MS=10000`
- `TRANSACTION_IDEMPOTENCY_TTL_HOURS=48`

Use n8n Credentials for authentication.

For PSP integrations, keep PSP secrets in the PSP/commerce backend or n8n Credentials. Do not put secrets in workflow JSON or customer data.

Unknown adapter result = unknown transaction state, not failure and not success. Route to reconciliation/support as appropriate.
