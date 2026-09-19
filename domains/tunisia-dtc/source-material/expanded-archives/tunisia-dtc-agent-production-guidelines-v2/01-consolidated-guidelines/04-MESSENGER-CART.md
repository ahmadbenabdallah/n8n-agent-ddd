# Messenger / WooCommerce Cart Design

Messenger does not provide a browser cookie model that can simply be reused for WooCommerce Store API.

Recommended mapping:

`agent_customer_id + channel + store_id → protected WooCommerce Cart-Token`

## Rules

1. Resolve customer identity through WF-02.
2. Resolve the cart reference inside WF-20.
3. Keep the actual Cart-Token in protected storage.
4. Never expose Cart-Token to the LLM.
5. Never expose Cart-Token to WF-16/customer.
6. Never log the raw token.
7. Treat the cart reference supplied to domain workflows as an opaque internal reference.
8. Re-fetch and verify cart after mutation.
9. Revalidate again at checkout.
10. Revalidate again immediately before transaction creation.

The Store API supports Cart-Token based headless sessions. Exact persistence/encryption is deployment-specific and must be completed before production.
