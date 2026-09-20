# Wiring

WF-17 should be called asynchronously where possible so audit latency does not block customer responses.

Recommended producers:
- WF-00 through WF-16 lifecycle events
- WF-18 KB ingestion
- WF-19 maintenance/monitoring
- WF-20 commerce events

For critical transaction events, persist the audit event durably before declaring the operational workflow fully complete when practical.

Use the same Supabase/Postgres environment with a dedicated least-privilege audit writer role.
