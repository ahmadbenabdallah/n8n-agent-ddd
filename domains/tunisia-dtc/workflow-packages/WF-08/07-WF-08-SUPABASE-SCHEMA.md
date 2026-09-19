# WF-08 Supabase Schema Contract

## human_cases

Suggested columns:

```text
id
case_id
conversation_id
customer_id
channel
status
reason_code
risk_level
priority
human_owner_id
created_at
assigned_at
first_human_response_at
resolved_at
closed_at
sla_deadline
idempotency_key
state_version
resolution_code
resolution_notes_reference
last_event_id
updated_at
```

## human_case_events

```text
event_id
case_id
conversation_id
event_type
actor_type
actor_id
previous_status
new_status
previous_owner
new_owner
idempotency_key
created_at
metadata
```

Metadata must exclude secrets and unnecessary sensitive data.

## conversation_state additions

WF-03 should own canonical conversation-level fields:

```text
conversation_owner
automation_mode
human_owner_id
case_id
escalation_status
```

WF-08 is the lifecycle authority for the human case, while WF-03 remains the canonical conversation-state store.

## RLS posture

Customers must never be able to directly mutate:
- human_cases
- human_case_events
- conversation ownership
- human_owner_id
- escalation status

Only trusted server-side/service-role paths may perform lifecycle mutations, with strict authorization.
