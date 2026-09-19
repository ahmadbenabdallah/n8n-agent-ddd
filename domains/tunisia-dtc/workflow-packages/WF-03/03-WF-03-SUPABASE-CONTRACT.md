# WF-03 Supabase Persistence Contract

## Recommended table

`conversation_state`

Core columns:

- `conversation_id` PK
- `channel`
- `customer_id`
- `channel_identity_id`
- `commerce_identity_id`
- `identity_level`
- `identity_status`
- `identity_conflict`
- `order_scope_ids` jsonb
- `intent`
- `sub_intent`
- `sales_stage`
- `selected_products` jsonb
- `cart_id`
- `commerce_session_ref`
- `conversation_owner`
- `automation_mode`
- `human_owner_id`
- `case_id`
- `escalation_status`
- `acknowledgement_state`
- `pending_action_id`
- `last_action_id`
- `last_idempotency_key`
- `execution_status`
- `reconciliation_status`
- `verification_status`
- `last_verified_at`
- `turn_count`
- `automated_turn_count`
- `risk_flags` jsonb
- `security_flags` jsonb
- `last_updated_at`

## Concurrency

Use optimistic concurrency or an equivalent atomic update mechanism.

A stale worker must not overwrite newer:
- human ownership;
- scope;
- action;
- reconciliation;
- security state.

Recommended control fields:
- `state_version`
- `updated_at`

A conditional update should require the expected `state_version`.

## Sensitive data

Do not store:
- PAN/card number;
- CVV;
- OTP;
- password;
- API secret;
- WooCommerce credentials;
- Cart-Token/Nonce in LLM context or customer-visible state.
