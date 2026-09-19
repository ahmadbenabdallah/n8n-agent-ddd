# WF-14 Acceptance Matrix

| Scenario | Expected |
|---|---|
| Valid COD checkout | order created + verified, payment not_paid |
| Missing checkout field | CHECKOUT_FIELDS_REQUIRED |
| Stale price | PRICE_CHANGED / revalidation |
| Stock becomes unavailable | OUT_OF_STOCK |
| Coupon expires | PROMOTION_INVALID |
| Shipping unavailable | SHIPPING_UNAVAILABLE |
| Invalid authorization | AUTHORIZATION_INVALID |
| Human-owned conversation | HUMAN_REQUIRED |
| Duplicate checkout | no duplicate order |
| WooCommerce timeout | UNKNOWN_EXECUTION → reconciliation |
| Payment claim after COD order | payment remains not_paid |
| LLM-supplied final total | ignored |
