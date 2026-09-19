# Deployment order
1. Configure n8n credentials/environment.
2. Import all 20 workflows.
3. Replace WF-01..WF-19 Execute Workflow IDs after import.
4. Apply database/supabase-schema.sql.
5. Connect OpenAI and Supabase.
6. Connect commerce APIs for WF-07 and WF-11..WF-15.
7. Configure Meta Messenger webhook to WF-00.
8. Configure audit and KB ingestion.
9. Run regression/security/language tests.
10. Activate only after provider-specific credentials and API contracts are verified.

These are starter/provider-neutral workflows. No fake commerce, payment, Meta, or shipping API parameters are included.
