# Change Log

## v5 — Full Implementation Guide
- Expanded v4 architecture into a build-order guide.
- Added workflow-by-workflow implementation responsibilities.
- Added data contracts.
- Added Supabase implementation guidance.
- Added self-hosted n8n deployment guidance.
- Added detailed WooCommerce gateway procedure.
- Added identity/order-scope and human ownership guide.
- Added LLM/RAG implementation contract.
- Added OWASP/security control guide.
- Added renderer, audit, KB, testing, incident/recovery guides.
- Added master implementation checklist.
- Added update/change-control process.
- Added production Definition of Done.

## Preserved v4 invariants
The core v4 authority model remains unchanged:
LLM proposes → n8n validates → WF-10 authorizes → WF-20 executes → WooCommerce verifies → WF-16 renders → WF-17 audits → WF-19 monitors.
