# Native n8n WooCommerce vs HTTP

## Native node
Use the native n8n WooCommerce node for supported Product and Order resources.

This keeps credentials and standard CRUD operations inside n8n's WooCommerce integration.

## HTTP Request
Use a credentialed, explicitly configured HTTP Request only where the native node does not cover the required contract:
- WooCommerce REST coupon lookup
- WooCommerce Store API cart
- WooCommerce Store API checkout
- health probe

The HTTP nodes must use fixed URLs built from `WOOCOMMERCE_BASE_URL`. The incoming request can never control the URL or path.

After import, verify the exact native WooCommerce node fields against the installed n8n version; n8n versions can change node UI parameter names.
