# Tool Contracts

## Principle

Tools are capabilities, not permissions.

Authorization happens before execution.

## Product tools

### search_products

Input:
- query
- category
- filters
- market

Output:
- product_id
- SKU
- verified attributes
- current price if supplied by authoritative pricing service
- availability if supplied by authoritative inventory service

### get_product

Returns canonical verified product facts.

## Cart tools

### add_to_cart

Requires:
- customer/session identity
- SKU
- variant
- quantity
- idempotency_key

Must validate current inventory and return authoritative cart state.

### get_cart

Returns current cart state.

### remove_from_cart

Requires authorized session and idempotency.

## Promotion tools

### validate_promotion

Checks:
- code/promotion existence
- active period
- market
- SKU/category eligibility
- minimum subtotal
- customer eligibility
- usage limits
- stacking

### apply_promotion

Only after validation.

## Checkout

### create_checkout

Must revalidate:
- cart
- price
- inventory
- promotion

Returns a backend-generated checkout URL.

The agent must never construct a checkout URL.

## Order tools

### get_order

Requires verified identity/order scope.

Return only minimum necessary fields.

Never return:
- payment credentials
- internal notes
- fraud scores
- supplier data
- unrelated customer records

### cancel_order / update_order

Only when explicitly supported by business rules and authorized identity. Use idempotency and post-action verification.

## Tool result rule

The agent may claim an action succeeded only when the tool response confirms success.

## Error handling

Tools must return machine-readable:
- success/failure
- error code
- safe customer-facing message where appropriate
- correlation ID
- action ID where relevant

Do not expose raw internal errors.
