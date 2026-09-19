# Requirements

- n8n
- monitoring source(s) for n8n executions
- Meta API health signal
- OpenAI API health signal
- Supabase health signal
- commerce API health signal
- KB ingestion metrics
- audit/analytics metrics from WF-17
- alert destination (email/Slack/PagerDuty/etc.)
- persistence store for monitoring snapshots

## Suggested cadence
Run every 5–15 minutes for operational checks. Security incidents can be event-driven in addition to scheduled checks.

## Alerting
Use severity:
- `critical`
- `warning`
- `ok`

Do not send raw audit/customer data into alert channels.
