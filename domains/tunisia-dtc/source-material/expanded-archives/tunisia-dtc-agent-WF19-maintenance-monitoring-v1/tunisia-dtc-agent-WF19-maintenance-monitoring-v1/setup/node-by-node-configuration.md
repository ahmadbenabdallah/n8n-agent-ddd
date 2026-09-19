# Node-by-node configuration

1. **Execute Workflow Trigger** — internal scheduled/event trigger.
2. **Validate Monitoring Input** — requires monitoring config and health sources.
3. **Monitoring Input Valid?** — fail closed.
4. **Reject Invalid Monitoring Input**.
5. **Build Monitoring Context** — normalizes services, thresholds and health.
6. **Check Workflow Executions** — failure/stuck/queue metrics.
7. **Check KB Freshness** — age, quarantine and ingestion failures.
8. **Check Security and Commerce Anomalies** — security, duplicate, renderer and transaction anomalies.
9. **Evaluate Monitoring Thresholds** — creates alert list and severity.
10. **Alert Required?**.
11. **Build Operational Alert** — human-action signal.
12. **Build Healthy Status**.
13. **Build Monitoring Snapshot** — common snapshot.
14. **Persist Monitoring Snapshot Adapter**.
15. **Build Maintenance Contract**.

## Alert adapter

After the final contract, connect your notification system. Keep alert messages short and sanitized.

## Health-source adapters

Populate `health_sources` from real API/database checks. Do not put customer messages or secrets into these fields.
