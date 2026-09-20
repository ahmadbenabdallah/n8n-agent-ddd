# WF-12 Cart Service v3

Production-oriented cart service for the Tunisia DTC agent.

## Ownership

- Supabase: customer identity/context and safe cart-session mapping.
- WooCommerce: authoritative cart contents, live price, stock and purchasability.
- WF-20: only privileged WooCommerce integration boundary.
- WF-12: validates request shape, delegates to WF-20, verifies result, and persists only safe cart reference metadata.

The agent does **not** maintain an authoritative cart ledger.

## Operations

`cart_view`, `cart_add`, `cart_update`, `cart_remove`, `cart_clear`.

## Outage behavior

If WooCommerce is unavailable:
- no cart mutation occurs;
- WF-12 returns a machine-readable blocked result;
- upstream WF-03 may preserve purchase intent and continue the KB sales conversation.

No KB data is used to fabricate cart state, stock, current price or availability.

## Status

Integration-ready scaffold. Wire the exact WF-20 v4/v3 workflow ID and verify n8n node schemas against the installed n8n version before production.
