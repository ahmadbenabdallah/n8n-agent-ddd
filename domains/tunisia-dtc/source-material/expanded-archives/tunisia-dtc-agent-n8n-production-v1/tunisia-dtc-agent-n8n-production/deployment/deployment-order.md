# Production Deployment Order

1. Import the 20 workflow JSON files.
2. In n8n, reconnect each Execute Workflow node to the actual imported workflow ID.
3. Configure Meta/Facebook Page webhook and page access credentials.
4. Apply database/schema.sql, functions.sql, indexes.sql and rls.sql.
5. Connect OpenAI.
6. Connect Supabase and vector KB.
7. Connect the actual commerce provider.
8. Configure audit persistence.
9. Run deployment/testing.md.
10. Run security/red-team-tests.md.
11. Only then activate the inbound workflow.
