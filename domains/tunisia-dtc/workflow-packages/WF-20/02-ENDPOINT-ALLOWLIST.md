# Endpoint & Operation Allowlist

WF-20 must use a static/configured operation registry.

Example:

| Operation | Method | Resource | Auth action |
|---|---|---|---|
| product_get | GET | products/{id} | product_lookup |
| product_search | GET | products | product_lookup |
| variation_get | GET | products/{id}/variations/{id} | product_lookup |
| order_get | GET | orders/{id} | order_status |
| order_create | POST | orders | checkout_confirm |
| customer_get | GET | customers/{id} | identity-scoped lookup |
| coupon_get | GET | coupons | promotion_validate |

The exact enabled set should be reviewed against the deployed WooCommerce integration.

Forbidden:
- arbitrary endpoint;
- arbitrary method;
- arbitrary host;
- arbitrary query parameters outside schema;
- arbitrary headers;
- credential selection from customer/LLM input;
- direct execution based only on natural-language text.

Reject unknown operation IDs.
