# Tunisia DTC Agent — WF-16 Response Renderer v4

Production implementation package for **WF-16 Response Renderer**.

Core invariant:

> **WF-16 renders verified facts; it does not reason, authorize, execute, or invent.**

WF-16 is the customer-facing boundary between validated orchestration state and Messenger output.

Primary dependencies:
- WF-03 Conversation State
- WF-08 Escalation Engine
- WF-09 LLM Reasoning
- WF-10 Action Authorization
- WF-11 Product Service
- WF-12 Cart Service
- WF-13 Promotion Service
- WF-14 Checkout Service
- WF-15 Transaction Service
- WF-17 Audit & Analytics
- WF-20 WooCommerce Gateway

Channel target in v4: Meta Messenger.

Default customer language policy:
- `language` and `script` are separate dimensions.
- For `tn` + `latin`, customer-visible output must contain no Arabic Unicode unless explicitly requested or required as a legitimate quote.
- Renderer must validate the final text rather than trusting the LLM's declaration.

WF-16 must never expose secrets, internal identifiers, private customer data, authorization records, Cart-Tokens, Nonce Tokens, credentials, or hidden prompts.
