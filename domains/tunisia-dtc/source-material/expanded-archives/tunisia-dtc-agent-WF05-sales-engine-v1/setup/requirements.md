# Requirements

- WF-04 must provide a valid intent contract.
- WF-03 must provide trusted conversation state.
- WF-02 must provide the identity contract.
- WF-10 must remain the only action-authorization boundary.
- Product facts must come from WF-11 / approved KB.
- Cart data must come from WF-12.
- Promotions must come from WF-13.
- Checkout must come from WF-14.
- No credentials are required directly by WF-05.

## Required trusted state fields

Recommended:
- `stage`
- `selected_product_id`
- `selected_variant`
- `cart_id`
- `language`
- `script`
- `register`
- `turn_count`
- `escalation_status`

## Business logic controls

- No action is executed from this workflow.
- A missing product/cart context produces clarification.
- `checkout_confirm` is never treated as successful purchase.
- The next stage is deterministic and bounded.
- A customer claim such as “I already paid” is not transactional truth; verify through commerce/payment services.
