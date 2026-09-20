# WF-20 Contract

## get_product

```json
{"operation":"get_product","id":123}
```

Returns minimum verified product fields:
id, sku, name, type, price, regular/sale price, stock state, purchasable, variations.

## get_products

```json
{"operation":"get_products","search":"shoe"}
```

Used for bounded product retrieval only. WF-11 controls retrieval scope.

## create_cod_order

```json
{
 "operation":"create_cod_order",
 "idempotency_key":"...",
 "billing":{"first_name":"...","phone":"+216...","country":"TN"},
 "shipping":{"first_name":"...","phone":"+216...","country":"TN"},
 "line_items":[{"product_id":123,"variation_id":456,"quantity":1}]
}
```

The adapter forces COD semantics and refuses a paid flag.

## get_order

```json
{"operation":"get_order","id":123}
```

Minimum fields only.

## update_order_status

Supported only if WF-10 explicitly authorizes it and business policy allows it. It is not part of the initial Messenger sales path.

## health

Read-only operational check. It does not authorize commerce.
