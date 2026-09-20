# Integration Map

## Existing workflows

- WF-10: authorization
- WF-11: product retrieval
- WF-12: cart state/mutations
- WF-14: checkout validation
- WF-15: transaction boundary
- WF-16: response rendering
- WF-17: audit

## WF-20 position

```text
WF-11 Product Service
       ↓
WF-20 get_product / get_variation
       ↓
verified WooCommerce facts

WF-12 Cart Service
       ↓
agent_carts
       ↓
WF-14 Checkout
       ↓
live WooCommerce product/stock/price validation
       ↓
WF-15 Transaction
       ↓
WF-20 create_cod_order
       ↓
WooCommerce
       ↓
WF-20 get_order verification
       ↓
WF-16 Renderer
```

WF-20 is an execution adapter, not an authorization engine.
