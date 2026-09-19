# Tunisia DTC Agent System FINAL v4 — WF-09 LLM Reasoning

WF-09 is the reasoning/proposal layer only.

Core invariant:
LLM proposes → n8n validates/authorizes → commerce executes → n8n verifies → WF-16 renders.

WF-09 MUST NOT authorize, execute commerce mutations, determine final price/stock/payment/order status, establish identity, grant order scope, or override human ownership.

Dependencies:
WF-02 Identity, WF-03 Conversation State, WF-04 Intent Router, WF-05 Sales, WF-06 Support, WF-07 Order, WF-08 Escalation, WF-10 Authorization, WF-11 Product, WF-12 Cart, WF-13 Promotion, WF-14 Checkout, WF-15 Transaction, WF-16 Renderer, WF-17 Audit.

Package contents:
1. LLM reasoning contract
2. Input/context contract
3. System/developer prompt
4. Structured output contract
5. Context assembly and grounding
6. Human-handoff behavior
7. n8n implementation
8. Security/OWASP tests
9. E2E flows
10. Production checklist
11. Model/configuration policy
