# Cleanup and Retention

Maintenance jobs may clean:
- expired temporary state
- stale maintenance records according to retention
- old idempotency records after the defined reconciliation window
- old audit records according to the approved retention policy
- obsolete KB versions after rollback/retention rules permit

Cleanup must be:
- bounded
- observable
- idempotent
- reversible where practical
- excluded from active transaction state

Never delete active cart-session mappings, customer identity mappings, or transaction evidence merely because they are old without a defined lifecycle policy.
