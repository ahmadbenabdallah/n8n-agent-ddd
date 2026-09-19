# Data Model & Database Design

## Domains
- `commerce_*`: commerce-platform truth.
- `agent_*`: conversation, state, permissions, retrieval and audit.
- `analytics_*`: events and attribution.

## Core tables
`agent_conversations`, `agent_customers`, `agent_preferences`, `agent_messages`, `agent_actions`, `agent_security_events`, `agent_handoffs`, `agent_retrievals`, `agent_events`.

## Rules
- Live inventory, price and order state never become a shadow source of truth.
- Customer/order access is always scoped outside the LLM.
- Writes use idempotency keys.
- Store correlation IDs on every execution.
- Define separate retention for PII, messages, security events and analytics.

## Canonical conversation fields
`conversation_id`, `channel`, `external_thread_id`, `customer_id`, `language`, `status`, `sales_stage`, `intent`, `turn_count`, `escalation_flag`, timestamps.
