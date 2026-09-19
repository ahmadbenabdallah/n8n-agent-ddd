# WF-10 Order-Scope Authorization

WF-10 is the hard authorization boundary.

For `get_order`, validate:
1. authenticated internal request;
2. allowlisted action;
3. valid customer_id;
4. active channel/commerce relationship;
5. ACTIVE order scope;
6. requested order is explicitly inside scope;
7. requested fields are allowlisted;
8. human-ownership constraints;
9. abuse/rate controls;
10. correlation/idempotency context where required.

Example ALLOW:
```json
{
  "authorization_result": "ALLOW",
  "execution_allowed": true,
  "scope": {
    "order_id": "10582",
    "permissions": ["read_status","read_shipping"]
  },
  "allowed_fields": ["status","shipping_summary"]
}
```

Deny for missing, expired, revoked, conflicting, ambiguous, or unrelated scope.

The LLM cannot create, modify, extend, revoke, or interpret an order scope as authorization.
