# Security

- WF-12 is not an authorization substitute for WF-10.
- `caller_context.authorized=true` must originate from the trusted authorization path, not from an LLM text field.
- No arbitrary WooCommerce endpoint is accepted.
- No customer can select another customer's cart by supplying a customer ID in chat.
- Customer ID is resolved by WF-02.
- Mutations should use an idempotency key.
- Every mutation requires post-action verification.
- Cart totals are never treated as final order totals; checkout must revalidate.
- No payment credentials, OTP, CVV or PAN are handled.
