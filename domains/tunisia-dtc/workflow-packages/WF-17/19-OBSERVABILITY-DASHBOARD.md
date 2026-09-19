# WF-17 Dashboard

Recommended dashboard sections:

## System health
- requests/minute;
- workflow error rate;
- p95/p99 latency;
- timeout rate;
- retry rate.

## Action integrity
- authorization decisions;
- execution outcomes;
- verification outcomes;
- unknown/reconciliation backlog;
- duplicate/replay detections.

## Commerce
- cart success;
- checkout preflight failures;
- order creation;
- payment state distribution.

## Human support
- escalation volume;
- assignment latency;
- human response latency;
- unresolved cases.

## AI quality
- structured-output rejection;
- claim validation failures;
- fallback rate;
- token usage;
- model latency.

## Security
- incidents by category;
- identity conflicts;
- privacy blocks;
- prompt injection indicators.

Dashboards should not expose customer secrets or unrestricted private content.
