# Tunisia DTC AI Agent — v1

This package combines the canonical `/agent/` specification with the initial `/knowledge-base/` scaffold.

## Layers

- `/agent/` — prompts, business logic, security, identity, state, escalation, schemas, n8n architecture, red-team tests
- `/knowledge-base/` — products, policies, FAQs and KB governance

## Architecture principle

LLM proposes → validator authorizes → commerce system executes.

## Current status

The merchant-specific fields marked `[TO FILL]` must be replaced with verified business data before production.

Next implementation layer:
1. real merchant product/policy data
2. database schema
3. RAG ingestion/chunking
4. n8n importable workflows
5. channel adapters
6. live commerce tool contracts
