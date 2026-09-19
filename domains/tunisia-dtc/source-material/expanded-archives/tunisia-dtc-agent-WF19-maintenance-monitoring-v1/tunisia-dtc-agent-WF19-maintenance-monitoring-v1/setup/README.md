# WF-19 — Maintenance & Monitoring v1

Operational health and anomaly-monitoring workflow for the complete Tunisia DTC AI-agent system.

## Monitors

- n8n health
- Meta channel/API health
- OpenAI health
- Supabase health
- commerce health
- workflow failures
- stuck executions
- queue depth
- KB freshness
- quarantined/failed KB ingestion
- security incidents
- duplicate actions
- velocity/security blocks
- renderer regeneration spikes
- transaction verification failures

## Principle

WF-19 observes and alerts. It must not silently modify business authorization or commerce state.

Critical security/transaction anomalies require human/operational handling.

The health sources are explicit adapter inputs so the workflow does not pretend to have access to a specific infrastructure stack.
