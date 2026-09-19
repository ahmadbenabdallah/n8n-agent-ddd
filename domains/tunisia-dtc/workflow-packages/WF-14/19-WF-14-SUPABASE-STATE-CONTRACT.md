# WF-14 Supabase State Contract

WF-03 remains the canonical conversation-state owner.

Checkout-related state may include:
- `checkout_status`;
- `checkout_id`;
- `cart_id`;
- `checkout_state_version`;
- `payment_method`;
- `shipping_method`;
- `last_checkout_action_id`;
- `idempotency_key`;
- `execution_status`;
- `reconciliation_status`;
- `commerce_order_id`;
- `last_verified_checkout_at`.

Do not persist payment secrets or commerce session secrets.
State transitions must be deterministic and version-aware.
