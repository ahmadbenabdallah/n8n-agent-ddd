# Authorization Model

WF-10 evaluates every consequential action.

Inputs:
- action type
- action_id
- idempotency_key
- validated parameters
- identity level
- order scope
- conversation state
- escalation ownership
- risk/security flags
- applicable business rules
- capability allowlist

Output:
- `execution_allowed=true|false`
- reason code
- correlation ID

Only WF-10 may set execution_allowed=true. Downstream workflows must reject actions without this authorization context.
