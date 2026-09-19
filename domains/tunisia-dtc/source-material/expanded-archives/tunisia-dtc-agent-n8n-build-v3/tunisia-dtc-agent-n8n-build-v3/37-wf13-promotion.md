# WF-13 — Promotion Validator

## Input

```json
{
  "customer_id": "cust_123",
  "cart_id": "cart_123",
  "code": "PROMO10"
}
```

## Validation

- promotion exists;
- active date;
- market;
- eligible SKU/category;
- minimum subtotal;
- customer eligibility;
- usage limit;
- stacking rules.

## Output

```json
{
  "eligible": true,
  "promotion_id": "promo_001",
  "discount": {"type":"percentage","value":10},
  "final_cart_total": 189
}
```

The LLM only communicates the validated result.
