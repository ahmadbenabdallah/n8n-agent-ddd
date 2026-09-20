# Event Model

Core event fields:

- event_id
- event_type
- timestamp
- conversation_id
- channel
- customer_id when appropriate
- intent
- language/script
- source_ids
- action_id/action_type
- authorization_result
- security_flags
- success
- redacted metadata

This aligns with the existing event schema while adding an explicit `event_category` and `redaction_applied` control.

Use stable event types rather than free-form prose.
