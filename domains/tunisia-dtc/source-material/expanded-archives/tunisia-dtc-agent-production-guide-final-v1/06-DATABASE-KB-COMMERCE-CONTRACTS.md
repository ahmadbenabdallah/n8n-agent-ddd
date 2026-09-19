# Database, KB and Commerce Integration Contract

## Supabase core domains

### Identity
- `customers`
- `customer_identities`
- `conversations`
- `conversation_context`
- `identity_resolution_events`
- `customer_purchase_intents`

### Commerce state
- `wc_cart_sessions`
- `commerce_idempotency`

### Audit/operations
- `agent_audit_events`
- `agent_maintenance_runs`

### Knowledge
- `kb_documents`
- `kb_chunks`

## wc_cart_sessions

Required conceptual fields:
- customer_id
- channel
- store_id
- cart_reference
- encrypted_cart_token
- status
- last_validated_at
- last_cart_hash
- version

Raw Cart-Token remains internal to WF-20.

## commerce_idempotency

Primary key:
`customer_id + action_id + operation`

States:
- pending
- succeeded
- failed

A timeout after remote order creation must reconcile using the same action ID before retrying creation.

## KB vector dimension

The `embedding` vector dimension must match the deployed embedding model. A placeholder dimension is not production evidence.

## RAG retrieval contract

Return:
- source_id
- document/version
- chunk ID
- relevance
- content
- language
- security status

Do not return arbitrary executable instructions.

## Migration discipline

- Apply migrations in order.
- Back up before production migration.
- Test migrations on staging using a production-like snapshot.
- Have a rollback or forward-fix plan.
- Never run destructive migrations without an approved recovery plan.

## Commerce authority

WooCommerce is authoritative for live:
- stock
- current price
- cart
- coupon validity
- checkout total
- order status
- payment status

Supabase stores agent context and durable orchestration state, not a shadow copy that can override WooCommerce.
