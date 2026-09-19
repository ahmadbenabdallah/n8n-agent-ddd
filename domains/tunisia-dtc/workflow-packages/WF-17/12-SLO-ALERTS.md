# SLOs & Alerting

Suggested alert classes:

### Critical
- repeated authorization bypass indicators;
- secrets detected in logs;
- unexpected direct WF-20 access;
- audit pipeline unavailable for consequential actions;
- duplicate commerce execution detected;
- payment-state integrity anomaly.

### High
- unknown execution rate spike;
- reconciliation backlog;
- human handoff queue failure;
- widespread response validation failures;
- Messenger delivery outage.

### Medium
- latency degradation;
- elevated LLM output rejection;
- rising fallback rate;
- elevated workflow retry rate.

Alert thresholds should be calibrated from production baselines rather than arbitrary universal numbers.

An alert should include:
- metric;
- observed value;
- threshold;
- time window;
- affected workflow;
- correlation samples;
- runbook reference.
