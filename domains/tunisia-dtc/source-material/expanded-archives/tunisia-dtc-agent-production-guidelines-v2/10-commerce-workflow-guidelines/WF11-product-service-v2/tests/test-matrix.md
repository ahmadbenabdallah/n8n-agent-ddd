# WF-11 Test Matrix

| Test | Expected |
|---|---|
| get_product valid ID | live WooCommerce product returned |
| unknown product | controlled not-found result |
| get_products bounded | <= 50 products |
| SKU lookup | matching SKU only |
| variable product | parent + variation IDs available |
| get_variation | live variation price/stock returned |
| out of stock | availability=false |
| backorder allowed | availability follows WooCommerce semantics; do not invent stock |
| draft/private product | not exposed to customer-facing sales flow |
| KB says 99 TND but WC says 109 TND | 109 TND wins |
| KB says in stock but WC says outofstock | unavailable |
| arbitrary endpoint in request | rejected |
| meta_data in WC response | removed from WF-11 output |
