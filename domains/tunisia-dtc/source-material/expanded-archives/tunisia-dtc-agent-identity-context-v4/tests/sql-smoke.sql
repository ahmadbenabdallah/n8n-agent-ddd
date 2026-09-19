select * from public.resolve_channel_identity('facebook','TEST_PSID_001','Test User');
select * from public.resolve_channel_identity('facebook','TEST_PSID_001','Test User');

select channel,external_user_id,count(*) mappings
from public.customer_identities
where channel='facebook' and external_user_id='TEST_PSID_001'
group by channel,external_user_id;

select public.upsert_conversation(
 (select customer_id from public.customer_identities
  where channel='facebook' and external_user_id='TEST_PSID_001' limit 1),
 'facebook','TEST_THREAD_001','TEST_TURN_001'
);

select * from public.conversation_context
where conversation_id in (
 select id from public.conversations
 where channel='facebook' and external_conversation_id='TEST_THREAD_001'
);
