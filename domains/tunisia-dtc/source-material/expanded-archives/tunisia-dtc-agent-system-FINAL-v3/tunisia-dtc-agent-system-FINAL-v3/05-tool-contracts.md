# Tool Contracts — Production v3

Tools are capabilities, not permissions. Authorization occurs before execution.

## Product
`product.search`, `product.get`
- read-only
- bounded fields
- authoritative live values for dynamic commerce facts

## Cart
`cart.view`, `cart.add`, `cart.update`, `cart.remove`, `cart.clear`
Required for mutations: verified session/customer scope, SKU/variant, quantity where relevant, action_id and idempotency_key.
Returns authoritative cart snapshot and correlation ID.

## Promotion
`promotion.validate`
Validates code/existence, active period, market, SKU/category restrictions, min subtotal, eligibility, usage limits and stacking. Use bounded WooCommerce API fallback when no native n8n resource exists.

## Checkout
`checkout.preflight`, `checkout.create`
Preflight validates cart, current prices, inventory, promotion and expected total. Checkout URL is backend-generated. Never construct URLs in the LLM.

## Order
`order.get`, `order.create`, `order.update`, `order.cancel`
Requires appropriate verified identity/order scope and authorization. Return minimum necessary fields.

## Transaction
`transaction.reconcile`
Handles post-write ambiguity and idempotent recovery. COD order creation is not payment.

## Success
A success claim requires a verified execution result. A timeout is not success and must trigger reconciliation.

## Forbidden
No arbitrary URL/endpoint, credential access, payment credential handling, hidden internal notes, fraud data, supplier data or unrelated customer data.
