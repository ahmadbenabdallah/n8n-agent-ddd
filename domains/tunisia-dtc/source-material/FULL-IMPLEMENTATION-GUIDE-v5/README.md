# Tunisia DTC AI Commerce Agent — Full Implementation Guide v5

## Purpose
This package turns the v4 architecture into an implementation-ready operating guide for a self-hosted n8n + WooCommerce + Supabase/pgvector + OpenAI DTC commerce agent for Tunisia.

Primary channel: Meta Messenger.
Payment: Cash on Delivery (COD).
Shipping: manual initially.

## Non-negotiable architecture

> **LLM proposes → n8n validates → WF-10 authorizes → WF-20 executes → WooCommerce verifies → WF-16 renders → WF-17 audits → WF-19 monitors.**

The LLM is never the execution authority. WF-10 is the hard authorization boundary. WF-20 is the only privileged WooCommerce boundary.

## Included
1. Master implementation plan
2. Environment/configuration guide
3. Supabase data model
4. n8n deployment and workflow build guide
5. Detailed guide for WF-00 through WF-20
6. Identity/order-scope guide
7. Sales/support/commerce business logic
8. LLM + RAG contract
9. Security/OWASP controls
10. WooCommerce gateway guide
11. Response renderer guide
12. Audit/observability guide
13. Testing and red-team guide
14. Incident/recovery runbooks
15. Production Definition of Done
16. Change-control/update guide

## Scope
This guide preserves the v4 architecture and adds implementation sequencing, contracts, gates, operational procedures, and deployment checklists. It does not remove any workflow merely to simplify the build.
