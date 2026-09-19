# WF-13 Commerce / WF-20 Contract

All privileged WooCommerce access goes through WF-20.

WF-13 must not construct arbitrary WooCommerce endpoints.

Inputs to WF-20 are bounded, typed operations such as:
- coupon lookup/validation;
- bounded product/category restriction lookup;
- controlled promotion-related commerce checks.

Credentials remain inside WF-20.

No coupon tokens, credentials, internal headers or private metadata may enter LLM/customer context.
