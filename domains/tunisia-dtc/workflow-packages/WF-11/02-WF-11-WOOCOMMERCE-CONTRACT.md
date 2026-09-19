# WF-11 WooCommerce Contract

All WooCommerce access goes through WF-20.

Allowed bounded operations include:
- product lookup;
- product search;
- variation lookup;
- bounded availability/product-state lookup.

WF-11 must never construct arbitrary endpoints supplied by the LLM.

## Normalized product response

```json
{
  "product_id": "123",
  "name": "Product",
  "status": "publish",
  "type": "variable",
  "description": "...",
  "short_description": "...",
  "categories": [],
  "images": [],
  "currency": "TND",
  "price": {
    "current": "129.900",
    "currency": "TND",
    "source": "woocommerce",
    "observed_at": "..."
  },
  "stock": {
    "status": "instock",
    "quantity": null,
    "source": "woocommerce",
    "observed_at": "..."
  },
  "variations": [],
  "purchasable": true
}
```

Only minimum required fields should cross workflow boundaries.
Do not pass raw customer/private/admin metadata.
