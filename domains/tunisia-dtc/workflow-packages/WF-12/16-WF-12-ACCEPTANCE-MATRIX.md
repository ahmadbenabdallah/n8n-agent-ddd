# WF-12 Acceptance Matrix

| Scenario | Expected |
|---|---|
| View cart | current normalized cart |
| Add valid variant | authorized mutation + verified result |
| Add unavailable variant | VARIATION_UNAVAILABLE |
| Unknown variation | VARIATION_NOT_FOUND |
| Invalid quantity | QUANTITY_INVALID |
| Unauthorized mutation | ACCESS_DENIED |
| Modified authorization parameters | AUTHORIZATION_INVALID |
| Duplicate event | no duplicate mutation |
| Cart changed concurrently | revalidation/re-authorization |
| Human-owned conversation | mutation blocked |
| WooCommerce timeout | reconciliation required |
| Cart token in response | security failure |
