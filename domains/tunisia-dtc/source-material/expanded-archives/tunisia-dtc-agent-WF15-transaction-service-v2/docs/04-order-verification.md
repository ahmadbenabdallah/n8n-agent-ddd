# Post-Create Verification

After WooCommerce returns an order ID, WF-15 retrieves the order again through WF-20.

Verify at minimum:
- returned order ID matches created order ID
- order exists
- status is a known WooCommerce order status
- payment method is COD
- order belongs to the expected customer context
- line items and quantities match the validated checkout
- totals match the authorized checkout within the expected WooCommerce representation

If verification fails, do not tell the customer that the order is confirmed. Escalate/audit using WF-17.
