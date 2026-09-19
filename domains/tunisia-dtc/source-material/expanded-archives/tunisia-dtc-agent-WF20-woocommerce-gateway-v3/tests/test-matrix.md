# WF-20 Regression Matrix

| Test | Expected |
|---|---|
| get_product | native WooCommerce result normalized |
| get_products | bounded list |
| get_variation | live variation result |
| get_order | authorized order result |
| create COD order | order created, not paid |
| update status | only allowed status transitions |
| coupon code lookup | bounded coupon result |
| invalid coupon | safe ineligible result |
| cart view | current cart for mapped Cart-Token |
| cart add | current cart returned |
| cart remove | current cart returned |
| cart update | current cart returned |
| cart clear | empty cart returned |
| checkout validation | current checkout/cart state |
| transaction preflight | fresh live state |
| arbitrary URL | rejected |
| raw Cart-Token supplied by caller | rejected/ignored |
| Basic Auth in input | rejected |
| set_paid=true on COD | semantic guard fails |
| unknown operation | rejected |
| upstream 4xx | safe structured failure |
| upstream timeout | safe structured failure |
| raw meta_data | not exposed by normalized contract |
