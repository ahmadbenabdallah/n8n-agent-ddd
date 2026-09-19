# Health Check Matrix

| Component | Check | Failure impact |
|---|---|---|
| n8n | execution/queue health | workflow degradation |
| Supabase | DB connectivity/latency | state/audit degradation |
| pgvector | query/index health | RAG degradation |
| OpenAI | API health/error rate | reasoning degradation |
| Messenger | webhook/send health | channel degradation |
| WooCommerce | REST/Store API health | commerce degradation |
| WF-20 | gateway health | commerce unavailable |
| WF-17 | audit ingestion | audit/outbox pressure |
| WF-18 | ingestion/index health | KB freshness degradation |
| Human cases | queue/SLA health | support degradation |

Health checks must avoid causing business side effects.

Use read-only probes where possible.
