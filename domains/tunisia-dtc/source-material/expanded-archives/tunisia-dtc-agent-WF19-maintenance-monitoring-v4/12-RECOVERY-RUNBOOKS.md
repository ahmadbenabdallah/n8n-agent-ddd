# Recovery Runbooks

## WooCommerce unavailable
1. confirm outage;
2. switch affected commerce capability to degraded/safe mode;
3. stop new consequential mutations if policy requires;
4. preserve incoming requests;
5. alert;
6. restore connectivity;
7. reconcile unknown executions;
8. resume only after health validation.

## Supabase degraded
1. confirm;
2. protect canonical state;
3. use durable queue/outbox where available;
4. avoid unsafe mutations;
5. restore;
6. reconcile;
7. validate.

## Messenger send outage
- queue outbound responses;
- do not replay commerce actions;
- retry delivery independently.

## OpenAI outage
- fail to deterministic safe responses where supported;
- do not invent business facts;
- do not bypass authorization.

## Security incident
- activate incident mode;
- preserve evidence;
- restrict automation;
- rotate credentials when required;
- remediate;
- validate controls;
- resume explicitly.
