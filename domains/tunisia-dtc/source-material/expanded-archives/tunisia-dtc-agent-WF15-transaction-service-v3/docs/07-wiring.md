# Wiring

1. Apply `003_commerce_idempotency.sql`.
2. Import WF-15 JSON.
3. Replace `REPLACE_WITH_WF20_WORKFLOW_ID`.
4. Route only authorized `create_cod_order` requests from WF-10.
5. Wire WF-20's `transaction_preflight` operation.
6. Wire WF-20's bounded `create_cod_order` operation.
7. Wire WF-20's `get_order` operation for post-create verification.
8. Ensure WF-20 reconciles the action ID before retrying creation.
9. WF-16 must render only the verified result.
10. Verify exact n8n node parameters against the installed n8n version.
