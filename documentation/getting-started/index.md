---
title: Getting Started
category: Getting Started
order: 1
---

# Getting Started

**n8n Agent DDD** is an open-source, domain-driven autonomous agent runtime built around n8n.

The project has two deliberately separate layers.

## 1. Customer runtime

The deployed business agent is the n8n/domain runtime:

- n8n workflows
- domain rules and policies
- LLM reasoning
- channel adapters
- commerce adapters
- PostgreSQL/Supabase state
- knowledge
- authorization
- audit and reconciliation

## 2. Developer/AI control plane

The Harness control plane is used by developers and AI coding agents such as Claude Code and Codex:

```text
Claude Code / Codex
        ↓
     Harness
        ↓
 Skills / MCP / Git / CI
        ↓
 tests / security / validation / deployment
        ↓
     runtime
```

Harness is not the customer runtime and does not replace n8n's native workflow dashboard.

## Reference domain

The first concrete domain is Tunisia DTC e-commerce sales/support.

The architecture is intended to support additional domain packs such as Umrah and dental without copying domain-specific business rules.

## Current maturity

The repository holds the architectural foundation: contracts, specifications, the domain model, the database schema and repository checks.

The runtime is not built yet:

- all 21 of the reference domain's runtime workflows are placeholders; four real graphs exist in the shared library (`platform/workflows/`); the reference domain keeps its own provenance copies under `domains/tunisia-dtc/workflow-packages/`
- the authorization and execution roles are enforced in platform code (`platform/authorization/port.ts`, behaviourally tested), but no n8n graph calls them
- inbound webhook signatures are verified before normalisation (`platform/channels/meta-signature.ts`: HMAC-SHA256 over the raw body, constant-time)
- deployment and operations scripts are placeholders
- no workflow has been imported or activated in a running n8n

Nothing here has been run end to end. Contracts and scaffolding are not proof of a working system, and certainly not of production certification.

## Before production

Treat every runtime claim according to its evidence level:

1. repository contract
2. local execution
3. staging execution
4. captured certification evidence
5. production verification

Do not infer a higher level from a lower one.
