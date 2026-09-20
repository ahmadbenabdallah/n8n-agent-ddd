# Setup — Step by Step

## A. WooCommerce

1. Use staging first.
2. Confirm WooCommerce REST API access.
3. Create a dedicated WooCommerce API credential for n8n.
4. Use least privilege required by your chosen operations.
5. Confirm the COD gateway is enabled.
6. Confirm the actual payment method ID shown by the store; do not blindly assume it is `cod`.
7. Create test simple and variable products.
8. Enable stock management on test products.
9. Confirm order status produced by COD.
10. Confirm HTTPS.

## B. n8n

1. Import `WF-20-woocommerce-native-adapter-v2.json`.
2. Create the WooCommerce credential in n8n.
3. Select that credential on every native WooCommerce node.
4. Verify the node parameter names against your installed n8n version. n8n node schemas can evolve; the UI is authoritative for the exact field labels.
5. Set:
   `WOOCOMMERCE_COD_PAYMENT_TITLE`
   `WOOCOMMERCE_INITIAL_COD_STATUS`
6. Import the trigger workflow separately.
7. Keep both inactive until staging tests pass.

## C. Database

Apply:
`database/commerce-idempotency.sql`

## D. Wiring

WF-11 → WF-20 product operations
WF-12 → agent cart storage
WF-14 → final validation
WF-15 → WF-20 create_cod_order
WF-20 → get_order verification
WF-16 → customer response
WF-17 → audit
