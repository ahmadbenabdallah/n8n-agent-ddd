# WF-12 Cart Service v2

WF-12 owns the agent-level cart contract and policy, but does not invent transactional truth.

## Architecture

Messenger identity
→ WF-02 identity
→ WF-12 cart policy
→ WF-11 live product/stock validation
→ WF-20 WooCommerce gateway
→ WooCommerce cart state
→ verify
→ renderer

## Important design decision

The agent must not maintain a second authoritative price/stock ledger.

For this Messenger-first deployment, the durable mapping is:

`customer_id + conversation_id → WooCommerce cart/session reference`

The exact Store API session mechanism is implemented in WF-20, not in WF-12.

WF-12 therefore remains stable if the WooCommerce session implementation changes.

## Operations

- cart_view
- cart_add
- cart_remove
- cart_update
- cart_clear

Mutations require explicit authorization from the upstream authorization layer.
