# Workflow Map

## Customer path

Messenger
→ WF-00 Inbound Gateway
→ WF-01 Security Gate
→ WF-02 Identity
→ WF-03 Conversation State
→ WF-04 Intent Router
→ WF-05 Sales / WF-06 Support
→ WF-09 LLM Reasoning
→ WF-10 Action Validator
→ domain workflow
→ WF-20 WooCommerce Gateway
→ WooCommerce
→ verification
→ WF-16 Renderer
→ WF-17 Audit

## Commerce domain mapping

| Workflow | Responsibility | WooCommerce dependency |
|---|---|---|
| WF-07 | Order lookup/service | WF-20 get_order |
| WF-11 | Product lookup | WF-20 product operations |
| WF-12 | Cart | WF-11 + WF-20 Store API cart |
| WF-13 | Promotion/coupon validation | WF-20 coupon validation |
| WF-14 | Checkout validation | WF-20 live checkout validation |
| WF-15 | COD transaction | WF-20 preflight/create/get order |
| WF-20 | Central adapter | WooCommerce native/REST/Store API |

## Authorization rule

Only WF-10 may establish that a proposed action is authorized.

WF-20 does not replace WF-10. It is the privileged execution/integration boundary after domain validation.
