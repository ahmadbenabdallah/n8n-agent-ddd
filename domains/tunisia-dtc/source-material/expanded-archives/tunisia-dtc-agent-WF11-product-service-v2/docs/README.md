# WF-11 Product Service v2

WF-11 is the product-domain service. WooCommerce is the transactional source of truth for mutable product facts.

## Responsibilities
- Read live product data through WF-20.
- Resolve product/variation facts needed by sales, cart and checkout.
- Return a minimized verified product contract.
- Keep the Knowledge Base separate from transactional truth.

## Supported operations
- `get_product`
- `get_products`
- `get_variation`
- `search_products`
- `availability_check`

WF-11 is read-only. It must not mutate products, prices or stock.

## Live authority
WooCommerce owns product ID, SKU, current price, sale price, stock status/quantity, purchasability and variation data.

The KB may describe features, usage, care, positioning and other non-transactional facts, but must not override live price/stock/purchasability.
