# Exact Wiring Checklist

### Product question / pricing / availability

WF-04 intent
→ WF-11 Product Service
→ WF-20 get_product/get_products
→ verified result
→ WF-09 LLM
→ WF-16 Renderer

### Cart add

WF-04 cart_add
→ WF-05 Sales Engine
→ WF-10 Action Validator
→ WF-12 Cart Service
→ WF-20 get_product/get variation verification
→ agent cart persistence
→ WF-16

### Checkout

WF-04 checkout_start
→ WF-14 Checkout Service
→ final product/price/stock validation
→ prepare checkout contract

### COD confirmation

WF-04 checkout_confirm
→ WF-10
→ WF-14
→ WF-15
→ WF-20 create_cod_order
→ WF-20 get_order
→ verification
→ WF-12/State update
→ WF-16
→ WF-17

### External WooCommerce order changes

WooCommerce Trigger
→ WF-20B
→ audit/state synchronization
→ never bypass WF-10
