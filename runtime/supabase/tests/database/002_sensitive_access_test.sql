begin; select plan(4);
select ok((select has_table_privilege('anon','public.transactions','select') is false),'anon cannot read transactions');
select ok((select has_table_privilege('authenticated','public.transactions','select') is false),'authenticated cannot read transactions');
select ok((select has_table_privilege('anon','public.authorizations','select') is false),'anon cannot read authorizations');
select ok((select has_table_privilege('authenticated','public.execution_operations','select') is false),'authenticated cannot read execution state');
select * from finish(); rollback;
