# WF-14 Checkout Input Contract

A checkout request should contain:
- conversation/request ID;
- authorized action ID;
- authorization ID;
- customer/commerce identity context permitted for checkout;
- cart ID/context;
- required customer checkout fields;
- selected payment method;
- selected shipping method;
- promotion context;
- state version;
- idempotency key.

## Customer data
Only required checkout data should be passed.

Never accept/store/log:
- card PAN;
- CVV;
- OTP/PIN;
- passwords;
- API keys;
- WooCommerce secrets;
- Cart-Tokens/Nonce Tokens in LLM/customer-visible context.

For COD, payment credentials are not required.
