# Static KB vs Live Commerce

This separation is mandatory.

| Question | Authoritative source |
|---|---|
| What is the product? | KB + WF-11 |
| Current price? | WooCommerce/live commerce |
| Current stock? | WooCommerce/live commerce |
| Is coupon valid now? | WF-13/live commerce |
| Is this customer's order shipped? | WF-07/live commerce |
| Is payment completed? | WF-15/live commerce |
| What is current checkout total? | WF-14/live commerce |
| What is the return policy? | approved KB |
| What payment methods are supported? | approved KB + current configuration where required |

KB content must never be presented as current transactional truth when live verification is required.
