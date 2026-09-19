# WF-17 Regression Matrix

T01 Valid event -> persisted.
T02 Duplicate event_id -> single record.
T03 Missing event_type -> rejected.
T04 Invalid channel -> rejected.
T05 API key field -> redacted.
T06 Cart-Token field -> redacted.
T07 OTP/PIN/CVV/PAN field -> redacted.
T08 Phone/address/email metadata -> removed from general analytics metadata.
T09 Security event -> category=security.
T10 Order/checkout event -> category=commerce.
T11 Failure event -> reliability classification.
T12 Source IDs preserved for KB event.
T13 Authorization result preserved.
T14 Customer cannot query unrestricted audit events.
T15 Audit record cannot be used as action authorization.
T16 Renderer/LLM never receives unrestricted audit payload.
T17 Same action_id with multiple lifecycle events -> distinct event_ids, traceable by action_id.
T18 Retention policy removes/anonymizes data according to configured period.
