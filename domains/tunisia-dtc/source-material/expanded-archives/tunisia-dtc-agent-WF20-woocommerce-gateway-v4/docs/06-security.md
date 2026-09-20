# Security Boundary

WF-20 is a privileged integration boundary.

### Never accept from callers
- WooCommerce credentials
- arbitrary URL/path
- arbitrary HTTP method
- arbitrary query parameters
- payment card data
- CVV
- OTP/PIN
- raw Store API Cart-Token
- arbitrary customer/order IDs without upstream authorization context

### Never expose downstream
- consumer key/secret
- Basic Auth header
- Cart-Token
- Nonce Token
- WooCommerce internal meta_data unless explicitly required and sanitized
- payment gateway private data

### Order creation
Only `create_cod_order` is allowed to create an order, and it must be reached from WF-15 after authorization/preflight.
