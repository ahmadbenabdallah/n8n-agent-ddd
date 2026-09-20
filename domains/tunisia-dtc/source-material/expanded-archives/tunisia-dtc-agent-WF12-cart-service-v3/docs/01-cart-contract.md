# Cart Contract

### cart_add
Required:
- customer_id
- channel
- product_id or variation_id or SKU
- quantity 1..99
- idempotency key

WF-20/WooCommerce must validate current product/variation, purchasability, stock and current cart state before mutation.

### cart_update
Same validation as add. Quantity 0 should be represented by `cart_remove`, not an ambiguous update.

### cart_remove
Requires a bounded product/variation/SKU reference. Verify post-removal cart.

### cart_clear
Requires authenticated customer context and application authorization. Verify the cart is empty after execution.

### cart_view
Read current WooCommerce cart and return verified state.

A success response is valid only if WooCommerce confirms the resulting state.
