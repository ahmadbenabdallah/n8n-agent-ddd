-- Enable RLS. Service-role operations from n8n can bypass RLS;
-- do not expose service-role keys to the client or LLM.
alter table conversations enable row level security;
alter table conversation_messages enable row level security;
alter table agent_events enable row level security;
alter table idempotency_keys enable row level security;

-- Intentionally no public policies are created here.
-- Add narrowly scoped policies only if browser/client access is required.
