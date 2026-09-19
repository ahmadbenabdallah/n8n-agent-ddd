# WF-11 Acceptance Matrix

| Scenario | Expected |
|---|---|
| Public product lookup | structured product result |
| Unknown product | PRODUCT_NOT_FOUND |
| Size 42 exists | exact variation resolved |
| Size 42 absent | VARIATION_NOT_FOUND |
| Current price requested | live WooCommerce price |
| Cached price only | revalidation required for consequential use |
| Live stock conflict with KB | WooCommerce wins |
| Arbitrary endpoint in request | rejected |
| Private metadata in response | stripped |
| Cart mutation request | routed through WF-10/WF-12 |
| WooCommerce timeout | structured COMMERCE_TIMEOUT |
| Human-owned case | no unauthorized mutation |
