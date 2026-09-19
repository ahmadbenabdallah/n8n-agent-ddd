# Requirements

- n8n
- append-only or restricted audit store
- retention policy
- access controls
- event taxonomy
- trace/correlation IDs
- optional analytics pipeline

## Recommended event types

`inbound_received`
`security_decision`
`identity_decision`
`state_transition`
`intent_classified`
`retrieval_performed`
`llm_proposal`
`action_validated`
`commerce_execution`
`commerce_verification`
`escalation_created`
`response_rendered`
`response_sent`
`error`
`maintenance`

## Access

Audit data is operational/security data. Restrict access by role and do not expose it to the customer-facing agent.
