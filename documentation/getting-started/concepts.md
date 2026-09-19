---
title: Core Concepts
category: Getting Started
order: 2
---

# Core Concepts

## Domain-driven design

Business logic belongs to the domain layer. External providers are accessed through ports and adapters.

## Runtime invariant

```text
LLM proposes
  ↓
n8n validates
  ↓
WF-10 authorizes
  ↓
WF-20 executes privileged commerce operation
  ↓
commerce provider verifies
  ↓
WF-16 renders verified facts
  ↓
WF-17 audits
  ↓
WF-19 monitors/reconciles
```

The LLM proposes actions. It does not become the authorization boundary.

## 21-workflow runtime

The reference runtime defines exactly WF-00 through WF-20.

Protected workflows include:

- WF-01 Security Gate
- WF-10 Action Authorization
- WF-15 Transaction/Payment
- WF-20 WooCommerce Gateway

## Ports

The platform separates provider-specific implementations from domain logic through:

- ChannelPort
- CommercePort
- IdentityPort
- PaymentPort
- KnowledgePort
- ObservabilityPort

## Durable state

PostgreSQL/Supabase owns durable application/domain state. n8n is orchestration and is replaceable.

## Domain isolation

Every domain has a stable `domain_id` and scoped runtime/data/knowledge/authorization/audit boundaries.

Cross-domain access is denied by default.

## Assisted Commerce

When no live commerce adapter exists:

- informational requests can use knowledge
- transactional requests collect the required information and escalate
- the system must not pretend that a commerce mutation happened

## Identity

Identity assurance progresses from anonymous/channel-linked context toward verified order scope. The LLM cannot promote identity assurance.
