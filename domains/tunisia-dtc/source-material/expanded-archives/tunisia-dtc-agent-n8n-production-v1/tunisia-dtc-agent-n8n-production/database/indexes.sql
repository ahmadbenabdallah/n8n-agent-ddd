create index if not exists conversations_channel_user_idx
on conversations(channel, channel_user_id);

create index if not exists messages_conversation_created_idx
on conversation_messages(conversation_id, created_at desc);

create index if not exists agent_events_conversation_created_idx
on agent_events(conversation_id, created_at desc);

create index if not exists idempotency_expires_idx
on idempotency_keys(expires_at);
