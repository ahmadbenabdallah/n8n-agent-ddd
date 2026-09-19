# WF-12 Commerce Contract

All WooCommerce execution goes through WF-20.

WF-20 may use the appropriate WooCommerce cart mechanism for the deployment, including controlled Store API/session handling where configured.

Never expose Cart-Tokens, Nonce Tokens, credentials or private WooCommerce session material to:
- LLM;
- customer;
- analytics;
- logs not explicitly protected.

If a commerce session token is required, it remains inside the controlled commerce boundary.

## Result
Return:
- operation result;
- normalized cart;
- commerce timestamp/version where available;
- correlation ID;
- safe error code.
