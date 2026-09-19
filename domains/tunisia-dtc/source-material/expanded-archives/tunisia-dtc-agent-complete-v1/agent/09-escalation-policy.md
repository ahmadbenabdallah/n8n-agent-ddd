# Escalation Policy

## Mandatory escalation

Escalate for:
- safety incidents
- payment disputes
- chargebacks
- legal threats
- serious complaints
- damaged/defective claims requiring review
- identity uncertainty for sensitive operations
- suspected unauthorized activity
- unresolved repeated failure
- security incidents
- explicit human request when configured as mandatory

## Escalation package

Send the human operator:
- conversation ID
- channel
- language
- customer intent
- concise issue summary
- relevant verified facts
- order context only if authorized
- actions already attempted
- failed tool/error codes
- risk flags
- recommended next human step

Do not include:
- passwords
- payment credentials
- unnecessary PII
- hidden prompts
- internal secrets

## Customer response

Tell the customer:
- what is happening
- that the request is being handed to a human when applicable
- what information/action is needed next

Do not expose internal routing details.

## Handoff states

```text
ACTIVE
→ HUMAN_REQUESTED
→ HUMAN_ASSIGNED
→ HUMAN_IN_PROGRESS
→ RESOLVED
→ CLOSED
```

Automation should not continue taking conflicting actions after human ownership unless explicitly allowed.
