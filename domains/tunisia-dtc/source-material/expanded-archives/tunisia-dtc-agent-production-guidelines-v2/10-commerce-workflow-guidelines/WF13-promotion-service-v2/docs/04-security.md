# Security

- Never trust LLM-provided discount amounts.
- Never let the LLM set `eligible=true`.
- Never let the LLM set usage_count.
- Never expose coupon meta_data.
- Coupon code is length-bounded and newline-rejected.
- No arbitrary endpoint/path accepted.
- Customer identity comes from WF-02.
- Coupon validation is advisory until checkout revalidation.
- WF-14 must validate the coupon again immediately before order creation.
- A successful coupon lookup does not itself authorize an order.
