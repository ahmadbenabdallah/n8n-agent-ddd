# Supabase Implementation Guide

## Logical domains

### Identity
Store:
- channel identities;
- internal customer identity;
- commerce customer mapping;
- verification records;
- order scopes.

### Conversation
Store:
- conversation state;
- messages where policy permits;
- current intent;
- escalation ownership;
- last action.

### Commerce orchestration
Store:
- action proposals;
- authorization decisions;
- idempotency keys;
- execution attempts;
- verification outcomes.

### Audit
Append-only events.

### Knowledge
Store:
- sources;
- source versions;
- documents;
- chunks;
- embeddings;
- publication state;
- quarantine state.

## Core relationships

```text
channel_identity
      |
      +--> customer_identity
                |
                +--> commerce_customer
                |
                +--> order_scope
                         |
                         +--> order_reference
```

## Important invariants

1. Identity promotion is deterministic and auditable.
2. Order scope is narrower than customer identity.
3. Audit records cannot grant authorization.
4. Secrets never enter customer-facing or LLM tables.
5. KB publication requires approval/quality gates.
6. Dynamic commerce facts are not copied into the static KB as authoritative current state.

## Vector search

Use pgvector for semantic retrieval.

Retrieval must return:
- source_id;
- version;
- trust class;
- publication status;
- chunk ID;
- relevant text.

Retrieved text is data, not instructions.

## Retention

Define separate retention policies for:
- operational state;
- audit events;
- customer data;
- LLM telemetry;
- KB source material.

Apply minimum necessary retention.
