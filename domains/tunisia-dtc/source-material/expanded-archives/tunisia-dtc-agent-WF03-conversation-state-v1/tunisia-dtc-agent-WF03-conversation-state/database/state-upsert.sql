-- Example Supabase upsert target
insert into conversations(conversation_id,channel,channel_user_id,page_id,state,updated_at)
values($1,$2,$3,$4,$5::jsonb,now())
on conflict(conversation_id) do update set
  channel=excluded.channel,
  channel_user_id=excluded.channel_user_id,
  page_id=excluded.page_id,
  state=excluded.state,
  updated_at=now();
