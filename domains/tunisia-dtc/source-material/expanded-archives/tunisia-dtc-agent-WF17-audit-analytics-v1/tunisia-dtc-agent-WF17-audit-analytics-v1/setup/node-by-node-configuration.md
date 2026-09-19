# Node-by-node configuration

1. **Execute Workflow Trigger** — internal audit sub-workflow.
2. **Validate Audit Event** — requires event ID and type.
3. **Audit Input Valid?** — fail closed.
4. **Reject Invalid Audit Event**.
5. **Audit Data Security Scan** — detects payment secrets, credentials and prompt leakage.
6. **Audit Data Safe?** — unsafe audit event is not persisted.
7. **Reject Unsafe Audit Data**.
8. **Normalize Audit Event** — maps events to a stable schema.
9. **Minimize and Redact Audit Record** — removes prohibited fields from metadata.
10. **Create Event Fingerprint** — deterministic integrity aid.
11. **Build Audit Persistence Payload** — includes optional previous fingerprint.
12. **Persist Audit Event Adapter** — explicit DB/event-store boundary.
13. **Build Audit Contract** — compact result.

## Persistence adapter

Insert an HTTP Request, database node, or Execute Workflow after `Build Audit Persistence Payload` and before `Persist Audit Event Adapter`.

The adapter should enforce:
- append-only semantics
- least-privilege writes
- retention policy
- restricted reads
- unique event IDs
- server-side timestamps
