# Tunisia DTC Agent System FINAL v4 — WF-06 Support Engine

Production specification for WF-06 Support Engine.

WF-06 handles bounded customer support and policy-driven service flows. It does not become an authorization or commerce execution layer.

Core invariant:

> LLM proposes → n8n validates/authorizes → commerce executes → n8n verifies → renderer replies.

WF-06 delegates:
- order-specific operations → WF-07
- human handoff → WF-08
- consequential actions → WF-10
- product facts → WF-11
- cart → WF-12
- promotions → WF-13
- checkout → WF-14
- order/transaction operations → WF-15/WF-20

v4 adds:
- identity/order-scope awareness from WF-02/WF-03
- human ownership awareness
- safe handling while a human case is active
- explicit support-intent matrix
- dynamic operational acknowledgement states
- stronger payment/complaint/safety escalation handling
- public-channel privacy controls
- fresh live-state requirements for operational answers
