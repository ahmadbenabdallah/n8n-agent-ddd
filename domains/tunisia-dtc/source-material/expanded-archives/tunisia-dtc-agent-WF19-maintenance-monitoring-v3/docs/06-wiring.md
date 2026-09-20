# Wiring

1. Apply `006_maintenance_runs.sql`.
2. Import WF-19.
3. Configure least-privilege Supabase credentials.
4. Add environment-specific probes:
   - WF-20 `health`
   - n8n execution status API
   - Supabase connectivity
   - KB freshness/index checks
   - WF-17 security-event counts
5. Schedule health checks externally through n8n schedules/cron according to operational needs.
6. Route critical alerts to the selected operations channel.
7. Keep remediation inside bounded workflows.
8. Test outage, recovery and duplicate execution scenarios.
