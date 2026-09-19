# V4 Identity & Human Handoff

Identity progression:

ANONYMOUS
→ CHANNEL_LINKED
→ COMMERCE_MATCHED
→ ORDER_VERIFIED
→ HIGH_ASSURANCE

`COMMERCE_MATCHED` is not equivalent to order authorization.

Order scope is:
- explicit;
- revocable;
- expirable;
- tied to verified identity context.

Human ownership:

```text
AI
→ HUMAN_REQUESTED
→ HUMAN_ASSIGNED
→ HUMAN_IN_PROGRESS
→ RESOLVED
→ RELEASED
```

While human-owned:

```json
{
  "conversation_owner": "HUMAN",
  "automation_mode": "PAUSED"
}
```

AI must not silently resume until the explicit release condition is satisfied.
