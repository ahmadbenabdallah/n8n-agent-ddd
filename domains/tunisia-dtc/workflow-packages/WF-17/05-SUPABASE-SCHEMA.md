# Supabase Persistence Model

Suggested tables:

## audit_events

- id
- event_id
- event_type
- timestamp
- correlation_id
- request_id
- conversation_id
- workflow
- workflow_version
- action_id
- action_type
- authorization_result
- execution_state
- commerce_operation_id
- response_id
- case_id
- identity_level
- identity_state
- order_scope_ref
- intent
- success
- duration_ms
- retry_count
- error_code
- metadata_redacted
- created_at

## action_audit

One logical row per consequential action, linked to its event history.

Fields:
- action_id
- conversation_id
- action_type
- normalized_params_hash
- authorization_decision
- execution_state
- verification_state
- first_seen_at
- completed_at
- reconciliation_state

## security_events

Fields:
- security_event_id
- correlation_id
- category
- severity
- detection_source
- action_taken
- created_at

Do not store secrets in these tables.

## RLS

- application service role may append events;
- analytics roles receive minimum required read access;
- customer-facing workflows cannot query unrestricted audit history;
- human support access should be scoped;
- security event access is restricted.

## Retention

Retention should be configured by data category and legal/business requirements, not one universal duration.
