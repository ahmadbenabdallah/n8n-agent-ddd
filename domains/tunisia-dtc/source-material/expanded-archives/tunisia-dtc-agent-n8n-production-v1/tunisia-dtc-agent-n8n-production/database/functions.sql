-- Helper functions. Keep authorization in the application/n8n layer.
create or replace function touch_conversation(p_conversation_id text)
returns void language sql as $$
  update conversations set updated_at=now() where conversation_id=p_conversation_id;
$$;

create or replace function record_agent_event(
  p_conversation_id text, p_message_id text, p_event_type text, p_payload jsonb
) returns bigint language sql as $$
  insert into agent_events(conversation_id,message_id,event_type,payload)
  values(p_conversation_id,p_message_id,p_event_type,coalesce(p_payload,'{}'::jsonb))
  returning id;
$$;
