# Knowledge Conflict Resolution

Conflicts must not be silently resolved by the LLM.

Precedence should be deterministic, for example:

1. explicit current business policy;
2. newer approved version of the same policy;
3. approved specialized policy over generic guidance;
4. otherwise escalate/ask for clarification.

If two approved sources materially conflict and no deterministic precedence rule exists:
- mark conflict;
- block automatic publication/retrieval for the affected claim where appropriate;
- route to owner review.

Live commerce facts always supersede static KB for mutable transactional fields.
