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

- 4 of the 21 workflows are real n8n workflows (WF-00, WF-01, WF-02, WF-04); the rest are placeholders
- the WF-10 to WF-20 authorization handshake is specified but not enforced
- inbound webhook signatures are not verified
- deployment and operations scripts are placeholders

Nothing here has been run end to end. Contracts and scaffolding are not proof of a working system, and certainly not of production certification.

## Before production

Treat every runtime claim according to its evidence level:

1. repository contract
2. local execution
3. staging execution
4. captured certification evidence
5. production verification

Do not infer a higher level from a lower one.
