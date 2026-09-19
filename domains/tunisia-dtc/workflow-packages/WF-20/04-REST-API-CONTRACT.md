# WooCommerce REST API Contract

Use the configured WooCommerce REST API version and approved resources.

Typical v3 resources include:
- products;
- product variations;
- orders;
- customers;
- coupons.

WF-20 should normalize raw API responses into internal typed objects.

Do not pass raw WooCommerce responses directly to the LLM or customer.

Normalize:
- product IDs;
- variation IDs;
- names;
- SKU where permitted;
- price;
- stock/purchasability;
- order status;
- payment status;
- line items;
- totals;
- coupon information.

Apply field allowlists per operation.

Never return:
- API credentials;
- authorization headers;
- internal secrets;
- unnecessary customer private fields;
- raw error traces.
