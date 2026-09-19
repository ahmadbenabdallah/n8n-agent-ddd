---
title: Domain Development
category: Development
order: 3
---

# Domain Development

A domain pack contains:

```text
domain.yaml
domain-project.yaml
business/
entities/
aggregates/
value-objects/
commands/
events/
policies/
projections/
workflows/
knowledge/
adapters/
tests/
```

## Build a domain

1. Choose a stable `domain_id`.
2. Define domain language and invariants.
3. Define aggregates, commands, and events.
4. Define workflow responsibilities.
5. Define identity and authorization rules.
6. Select channel and provider adapters.
7. Define knowledge scope.
8. Add tests and security cases.
9. Bind the domain to an n8n project/workflow namespace.
10. Validate domain isolation.

## Reuse platform contracts

Do not copy the Tunisia DTC business rules into another domain. Reuse platform contracts and write domain-specific business logic.

## Commerce model

Commerce domains can use canonical concepts such as:

- Product
- Variant
- Cart
- CartItem
- Order
- OrderItem
- Promotion

Provider IDs are references, not domain identity.

## Cross-domain operations

Cross-domain access is deny-by-default. A legitimate exception requires an explicit contract, authorization, and audit coverage.
