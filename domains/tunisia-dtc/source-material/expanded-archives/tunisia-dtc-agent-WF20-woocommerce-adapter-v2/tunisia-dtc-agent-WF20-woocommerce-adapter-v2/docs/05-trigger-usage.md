# WooCommerce Trigger Usage

The trigger workflow is asynchronous and observational.

Events available in n8n include:
- coupon.created/deleted/updated
- customer.created/deleted/updated
- order.created/deleted/updated
- product.created/deleted/updated

Recommended initial use:
- order.created → audit + reconcile transaction/order state
- order.updated → synchronize verified order state
- product.updated → mark KB/catalog freshness work

Do not let a WooCommerce Trigger event directly change agent authorization.
Do not let an event directly tell the customer that payment was collected unless the verified WooCommerce state actually proves the relevant status.
