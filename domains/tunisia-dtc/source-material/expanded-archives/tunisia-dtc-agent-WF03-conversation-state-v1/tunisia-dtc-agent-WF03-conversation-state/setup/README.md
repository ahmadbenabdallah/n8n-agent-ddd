# WF-03 — Conversation State

WF-03 is the persistent state machine for the DTC agent.

It tracks:
- sales stage
- current intent
- selected product
- selected variant
- cart ID
- customer language/script/register
- turn count
- escalation status
- last message

## State machine

NEW
→ BROWSING
→ DISCOVERY
→ PRODUCT_INTEREST
→ CONSIDERING
→ PRODUCT_SELECTED
→ CART_BUILDING
→ CHECKOUT_READY
→ PURCHASED
→ POST_PURCHASE
→ CLOSED

Additional states:
OBJECTION_HANDLING
WAITING_FOR_CUSTOMER
HUMAN_ESCALATION

The LLM may propose a state transition, but the deterministic transition rules remain
in WF-03/application logic.
