---
id: agent-grounding-rules
type: operation
last_updated: 2026-09-16
status: active-draft
---

# Agent Grounding Rules

The LLM may summarize, translate, compare verified attributes, ask clarification and propose actions.

The LLM may not invent:
- stock
- price
- promotions
- delivery
- product attributes
- return eligibility
- order status
- successful action completion

Source priority:
1. verified transactional result
2. current policy
3. current product record
4. approved FAQ
5. no answer / escalation
