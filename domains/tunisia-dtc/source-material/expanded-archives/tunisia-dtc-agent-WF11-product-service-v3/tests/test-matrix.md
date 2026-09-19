# WF-11 v3 Regression Matrix

| Case | Expected |
|---|---|
| WC connected + get_product | WooCommerce live facts |
| WC connected + search_products | WooCommerce product results |
| WC unavailable + get_product + KB context | KB informational result; live fields marked unavailable |
| WC unavailable + get_product without KB context | Safe fallback-required result; no invented facts |
| WC unavailable + availability_check | BLOCK/no KB availability claim |
| WC unavailable + cart operation | WF-12/WF-20 must block |
| WC unavailable + coupon validation | WF-13/WF-20 must block |
| Stale KB price | Never treat as current price |
