# Tool & Action Contracts

## Principle

Every tool is allowlisted, narrowly scoped, authenticated and validated
by n8n.

## Read tools

### search_products

Input:

``` json
{"query":"string","filters":{},"limit":5}
```

### get_product

``` json
{"product_id":"string"}
```

### check_variant_availability

``` json
{"sku":"string","variant_id":"string"}
```

### get_shipping_quote

``` json
{"country":"TN","postal_code":"string","items":[]}
```

### get_order

Only after identity verification:

``` json
{"order_id":"string","customer_id":"verified-id"}
```

### search_kb

``` json
{"query":"string","topic":"product|policy|faq|sales","market":"TN","language":"fr-TN"}
```

## Controlled write tools

### create_cart

### add_cart_item

### update_cart_item

### remove_cart_item

### create_checkout

Each must have: - authentication; - authorization; - schema
validation; - idempotency key; - audit event; - timeout; - retry policy.

## Restricted tools

Refund, cancellation, address changes, payment operations and policy
exceptions require explicit policy + authorization. If unavailable,
escalate.

## Never expose

-   API keys;
-   internal endpoint URLs;
-   credentials;
-   database connection strings;
-   internal node IDs;
-   raw tool errors containing secrets.

## Action allowlist

``` json
{
  "allowed_actions": [
    "SEARCH_PRODUCTS",
    "GET_PRODUCT",
    "CHECK_AVAILABILITY",
    "SEARCH_KB",
    "GET_SHIPPING_QUOTE",
    "GET_VERIFIED_ORDER",
    "CREATE_CART",
    "ADD_CART_ITEM",
    "UPDATE_CART_ITEM",
    "REMOVE_CART_ITEM",
    "CREATE_CHECKOUT",
    "ESCALATE"
  ]
}
```
