# Maintenance Jobs

Examples:

### Daily
- stale execution scan;
- dead-letter scan;
- reconciliation backlog scan;
- workflow health;
- certificate/credential expiry horizon;
- KB freshness check;
- audit outbox lag.

### Weekly
- backup verification;
- restore drill sample;
- workflow drift audit;
- vector/index health;
- security-control verification;
- dependency schema check.

### Periodic
- dependency version review;
- prompt/model version inventory;
- RLS review;
- retention cleanup;
- performance review.

Maintenance jobs must be bounded, observable, idempotent, and reversible where possible.
