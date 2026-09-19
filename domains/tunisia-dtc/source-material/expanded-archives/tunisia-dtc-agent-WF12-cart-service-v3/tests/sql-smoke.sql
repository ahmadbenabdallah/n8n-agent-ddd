-- Run after migration in staging.
insert into public.customers(display_name) values ('WF12 Test') returning id;

-- Inspect mapping after WF-12 creates/updates a cart reference:
select customer_id,channel,store_id,cart_reference,status,last_validated_at,version
from public.wc_cart_sessions
order by created_at desc limit 10;
