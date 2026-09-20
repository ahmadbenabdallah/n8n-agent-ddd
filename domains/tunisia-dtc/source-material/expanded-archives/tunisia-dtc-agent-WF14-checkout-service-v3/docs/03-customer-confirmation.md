# Customer Confirmation

WF-14 may return a verified snapshot that WF-16 can render as a confirmation summary.

Example safe summary fields:
- product names/variants
- quantities
- subtotal
- approved discount
- shipping cost when known
- final total
- payment method: Cash on Delivery
- customer-safe delivery details

The customer confirmation should be explicit before WF-15 attempts order creation.

A conversational phrase such as "ok" must only count as confirmation if WF-04/WF-10 policy and conversation context establish that it refers to the displayed checkout summary. Never infer confirmation from unrelated messages.
