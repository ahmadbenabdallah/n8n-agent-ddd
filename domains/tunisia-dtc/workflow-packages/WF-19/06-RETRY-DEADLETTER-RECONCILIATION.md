# Retry, Dead Letter & Reconciliation

## Retry classes

Retry only transient failures:
- network timeout;
- temporary 5xx;
- rate limit with bounded backoff;
- transient provider unavailability.

Do not blindly retry:
- authorization denial;
- identity failure;
- invalid parameters;
- policy rejection;
- known business failure.

## Dead-letter

Persist exhausted jobs with:
- correlation ID;
- action ID if applicable;
- workflow;
- failure class;
- retry history;
- last error code;
- created/updated timestamps.

Never include secrets.

## Reconciliation

Unknown commerce execution is high priority.

Monitor:
- `UNKNOWN`;
- `RECONCILIATION_REQUIRED`;
- reconciliation age;
- reconciliation backlog.

Recovery must query authoritative commerce state. Never infer the result from timeout alone.
