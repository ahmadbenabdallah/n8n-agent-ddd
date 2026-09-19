# Configuration

Suggested:
- `AUDIT_RETENTION_DAYS=180`
- `AUDIT_STORE_URL`
- `AUDIT_WRITE_TIMEOUT_MS=3000`

Retention must follow the actual legal/privacy requirements of the deployment.

## Correlation

Every event should carry:
- event_id
- trace_id
- conversation_id where appropriate
- message_id where appropriate

Do not use customer phone number as the primary correlation identifier. Prefer an internal actor/customer reference.
