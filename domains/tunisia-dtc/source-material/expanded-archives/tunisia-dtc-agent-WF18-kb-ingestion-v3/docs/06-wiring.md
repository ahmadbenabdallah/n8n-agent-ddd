# Wiring

1. Apply `005_kb_ingestion.sql`.
2. Verify pgvector availability.
3. Import WF-18.
4. Configure least-privilege Supabase/Postgres credentials.
5. Define approved ingestion sources and admin approval.
6. Add the production embedding node/service and verify vector dimension.
7. Create the pgvector similarity index after embeddings are populated and tuned for the chosen distance/operator.
8. Connect retrieval to WF-09.
9. Emit ingestion/version/security events to WF-17.
10. Test poisoned/untrusted documents before enabling automatic ingestion.
