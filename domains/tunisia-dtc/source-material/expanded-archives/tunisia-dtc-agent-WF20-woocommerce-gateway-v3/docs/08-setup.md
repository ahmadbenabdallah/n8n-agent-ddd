# Setup

## Credentials
Create an n8n WooCommerce credential for the native WooCommerce nodes.

For fixed HTTP fallback nodes, configure an n8n credential for the WooCommerce REST API. Prefer a credential object over embedding secrets in expressions.

## Environment
Set:

`WOOCOMMERCE_BASE_URL=https://your-store.example`

Do not include `/wp-json/...` in the environment value.

## Store API cart
The Store API is session-based. Implement the customer→Cart-Token lookup inside WF-20 using a protected datastore.

## Native node verification
After importing:
1. Open each native WooCommerce node.
2. Select the configured WooCommerce credential.
3. Verify resource/operation fields against the installed n8n version.
4. Map the order JSON payload explicitly for COD.
5. Test in staging before activation.
