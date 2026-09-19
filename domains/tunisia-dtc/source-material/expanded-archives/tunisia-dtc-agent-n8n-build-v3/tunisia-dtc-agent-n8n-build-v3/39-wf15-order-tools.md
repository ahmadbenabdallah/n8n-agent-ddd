# WF-15 — Order Tools

## GET_VERIFIED_ORDER

Preconditions:
- customer identity verified;
- order belongs to authorized customer scope.

## Output minimization

```json
{
  "order_id": "ord_123",
  "status": "shipped",
  "items": [{"name":"Essential Hoodie","quantity":1}],
  "tracking": {"url":"https://authorized.example/track/123"}
}
```

Do not expose:
- payment credentials;
- internal notes;
- fraud scores;
- internal supplier data;
- unrelated customer information.
