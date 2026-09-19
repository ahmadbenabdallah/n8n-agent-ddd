# WF-11 — Product Tools

## SEARCH_PRODUCTS

Input:
```json
{
  "query": "hoodie léger",
  "filters": {
    "market": "TN",
    "category": "hoodie",
    "size": "M"
  },
  "limit": 5
}
```

Output:
```json
{
  "products": [
    {
      "product_id": "p001",
      "sku": "SKU001",
      "name": "Essential Hoodie",
      "price": {"amount": 79, "currency": "TND"},
      "facts": ["80% cotton", "medium weight"],
      "variant_availability": true
    }
  ]
}
```

Only return fields safe for the agent's authorization scope.
