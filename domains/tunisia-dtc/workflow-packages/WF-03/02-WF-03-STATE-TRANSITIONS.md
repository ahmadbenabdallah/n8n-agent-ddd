# WF-03 State Transition Contract

## Core transition table

| Event | Required state change |
|---|---|
| New conversation | create canonical state |
| Channel identity resolved | set customer/channel identity context |
| Identity verification passed | application updates identity/scope |
| Intent classified | update intent through deterministic orchestration |
| Product selected | update selected_products |
| Cart mutation authorized | update cart reference after verified result |
| Consequential action proposed | pending_action_id + PROPOSED |
| WF-10 allows | execution_status=AUTHORIZED |
| Execution starts | EXECUTING |
| Verified success | SUCCEEDED |
| Explicit failure | FAILED |
| Timeout/unknown | UNKNOWN + recovery/reconciliation |
| Escalation requested | case_id + HUMAN_REQUESTED |
| Human accepts | owner=HUMAN |
| Human takes over | HUMAN_IN_PROGRESS |
| Human releases | owner=AI only through explicit release |
| Scope revoked | active scope references invalidated |
| Security conflict | automation_mode=PAUSED as configured |

## No implicit promotion

These are invalid transitions unless produced by the authoritative workflow:
- identity_level 1 → 2 from LLM output;
- order scope empty → active from LLM output;
- AI → HUMAN because the LLM says so;
- HUMAN → AI because the LLM says so;
- UNKNOWN → SUCCEEDED because the model infers success.
