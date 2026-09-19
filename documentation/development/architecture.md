---
title: Architecture Guidelines
category: Development
order: 2
---

# Architecture Guidelines

## Layering

Prefer:

```text
Domain
  ↓
Platform contracts
  ↓
Ports
  ↓
Adapters
  ↓
Infrastructure
```

Domain logic should not depend on a specific vendor API.

## Business truth

When a commerce adapter exists, the provider is authoritative for live:

- product state
- price
- inventory
- promotion
- order state

Knowledge is secondary for live commerce facts.

## Authorization boundary

```text
LLM proposal
 → n8n validation
 → WF-10 authorization
 → WF-20 privileged execution
 → provider verification
```

Only the authorized branch can approve execution.

## Identity

Identity assurance follows:

`ANONYMOUS → CHANNEL-LINKED → COMMERCE-MATCHED → ORDER-VERIFIED → HIGH-ASSURANCE`

The LLM cannot promote identity.

## State

Critical business state belongs in durable PostgreSQL/Supabase-backed storage.

## Idempotency

Externally visible mutations require an idempotency strategy. Unknown outcomes require reconciliation.

## Domain isolation

Cross-domain access is denied by default and requires an explicit contract, authorization, and audit trail.
