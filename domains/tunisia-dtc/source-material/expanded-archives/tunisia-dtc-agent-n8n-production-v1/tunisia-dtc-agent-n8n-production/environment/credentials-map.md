# Credentials Map

| Secret | Used by | Store in |
|---|---|---|
| META_PAGE_ACCESS_TOKEN | WF-00 / outbound Messenger | n8n credential |
| META_APP_SECRET | Messenger webhook verification | n8n credential |
| OPENAI_API_KEY | WF-09 / WF-18 | n8n credential |
| SUPABASE_SERVICE_ROLE_KEY | state/audit/RAG | n8n credential |
| COMMERCE_API_KEY | WF-07/WF-11..WF-15 | n8n credential |

Never put credentials in prompts, Markdown KB, customer-visible output or JSON workflow parameters when n8n credentials can be used.
