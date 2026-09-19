# WF-10 Authorization Specification

## Purpose
WF-10 deterministically validates whether a proposed action is permitted under identity, ownership, business policy, allowlists, parameter constraints, freshness, idempotency, and security controls.

## Hard rule
Only WF-10 may set `execution_allowed=true`.

Required gates:
1. Valid request and correlation context.
2. Recognized allowlisted action.
3. Valid action parameters.
4. Identity requirement satisfied.
5. Order-scope requirement satisfied.
6. Ownership/automation mode permits the action.
7. Business rules permit the action.
8. Security/risk checks pass.
9. Required facts are fresh.
10. Idempotency/replay checks pass.
11. Required upstream preconditions are verified.

Fail closed on missing, ambiguous, stale, conflicting, or invalid conditions.

Decision states:
`AUTHORIZED | DENIED | NEEDS_CLARIFICATION | NEEDS_VERIFICATION | HUMAN_REQUIRED | RECONCILIATION_REQUIRED`

`execution_allowed=true` is valid only with `AUTHORIZED`.
