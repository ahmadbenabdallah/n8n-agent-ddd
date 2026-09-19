# WF-12 Idempotency and Race Control

Cart mutations are retry-sensitive.

Every mutation receives a deterministic idempotency key bound to:
- conversation;
- action;
- canonical product/variation;
- requested quantity;
- client/request identity.

Duplicate request:
→ return/reconcile prior result when safe
→ never blindly apply mutation twice.

## Concurrency
Use canonical cart version/state where available.

If cart changed between authorization and execution:
- invalidate stale authorization when required;
- re-read cart;
- re-authorize consequential mutation;
- do not overwrite newer customer changes silently.

A timeout with unknown execution must enter reconciliation, not blind retry.
