# WF-08 — Human Escalation

## Triggers

Immediate:
- safety/injury/allergic reaction;
- payment dispute/chargeback;
- legal threat;
- serious complaint;
- defective/damaged claim when policy requires review;
- identity uncertainty;
- unauthorized requested action.

Automatic:
- repeated unresolved question;
- automated-turn cap;
- velocity abuse;
- unsupported policy edge case.

## Nodes

`SET — Escalation Reason → LLM — Summary → JSON Validate → DB — Handoff → Notify Human → Mark Conversation → Send Customer Message`

## Summary schema

```json
{
  "reason": "damaged_product",
  "priority": "high",
  "customer_request": "...",
  "summary": "...",
  "order_id": "...",
  "actions_taken": [],
  "sources": []
}
```
