begin; select plan(1); select has_trigger('public','audit_events','audit_events_immutable','audit table has immutability trigger'); select * from finish(); rollback;
