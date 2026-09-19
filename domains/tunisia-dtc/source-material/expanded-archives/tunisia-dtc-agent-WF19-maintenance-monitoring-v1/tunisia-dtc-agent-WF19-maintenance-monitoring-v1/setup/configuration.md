# Configuration

Example thresholds:
- `kb_stale_hours=72`
- `queue_depth_warning=100`
- `execution_failures_last_hour_warning=10`
- `transaction_verification_failures_warning=5`

Tune these using production baselines; these are starting thresholds, not universal SLOs.

## Critical events
Any confirmed security incident is `critical` in this reference workflow.

## Persistence
Store snapshots in a restricted operational database/table. Keep only the minimum metadata needed for troubleshooting and trend analysis.
