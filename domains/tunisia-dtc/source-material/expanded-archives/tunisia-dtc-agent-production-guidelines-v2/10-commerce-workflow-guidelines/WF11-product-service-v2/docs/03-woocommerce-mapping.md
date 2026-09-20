# WooCommerce Mapping

WF-11 delegates to WF-20.

| WF-11 operation | WF-20 operation |
|---|---|
| get_product | get_product |
| get_products | get_products |
| search_products | get_products |
| get_variation | get_variation |
| availability_check | get_product |

WooCommerce REST API v3 supports product and product-variation resources. Product responses expose current `price`, `sale_price`, `purchasable`, `stock_quantity`, `stock_status`, `backorders_allowed`, SKU and variations.

Do not use a cached KB price or stock value for transaction decisions.
