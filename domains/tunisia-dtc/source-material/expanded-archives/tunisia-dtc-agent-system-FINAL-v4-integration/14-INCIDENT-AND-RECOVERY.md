# Integrated Incident & Recovery

## WooCommerce outage
- detect;
- enter approved degraded mode;
- prevent unsafe mutations;
- preserve requests;
- recover;
- reconcile unknown executions;
- validate;
- resume.

## Supabase outage
- protect canonical state;
- use durable queues/outbox where available;
- avoid unsafe writes;
- recover;
- reconcile.

## OpenAI outage
- deterministic safe fallback where supported;
- no invented facts;
- escalate when needed.

## Security incident
- restrict automation;
- preserve evidence;
- remediate;
- rotate credentials if required;
- validate security gates;
- resume explicitly.

Recovery never bypasses WF-10/WF-20.
