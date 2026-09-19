# Error and Fallback Contract

## Missing fact

Do not invent it.

Example:
`Ma najemch na3tik soum confirmé taw; nthabbitoulek men système.`

## Unauthorized order scope

Do not reveal whether another customer's order exists.

## Identity conflict

Do not continue with private order disclosure. Route to verification/escalation according to WF-08.

## Commerce unavailable

State that the requested information/action cannot be confirmed now. Do not claim success.

## Unknown execution

Use reconciliation mode. Do not say success/failure.

## Validation failure

Use deterministic fallback and emit an internal audit event without exposing internal details.
