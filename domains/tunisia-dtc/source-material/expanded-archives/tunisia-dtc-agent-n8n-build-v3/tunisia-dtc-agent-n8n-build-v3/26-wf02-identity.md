# WF-02 — Identity

## Goal
Determine the customer's authorization scope before sensitive retrieval.

## Nodes

1. `INPUT`
2. `DB — Channel Customer Lookup`
3. `SWITCH — Verification Level`
4. `IF — Sensitive Intent`
5. `EXECUTE — Verification`
6. `SET — Authorized Scope`

## Levels

- `anonymous`
- `channel_linked`
- `order_verified`
- `high_assurance`

## Output

```json
{
  "customer_id": "cust_123",
  "verification_level": "order_verified",
  "authorized_scope": {
    "customer_id": "cust_123",
    "order_ids": ["ord_456"]
  }
}
```

The LLM cannot alter this object.
