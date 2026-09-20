# Wiring

1. Import `WF-13-promotion-service-v3.json`.
2. Replace `REPLACE_WITH_WF20_WORKFLOW_ID`.
3. Configure the same least-privilege Supabase/Postgres credential used by identity/context.
4. Route authorized promotion intents from WF-10 to WF-13.
5. Ensure WF-20 exposes the bounded promotion operation.
6. Ensure WF-20 evaluates against current WooCommerce state.
7. Ensure WF-14 performs a fresh promotion/cart/total validation.
8. Verify exact n8n node parameters against the installed n8n version before activation.
