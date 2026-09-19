# WF-20 Observability & Audit

Record:
- gateway operation ID;
- correlation ID;
- request ID;
- action ID;
- authorization ID reference;
- operation type;
- endpoint/resource class;
- execution state;
- verification state;
- latency;
- retry count;
- HTTP status class;
- error category;
- commerce operation reference;
- workflow version.

Do not log:
- credentials;
- authorization secrets;
- Cart-Tokens;
- Nonce Tokens;
- payment credentials;
- unnecessary PII;
- raw customer/order payloads.

Emit lifecycle events to WF-17.
