# WooCommerce Setup

1. Use a staging WooCommerce site first.
2. Confirm WordPress/WooCommerce REST API availability.
3. Use HTTPS.
4. Ensure pretty permalinks are enabled.
5. Create a dedicated WooCommerce REST API key for the agent integration.
6. Give it only the permissions required by the chosen operations.
7. Store the consumer key/secret only in the n8n credential store.
8. Confirm the COD payment gateway ID. Commonly it is `cod`, but verify the actual store configuration.
9. Confirm what WooCommerce order status is created by COD in this store.
10. Create one staging product with:
   - simple product
   - variable product
   - at least one variation
   - stock management enabled
11. Run all tests before connecting Messenger.

Do not assume plugin-specific behavior is identical across WooCommerce installations.
