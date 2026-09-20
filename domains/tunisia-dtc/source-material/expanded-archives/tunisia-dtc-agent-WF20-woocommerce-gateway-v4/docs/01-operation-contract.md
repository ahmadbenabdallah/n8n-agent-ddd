# Operation Contract

Allowed gateway operations:

### Product
- get_product
- get_products
- get_variation

### Order
- get_order
- create_cod_order
- update_order_status

### Coupon
- coupon_validate

### Cart / Store API
- cart_view
- cart_add
- cart_remove
- cart_update
- cart_clear

### Checkout / Transaction
- checkout_validate
- transaction_preflight

### Operations
- health

No caller may submit an arbitrary WooCommerce URL, WordPress route, HTTP method, credential, or REST resource name.
