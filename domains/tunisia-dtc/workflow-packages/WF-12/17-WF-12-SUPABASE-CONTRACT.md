# WF-12 Supabase Contract

WF-03 remains canonical for conversation state.

Recommended cart-related state:
- `cart_id`
- `cart_status`
- `commerce_identity_id`
- `cart_version`
- `last_cart_sync_at`
- `last_cart_action_id`
- `last_cart_idempotency_key`
- `execution_status`
- `reconciliation_status`

Do not persist raw commerce secrets in application state.

Persist references/metadata required for orchestration, not credentials or session tokens.
