# Known Limitations / Required Hardening

1. The exported workflow intentionally does not invent the store-specific customer/cart persistence schema.
2. `cart_token` fields shown in the workflow are placeholders for an internal WF-20 resolver; production should resolve them from protected storage rather than accepting raw tokens from callers.
3. Exact coupon eligibility can be complex. Applying/validating the coupon through the Store API against the current cart is stronger than merely reading `/wc/v3/coupons`.
4. Native WooCommerce node parameter names vary by n8n release; verify imported nodes in the UI.
5. Transaction idempotency remains enforced by WF-15's durable idempotency store.
6. Staging E2E tests are mandatory before production.
