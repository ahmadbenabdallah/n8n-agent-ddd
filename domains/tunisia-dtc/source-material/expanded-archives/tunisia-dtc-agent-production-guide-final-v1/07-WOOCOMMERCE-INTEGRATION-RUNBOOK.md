# WooCommerce Production Integration

## WF-20 privileged boundary

WF-20 is the only component allowed to use WooCommerce credentials.

### Native n8n WooCommerce node

Use native operations for supported Product and Order operations when they satisfy the required contract.

### HTTP Request fallback

Use a bounded HTTP fallback for:
- coupon validation where native resource support is insufficient
- Store API cart operations
- checkout validation
- other explicitly approved gateway operations

Do not permit arbitrary URL/path/method input from the LLM.

## Allowed operation list

Product:
- get_product
- get_products
- get_variation

Order:
- get_order
- create_cod_order
- update_order_status

Coupon:
- coupon_validate

Cart:
- cart_view
- cart_add
- cart_remove
- cart_update
- cart_clear

Checkout/transaction:
- checkout_validate
- transaction_preflight

Operations:
- health

## Cart tokens

Cart-Token is an internal credential-like artifact.

- Never put it in prompts.
- Never return it to Messenger.
- Never log it.
- Never let a caller supply an arbitrary token.
- Resolve the cart through the protected `wc_cart_sessions` mapping.

## Coupon policy

Coupon validation must check current WooCommerce restrictions, including applicable product/category/customer/usage/expiry/minimum-order rules as configured by the store.

A KB promotion description may explain a promotion but cannot authorize a discount.

## Checkout

Checkout validation must verify current:
- cart
- stock
- prices
- coupon applicability
- shipping/checkout constraints
- currency
- total
- COD availability
- customer/order fields

WF-15 repeats critical validation immediately before order creation.

## Order creation

Order creation must be bounded to COD.

Post-create:
1. capture order ID
2. GET the order
3. verify customer/order scope
4. verify line items
5. verify total/currency
6. verify COD payment method
7. verify payment is not incorrectly reported as paid
8. persist idempotency result

## WooCommerce outage

No mutation. Preserve intent and resume later.
