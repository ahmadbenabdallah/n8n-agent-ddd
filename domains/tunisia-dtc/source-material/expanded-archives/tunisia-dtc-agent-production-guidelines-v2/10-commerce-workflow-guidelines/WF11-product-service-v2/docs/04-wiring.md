# Wiring

1. Import WF-11.
2. Import WF-20.
3. Replace `REPLACE_WITH_WF20_WORKFLOW_ID` in the Execute Workflow node.
4. Ensure WF-20 exposes the mapped operations.
5. Test simple product, variable product, variation, out-of-stock and SKU lookup.
6. Only then connect WF-05 Sales, WF-12 Cart and WF-14 Checkout.

If the installed n8n version exposes different WooCommerce node fields, configure those fields inside WF-20. WF-11 should remain independent of WooCommerce credential details.
