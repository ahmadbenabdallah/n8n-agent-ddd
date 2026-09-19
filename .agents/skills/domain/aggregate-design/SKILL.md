---
name: domain:aggregate-design
description: Design DDD aggregates, invariants, commands and consistency boundaries for a domain.
---

# domain:aggregate-design

## Required sequence

1. Read the domain manifest.
2. Identify aggregate roots and ownership.
3. Define invariants.
4. Define commands and resulting events.
5. Define consistency boundaries.
6. Map affected contracts.
7. Validate that orchestration code does not become the business-rule source of truth.

## Safety

Do not invent domain rules when the source specification is incomplete. Surface ambiguity.
