# WF-16 Response Renderer v3

WF-16 is the final customer-facing guard.

## Core rule

**Only verified facts may cross from the internal agent system into the customer channel.**

The renderer does not decide:
- whether an action is authorized;
- whether a price is correct;
- whether stock exists;
- whether a coupon is valid;
- whether an order was created.

Those facts must already be verified by WF-11/WF-12/WF-13/WF-14/WF-15/WF-20.

## LLM policy

The LLM may propose conversational wording, but it must not invent or alter transactional facts. A production implementation should use bounded templates or a constrained structured rendering step for transactional confirmations.
