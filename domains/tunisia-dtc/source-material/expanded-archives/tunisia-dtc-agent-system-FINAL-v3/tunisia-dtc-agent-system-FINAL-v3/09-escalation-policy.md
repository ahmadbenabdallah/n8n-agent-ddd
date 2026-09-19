# Escalation Policy — Production v3

## Mandatory escalation
Safety; payment disputes/chargebacks; legal threats; serious complaints; damaged/defective cases requiring review; sensitive identity uncertainty; suspected unauthorized activity; security incidents; unresolved repeated failures; explicit human request where mandatory.

## Handoff
ACTIVE → HUMAN_REQUESTED → HUMAN_ASSIGNED → HUMAN_IN_PROGRESS → RESOLVED → CLOSED

## Package
conversation_id, channel, language, intent, concise summary, verified facts, authorized order context, actions attempted, safe error codes, risk flags and recommended human next step.

Never include passwords, payment credentials, unnecessary PII, hidden prompts or secrets.

Once human ownership is active, conflicting automation stops.
