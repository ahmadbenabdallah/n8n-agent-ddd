# WF-10 Authorization Binding

WF-20 must require a valid authorization envelope.

Minimum:

```json
{
  "authorization_id": "auth_123",
  "request_id": "req_123",
  "conversation_id": "conv_123",
  "action_id": "act_123",
  "action_type": "checkout_confirm",
  "normalized_params_hash": "sha256:...",
  "identity_context_hash": "sha256:...",
  "order_scope_ref": "scope_123",
  "policy_version": "v4",
  "state_version": 42,
  "idempotency_key": "idem_123",
  "expires_at": "2026-09-17T03:00:00Z"
}
```

WF-20 verifies:
1. authorization exists;
2. not expired;
3. action matches;
4. parameters hash matches;
5. conversation/request/action match;
6. state version is acceptable;
7. order scope is valid where required;
8. ownership mode permits operation;
9. idempotency key is valid.

WF-20 must not create or modify authorization records.

If authorization is missing/invalid:
`AUTHORIZATION_REQUIRED`.
