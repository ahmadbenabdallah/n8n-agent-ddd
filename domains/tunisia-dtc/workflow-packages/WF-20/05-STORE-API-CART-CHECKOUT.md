# Store API / Cart / Checkout Boundary

Where WooCommerce Store API is used for customer-facing cart/session behavior:

- keep Cart-Tokens and Nonce Tokens inside the controlled commerce/session boundary;
- never expose them to the LLM;
- never expose them to customer-visible messages;
- never log them;
- bind sessions to the correct controlled conversation/customer context;
- use exact operation allowlists.

Store API responses must be normalized before leaving WF-20.

Checkout should use expected/current totals and appropriate server-side validation.

WF-14 remains responsible for checkout business orchestration and final preflight.
WF-20 is only the commerce transport/execution boundary.
