# WF-10 Action Catalog

Actions are capabilities, not permissions.

| Action | Requirement | Mutation | Target |
|---|---|---:|---|
| product_lookup | public/current | No | WF-11 |
| cart_view | valid channel context | No | WF-12 |
| cart_add | channel-linked + current variant | Yes | WF-12 |
| cart_remove | channel-linked + current cart | Yes | WF-12 |
| cart_update | channel-linked + current cart | Yes | WF-12 |
| cart_clear | channel-linked + current cart | Yes | WF-12 |
| promotion_validate | channel context + live validation | No | WF-13 |
| checkout_prepare | checkout identity/context | Controlled | WF-14 |
| checkout_confirm | verified checkout + immediate preflight | Yes | WF-14 |
| order_status | active order scope | No | WF-07 |
| transaction_status | permitted order/transaction scope | No | WF-15 |
| human_request | valid conversation | Case mutation | WF-08 |

Unknown action types are denied. The LLM cannot invent action names or capabilities.
