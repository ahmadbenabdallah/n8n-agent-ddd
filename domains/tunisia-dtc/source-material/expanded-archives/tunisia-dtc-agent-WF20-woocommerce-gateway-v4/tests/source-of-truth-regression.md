# Source-of-Truth Regression Tests

1. WC healthy + `get_product` → `commerce_status=connected`, `source_of_truth=woocommerce`.
2. WC healthy + `cart_view` → connected; proceeds to Store API.
3. WC unavailable + `get_product` → blocked at commerce gateway with `kb_fallback_allowed=true`; WF-11 may query KB.
4. WC unavailable + `get_products` → same informational fallback contract.
5. WC unavailable + `cart_add` → blocked; never reaches Store API mutation.
6. WC unavailable + `coupon_validate` → blocked; never authorizes discount from KB.
7. WC unavailable + `checkout_validate` → blocked.
8. WC unavailable + `create_cod_order` → blocked; no order creation.
9. WC unavailable + `get_order` → blocked; do not claim current order status.
10. WC unavailable + `transaction_preflight` → blocked.
11. WC healthy but stale KB price differs → WooCommerce value wins.
12. Customer-facing renderer never presents `kb_only` as live stock/order/payment truth.
