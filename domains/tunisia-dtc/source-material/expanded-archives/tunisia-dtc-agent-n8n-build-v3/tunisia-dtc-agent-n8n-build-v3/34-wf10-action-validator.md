# WF-10 — Action Validator

## This is the critical control plane.

## Nodes

1. `INPUT — LLM Output`
2. `CODE/JSON — Schema Validate`
3. `SWITCH — Action Allowlist`
4. `CODE — Parameter Validate`
5. `IF — Security Restricted`
6. `IF — Identity Permission`
7. `EXECUTE — Business Rule`
8. `DB — Idempotency`
9. `EXECUTE — Tool`
10. `EXECUTE — Post-Action Verification`
11. `DB — Audit`

## Example

LLM proposes:

```json
{
  "type": "ADD_CART_ITEM",
  "parameters": {
    "sku": "HOOD-001",
    "quantity": 1
  }
}
```

Validator verifies:
- action is allowed;
- SKU exists;
- variant is valid;
- customer/session may modify this cart;
- quantity is valid;
- inventory is current;
- idempotency key is new.

Only then does the cart tool execute.

## Denied action

Return:

```json
{
  "executed": false,
  "reason": "ACTION_NOT_AUTHORIZED"
}
```

Never ask the LLM to decide whether its own action should be allowed.
