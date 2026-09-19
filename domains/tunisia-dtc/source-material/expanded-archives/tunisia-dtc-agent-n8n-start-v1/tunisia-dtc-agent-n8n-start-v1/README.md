# Tunisia DTC Agent — n8n Start Package v1

All 20 starter workflows are included. Facebook Messenger Business Page is the concrete inbound channel in WF-00.

The workflows are intentionally provider-neutral beyond Messenger webhook normalization. You must configure Meta credentials, OpenAI, Supabase, and the commerce provider before production use.

Import all JSON files under workflows/, then reconnect Execute Workflow nodes to the actual imported workflow IDs. Apply database/supabase-schema.sql and configure environment variables from environment/.env.example.

The package preserves the system boundary: LLM proposes; n8n authorizes; commerce executes; post-action verification precedes success claims.
