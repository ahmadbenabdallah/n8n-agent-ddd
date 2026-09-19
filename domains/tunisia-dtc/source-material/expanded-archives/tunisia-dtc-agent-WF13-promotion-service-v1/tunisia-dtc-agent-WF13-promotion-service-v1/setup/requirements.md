# Requirements

- n8n
- WF-10 Action Validator
- trusted promotion source of truth
- trusted cart subtotal/line data
- customer eligibility reference when promotions are customer-specific
- persistent promotion usage counters in the commerce system
- server-side commerce credentials

## Live source must verify
- promotion exists
- active date window
- code validity
- customer eligibility
- product/category/variant eligibility
- minimum order value
- usage limit
- per-customer usage
- currency
- discount calculation
- stacking/exclusivity
- final discount ceiling

Do not rely on the static KB for mutable promotion validity.
