# WF-12 Cart Action Contracts

## cart_view
Input: conversation/cart context.
Output: normalized current cart.

## cart_add
Required:
- product_id;
- variation_id when required;
- quantity;
- authorization_id;
- idempotency_key.

Rules:
- quantity must be positive and within configured limits;
- product/variation must be purchasable;
- current required product facts must be verified;
- no silent substitution.

## cart_update
Required:
- cart line identifier or canonical product/variation reference;
- target quantity;
- authorization_id;
- idempotency_key.

## cart_remove
Required:
- canonical cart line/product reference;
- authorization_id;
- idempotency_key.

## cart_clear
Requires explicit authorized action and idempotency.

Never accept arbitrary HTTP methods, URLs, headers or WooCommerce credentials.
