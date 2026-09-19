# Conversation State — Production v3

Canonical state is persisted outside the LLM.

## Required fields
conversation_id
channel
language
script
intent
sub_intent
sales_stage
identity_level
selected_products
cart_id
order_scope
last_action_id
last_idempotency_key
last_authorization_result
last_execution_result
last_verified_commerce_at
turn_count
escalation_status
human_owner
risk_flags
recovery_status
last_updated

## Rules
- Allowlisted state transitions only.
- Idempotent writes.
- State survives webhook retries and workflow restarts.
- LLM suggestions are advisory.
- Human ownership blocks conflicting automation.
- Commerce state snapshots are not treated as permanent truth; re-read when freshness matters.
