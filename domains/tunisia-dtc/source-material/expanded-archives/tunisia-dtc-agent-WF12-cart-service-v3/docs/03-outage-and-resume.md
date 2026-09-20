# Outage and Resume

### During outage

Customer:
`Nheb l'article hedha taille 42`

Allowed:
- continue KB-based sales conversation;
- save product/variant/quantity purchase intent in WF-03/Supabase;
- collect explicit customer details.

Blocked:
- add/update/remove/clear cart;
- claim current stock;
- claim current price;
- claim checkout readiness;
- create order.

### After recovery

1. WF-02 resolves returning identity.
2. WF-03 restores purchase intent.
3. WF-11/WF-20 validates the current product/variation.
4. WF-12 creates/updates the live WooCommerce cart.
5. WF-14 performs fresh checkout validation.
6. WF-15 performs final transaction authorization and creates the COD order.
