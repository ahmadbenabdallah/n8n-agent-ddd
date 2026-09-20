# WF-20 Required Operations

WF-20 should expose these bounded operations for WF-15:

- `transaction_preflight`
- `create_cod_order`
- `get_order`

`create_cod_order` must use the native n8n WooCommerce Order node where its supported fields cover the required payload. Any unsupported operation may use a narrowly scoped authenticated HTTP fallback inside WF-20.

WF-15 must never receive WooCommerce credentials.
