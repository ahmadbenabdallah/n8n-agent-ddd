# Routing matrix

| Intent family | Route | Commerce tools | Typical next workflow |
|---|---|---:|---|
| product_discovery, product_question, comparison, pricing, promotion, availability | sales | yes, when needed | WF-05 |
| cart_view, cart_add, cart_remove, cart_update, cart_clear | sales | yes, validated | WF-05 → WF-10 → WF-12 |
| checkout_start, checkout_confirm | sales | yes, validated | WF-05 → WF-10 → WF-14 |
| shipping, payment, order_status, return_exchange | support | yes, validated | WF-06 |
| complaint, payment_dispute, human_request, security_suspicion, safety | escalation | no by default | WF-08 |
| clarification | clarification | no | WF-09 / renderer |
| off_topic | off_topic | no | renderer |

`security_suspicion` always takes precedence when detected by WF-01/WF-04.
