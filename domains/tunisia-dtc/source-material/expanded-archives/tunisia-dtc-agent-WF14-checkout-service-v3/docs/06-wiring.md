# Wiring

1. Import `WF-14-checkout-service-v3.json`.
2. Replace `REPLACE_WITH_WF20_WORKFLOW_ID`.
3. Configure least-privilege Postgres credentials if used by upstream context.
4. Route checkout intents through WF-10.
5. WF-14 calls WF-20 `checkout_validate`.
6. WF-20 resolves the protected WooCommerce cart session.
7. Ensure WF-20 validates live product, variation, stock, price, coupon and checkout total.
8. WF-16 renders only the verified snapshot.
9. After explicit confirmation, WF-15 performs its own fresh preflight before order creation.
10. Verify exact n8n node parameter schemas against the installed n8n version before production.
