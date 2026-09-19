# Requirements

### Upstream
- WF-04 Intent Router
- WF-02 Identity
- WF-03 Conversation State
- WF-01 Security Gate

### Downstream
- WF-09 LLM Reasoning
- WF-11 Product/Policy retrieval
- WF-15 Transaction Service for verified transactional lookups
- WF-08 Escalation
- WF-16 Response Renderer

### Required policy sources

Keep these factual policies in the approved KB:
- shipping regions/classes
- delivery estimate policy
- payment methods
- payment policy
- order-status policy
- return/exchange policy

Live order/payment facts must come from transactional services, not static KB.

### Security requirements

Never request:
- passwords
- OTPs
- CVV/CVC
- full card numbers
- API keys
- authentication tokens
- private credentials

Never expose another customer's order or PII.

`tools_allowed=true` is a capability hint, not authorization. WF-10 remains the action authorization boundary.
