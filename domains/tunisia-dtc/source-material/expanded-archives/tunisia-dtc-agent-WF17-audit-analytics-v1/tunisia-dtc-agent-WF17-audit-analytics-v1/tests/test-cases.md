# WF-17 Test Cases

T01 — valid security_decision event → persisted.

T02 — missing event_id → rejected.

T03 — event contains CVV → rejected, not persisted.

T04 — event contains OTP → rejected.

T05 — event contains API key → rejected.

T06 — event contains system prompt text → rejected.

T07 — metadata contains raw customer_message → field removed before persistence.

T08 — metadata contains retrieved_chunk_text → removed.

T09 — event has trace_id + conversation_id → retained as internal references.

T10 — transaction event with amount/status but no payment secrets → allowed.

T11 — transaction event with card number → rejected.

T12 — duplicate event_id → database unique constraint prevents duplicate.

T13 — previous fingerprint supplied → retained as chain reference.

T14 — analytics reads audit through read-only view, not customer workflow.

T15 — customer asks for internal audit/security score → audit data is not exposed.

T16 — audit persistence adapter unavailable → event should enter a durable retry/dead-letter mechanism; customer response must not depend synchronously on audit success unless policy requires it.
