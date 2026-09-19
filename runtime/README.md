# Runtime

n8n-agent-ddd is n8n-first at runtime.

Runtime responsibilities are deliberately separated:

- n8n: orchestration and workflow execution.
- Supabase/Postgres: durable domain/application state.
- Redis: optional queue and worker coordination.
- reverse proxy: ingress/TLS/routing.
- monitoring: health and operational signals.

Critical business state must not live only in n8n execution history.
