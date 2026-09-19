# Tunisia DTC AI Commerce Agent — FINAL Production Guide v1

This guide is the consolidated production specification for WF-00 through WF-20.

## Production architecture

LLM proposes → n8n validates/authorizes → commerce executes → n8n verifies → renderer replies.

The LLM is never the execution authority. WF-10 is the hard authorization boundary. WF-20 is the only privileged WooCommerce integration boundary.

## Current target stack

- Channel: Meta Messenger first
- Orchestration: self-hosted n8n
- Commerce: WooCommerce
- Payment: Cash on Delivery (COD)
- Shipping: manual initially
- AI: OpenAI
- RAG: Supabase + pgvector
- Persistent identity/context: Supabase
- Audit/analytics: Supabase
- Production operation: staged deployment, backups, monitoring, rollback, security testing

## Workflow numbering

WF-00 Inbound Gateway
WF-01 Security Gate
WF-02 Identity
WF-03 Conversation State
WF-04 Intent Router
WF-05 Sales Engine
WF-06 Support Engine
WF-07 Order Service
WF-08 Escalation Engine
WF-09 LLM Reasoning
WF-10 Action Validator
WF-11 Product Service
WF-12 Cart Service
WF-13 Promotion Service
WF-14 Checkout Service
WF-15 Transaction Service
WF-16 Response Renderer
WF-17 Audit & Analytics
WF-18 KB Ingestion
WF-19 Maintenance & Monitoring
WF-20 WooCommerce Gateway

Note: WF-00..WF-20 is 21 numbered workflows. The project may still refer to the architecture as the “20-workflow architecture”; this guide uses the exact WF numbers.

## How to use this package

1. Read `01-MASTER-PRODUCTION-SPEC.md`.
2. Read `02-WORKFLOW-MAP.md` and `03-WF-PRODUCTION-MATRIX.md`.
3. Configure n8n using `04-N8N-PRODUCTION-RUNBOOK.md`.
4. Apply security and data boundaries before connecting credentials.
5. Apply database/KB/commerce contracts.
6. Execute the full regression, E2E, load, failure-injection and red-team suite.
7. Complete the production gate. No partial pass is considered production-ready.

## Definition of production-ready

“Production-ready” means the design, workflow contracts, security boundaries, credentials, integrations, database migrations, monitoring, backups, rollback, and test evidence are all verified in the target environment. A JSON workflow export alone is not evidence of production readiness.
