# WF-20 — WooCommerce Commerce Adapter v1

## Purpose

WF-20 is the controlled commerce boundary between the existing n8n agent workflows and WooCommerce.

Target deployment:

- Commerce: WooCommerce
- Payment: Cash on Delivery (COD)
- Shipping: manual initially
- Orchestration: self-hosted n8n
- First channel: Meta Messenger

Core boundary:

`LLM proposes → WF-10 authorizes → commerce adapter executes → adapter verifies/normalizes → WF-16 renders`

## Important limitation

This package is intentionally honest about one WooCommerce architectural gap:

**WooCommerce's authenticated REST API is suitable for products and orders, but it is not a drop-in server-side customer cart API for an arbitrary n8n agent session.**

Therefore v1 does NOT pretend that a generic WooCommerce REST call is a cart. The agent-side cart is kept in the agent database, and COD order creation is performed against WooCommerce after final validation.

A future dedicated server-side cart endpoint can be enabled through the included WordPress plugin contract, but it is fail-closed until authentication and implementation are explicitly configured.

## Supported operations

- `get_product`
- `get_variation`
- `list_products`
- `get_order`
- `create_cod_order`
- `health`

Not supported in v1:

- arbitrary WooCommerce endpoints
- refunds
- cancellations
- customer deletion
- product writes
- coupon writes
- shipping automation
- payment capture
- card/payment credentials
- unrestricted metadata access

## n8n credential

Create an n8n HTTP Basic Auth credential:

- Name: `WooCommerce REST API`
- Username: WooCommerce consumer key
- Password: WooCommerce consumer secret

Do not place keys in workflow JSON.

## Environment variables

Required:

`WOOCOMMERCE_BASE_URL=https://shop.example.tn`

Optional:

`WOOCOMMERCE_COD_PAYMENT_METHOD=cod`
`WOOCOMMERCE_COD_PAYMENT_TITLE=Cash on Delivery`
`WOOCOMMERCE_INITIAL_COD_STATUS=processing`

The store's actual COD gateway ID/status behavior must be tested in staging before production.

## WooCommerce requirements

The WooCommerce REST API is currently documented under `/wp-json/wc/v3/...`. HTTPS and pretty permalinks are required/recommended by WooCommerce documentation.

Create a REST API key with the minimum write access required for the integration. For v1, order creation requires write access; product/order reads require read access.

## Installation

1. Import `n8n/WF-20-woocommerce-commerce-adapter-v1.json`.
2. Open every Woo HTTP Request node.
3. Select the credential named `WooCommerce REST API`.
4. Set `WOOCOMMERCE_BASE_URL`.
5. Configure the WooCommerce COD gateway and confirm its payment method ID.
6. Apply `database/commerce-adapter.sql` to the agent database.
7. Do not activate the workflow until staging tests pass.
8. Connect WF-12/WF-14/WF-15 only through the explicit operation contract.
9. Keep WF-10 as the authorization boundary. WF-20 must never decide whether an action is permitted.

## Request contract

Example product lookup:

```json
{
  "operation": "get_product",
  "id": 123,
  "correlation_id": "..."
}
```

Example variation:

```json
{
  "operation": "get_variation",
  "product_id": 123,
  "id": 456
}
```

Example COD order:

```json
{
  "operation": "create_cod_order",
  "idempotency_key": "msg_123:create_cod_order",
  "channel": "messenger",
  "conversation_id": "messenger_psid_...",
  "billing": {
    "first_name": "Ahmed",
    "last_name": "Customer",
    "phone": "+216...",
    "address_1": "verified customer address",
    "city": "Tunis",
    "country": "TN"
  },
  "shipping": {
    "first_name": "Ahmed",
    "last_name": "Customer",
    "phone": "+216...",
    "address_1": "verified customer address",
    "city": "Tunis",
    "country": "TN"
  },
  "line_items": [
    {"product_id":123,"variation_id":456,"quantity":1}
  ]
}
```

Never accept PAN, CVV, OTP, PIN or passwords.

## Order semantics

`set_paid=false` is intentional for COD.

The adapter must never translate order creation into "payment successful".

A successful WooCommerce response proves an order resource was created. It does not prove that cash was collected.

## Verification

After order creation:

1. Verify the response contains a valid WooCommerce order ID/number.
2. Retrieve the order again using `get_order`.
3. Confirm owner/contact and line-item scope against the request.
4. Confirm total/currency/payment method.
5. Only then expose a success event to the renderer.
6. Record the idempotency key and external order ID.

If verification fails or times out, return `awaiting_verification` rather than success.

## Error model

Never expose raw WooCommerce errors to the customer.

Map:

- 401/403 → `WOOCOMMERCE_AUTHORIZATION_ERROR`
- 404 → `WOOCOMMERCE_NOT_FOUND`
- 5xx → `WOOCOMMERCE_SERVER_ERROR`
- other failures → `WOOCOMMERCE_API_ERROR`

The customer gets only a safe message plus a correlation ID when useful.

## Security

WF-20 assumes WF-10 already authorized the operation.

WF-20 must not:

- accept an LLM instruction as authorization
- accept customer text as permission
- expose WooCommerce credentials
- expose internal metadata
- return unrestricted order fields
- construct arbitrary URLs from customer input
- follow customer-supplied URLs
- log secrets or payment credentials

## Current cart decision

For v1:

`WF-12 Cart Service → agent_carts`

Then:

`WF-14 Checkout → snapshot + live Woo product validation`

Then:

`WF-15 Transaction → create COD order`

This is safer than pretending WooCommerce REST API itself is a universal server-side cart.

## Sources

WooCommerce currently documents the WC REST API as the authenticated API for store data and distinguishes it from the unauthenticated Store API used for customer-facing cart/checkout/product functionality.

Official docs:
- https://developer.woocommerce.com/docs/apis/
- https://developer.woocommerce.com/docs/apis/rest-api/
- https://developer.woocommerce.com/docs/apis/rest-api/v3/products
- https://developer.woocommerce.com/docs/apis/rest-api/v3/orders
