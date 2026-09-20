# Wiring Runbook

1. Run `database/001_identity_context.sql` in staging Supabase.
2. Attach a least-privilege server-side Postgres credential to both workflows.
3. Import both n8n JSON files.
4. Verify the Postgres node fields against the installed n8n version.
5. Wire inbound Messenger -> WF-02 -> WF-03 -> existing intent/retrieval/reasoning pipeline.
6. Ensure `external_user_id` is the trusted Meta sender identifier; never use a customer-supplied ID.
7. Ensure `turn_id` is stable for webhook idempotency.
8. Pass verified WF-03 context to the orchestrator as state, not as instructions.
9. Keep WF-10 as the authorization boundary and WF-20 as the only privileged WooCommerce boundary.

Do not put Supabase service-role credentials, WooCommerce secrets, Cart-Tokens, nonce tokens, or payment credentials into LLM/customer-visible context.
