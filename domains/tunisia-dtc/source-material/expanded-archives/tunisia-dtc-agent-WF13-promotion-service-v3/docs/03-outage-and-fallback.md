# Outage and Fallback

If WooCommerce is unavailable:

### Allowed
`promotion_info` may continue from approved KB content as informational conversation.

### Blocked
`coupon_validate` and `coupon_preview` cannot claim a coupon is currently valid or that a discount has been applied.

The agent may say the coupon needs to be checked when commerce is available again.

The customer can continue the sales conversation and WF-03 can preserve purchase intent/customer details.

On recovery:
1. Resolve identity.
2. Restore context.
3. Read live cart.
4. Validate coupon against live commerce.
5. Revalidate checkout before order creation.
