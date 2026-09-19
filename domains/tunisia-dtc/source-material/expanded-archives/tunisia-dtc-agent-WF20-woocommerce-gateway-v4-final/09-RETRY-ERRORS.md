# Retry & Error Contract

Retry only transient errors:
- network timeout where safe;
- 502/503/504;
- provider rate limits with bounded backoff.

Do not blindly retry:
- 400 validation errors;
- 401/403 authorization/authentication failures;
- 404 resource not found;
- business-rule rejection;
- stale-state conflict.

Normalized error categories:

- `AUTHORIZATION_REQUIRED`
- `AUTHORIZATION_EXPIRED`
- `PARAMETER_INVALID`
- `RESOURCE_NOT_FOUND`
- `IDENTITY_SCOPE_INVALID`
- `COMMERCE_UNAVAILABLE`
- `RATE_LIMITED`
- `BUSINESS_RULE_REJECTED`
- `TIMEOUT_UNKNOWN`
- `VERIFICATION_FAILED`
- `RECONCILIATION_REQUIRED`
- `SCHEMA_MISMATCH`
- `SECURITY_BLOCKED`

Never expose raw WooCommerce stack traces to customers.
