# WF-20 WooCommerce Gateway — Full Implementation

## Purpose
WF-20 is the only privileged boundary allowed to communicate with WooCommerce for commerce execution.

## Operation allowlist

Examples:
- GET_PRODUCT
- GET_PRODUCTS
- GET_ORDER
- CREATE_ORDER
- UPDATE_ORDER
- GET_CUSTOMER
- VALIDATE_COUPON
- CART_OPERATION
- CHECKOUT_OPERATION

The exact operation set must be explicitly mapped. No caller may submit arbitrary:
- URL;
- HTTP method;
- headers;
- credentials;
- query parameters;
- endpoint paths.

## REST API

Use authenticated WooCommerce REST API v3 for server-side store data where appropriate.

## Store API

Use the Store API only through bounded, predefined cart/checkout operations. Cart tokens and nonces are infrastructure secrets and must never enter LLM/customer context.

## CREATE_ORDER

Before execution:
- authorization present;
- customer scope valid;
- line items normalized;
- price not supplied as an authority by LLM;
- current product data fetched;
- stock validated;
- totals calculated by commerce;
- promotion validated;
- idempotency key present.

After execution:
- verify returned order;
- verify expected line items;
- verify status;
- verify totals;
- record execution outcome.

## COD

For COD:
- order may be created;
- payment status is `not_paid` until actual payment occurs;
- do not tell customer that payment was completed merely because an order was created.

## Timeout

A timeout after a mutation is not automatically a failure.

State:
`EXECUTION_UNKNOWN`

Then reconcile by idempotency key/order reference before retrying.

## Security

Reject any attempt to:
- override price;
- invent discount;
- select arbitrary endpoint;
- use arbitrary HTTP method;
- access another customer's order;
- expose credentials;
- bypass WF-10.
