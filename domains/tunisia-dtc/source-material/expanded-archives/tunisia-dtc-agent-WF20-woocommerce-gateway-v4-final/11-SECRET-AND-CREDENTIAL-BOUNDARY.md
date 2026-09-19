# Credential & Secret Boundary

WooCommerce credentials are WF-20-only secrets.

They must:
- live in n8n credential storage or an approved secret manager;
- never be included in workflow input;
- never be stored in Supabase business state;
- never enter LLM context;
- never enter audit metadata;
- never enter Messenger payloads.

Credential rotation:
1. provision new credential;
2. validate read-only connectivity;
3. validate required operation set;
4. switch;
5. monitor;
6. revoke old credential.

Health checks should reveal only safe status, not credential material.
