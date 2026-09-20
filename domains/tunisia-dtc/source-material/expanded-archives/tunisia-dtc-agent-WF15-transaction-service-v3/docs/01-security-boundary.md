# Security Boundary

WF-15 is the narrow transaction service, but **WF-10 remains the authorization boundary**.

WF-15 may only consume an already-authorized `create_cod_order` request.

The LLM cannot:
- create an order directly;
- set order status;
- set payment status;
- set arbitrary total/price/discount;
- choose arbitrary WooCommerce endpoint;
- provide credentials;
- bypass customer confirmation;
- convert COD into paid;
- choose an order ID.

WF-20 enforces the final bounded commerce operation.
