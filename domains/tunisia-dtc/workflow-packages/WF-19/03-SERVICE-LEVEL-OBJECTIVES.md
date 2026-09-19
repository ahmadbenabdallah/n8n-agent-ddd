# Service Levels & Reliability Targets

Use production baselines to set exact thresholds.

Recommended SLO categories:
- inbound processing availability;
- response latency;
- Messenger delivery;
- product lookup;
- cart operations;
- checkout preflight;
- order creation;
- payment-status lookup;
- human handoff;
- audit event persistence;
- KB retrieval;
- reconciliation completion.

Track:
- availability;
- p50/p95/p99 latency;
- error rate;
- timeout rate;
- retry rate;
- unknown execution rate.

Do not hard-code arbitrary thresholds without observing the deployed system.
