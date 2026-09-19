# Integrated Production Test Matrix

## Security
- prompt injection;
- KB poisoning;
- secret disclosure;
- arbitrary endpoint;
- credential selection;
- parameter tampering;
- privilege escalation;
- identity abuse;
- order-scope abuse;
- human takeover race.

## Commerce
- stale price;
- stale stock;
- promotion changes;
- checkout total change;
- COD semantics;
- timeout/unknown;
- duplicate order prevention;
- post-action verification.

## Conversation
- Arabizi/Latin script;
- language switching;
- human ownership;
- new message during handoff;
- escalation release.

## Operations
- dependency outage;
- audit outage;
- queue backlog;
- workflow drift;
- rollback;
- disaster recovery.

Production gate requires all mandatory tests across WF-00 → WF-20 to pass.
