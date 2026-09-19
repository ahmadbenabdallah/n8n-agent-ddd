# Parameter Validation

Every operation has a strict schema.

Examples:

## Product lookup
Allowed:
- product_id;
- SKU/search query according to operation schema.

## Variation
Allowed:
- product_id;
- variation_id.

## Order creation
Only fields explicitly authorized by WF-10/WF-14:
- approved line items;
- verified customer/order context;
- shipping/billing fields according to policy;
- payment method;
- approved metadata.

Never accept:
- arbitrary WooCommerce status;
- arbitrary `set_paid=true`;
- arbitrary price override;
- arbitrary discount;
- arbitrary tax override;
- arbitrary endpoint;
- arbitrary metadata containing secrets.

## Numeric fields

Do not let LLM-provided numeric values become authoritative totals.

Final price/total comes from WooCommerce.
