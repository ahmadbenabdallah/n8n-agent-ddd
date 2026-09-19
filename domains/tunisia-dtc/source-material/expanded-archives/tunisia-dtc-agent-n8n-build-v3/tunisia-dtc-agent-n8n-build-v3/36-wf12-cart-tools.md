# WF-12 — Cart

## ADD_CART_ITEM

Flow:
`Validate SKU → Validate Variant → Check Current Inventory → Idempotency → Add → Re-read Cart → Verify → Event`

## UPDATE_CART_ITEM

Same validation pattern.

## REMOVE_CART_ITEM

Same authorization and cart ownership check.

## Rule

Never tell the customer an item was added until the commerce backend confirms it.
