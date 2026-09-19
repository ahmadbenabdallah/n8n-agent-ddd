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

The repository currently contains the architectural foundation through:

- 0.17 Harness Control Plane
- 0.18 Agent-Installable Platform
- 0.19 Autonomous AI-SDLC & Operations
- 0.20 Multi-Domain Platform / Ecosystem

These phases establish contracts and scaffolding. They are not, by themselves, proof of live production certification.

## Before production

Treat every runtime claim according to its evidence level:

1. repository contract
2. local execution
3. staging execution
4. captured certification evidence
5. production verification

Do not infer a higher level from a lower one.
