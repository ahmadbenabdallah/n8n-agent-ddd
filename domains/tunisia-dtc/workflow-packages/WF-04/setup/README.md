# WF-04 — Intent Router

Purpose: deterministically classify the customer message and route it to Sales, Support, Escalation, Clarification, or Off-topic.

## Position in the system

WF-00 Inbound Gateway → WF-01 Security Gate → WF-02 Identity → WF-03 Conversation State → **WF-04 Intent Router** → WF-05 Sales / WF-06 Support / WF-08 Escalation.

The LLM is not an authorization boundary. This workflow uses deterministic rules first and emits a bounded intent contract.

## Required input

```json
{
  "message_id": "meta-message-id",
  "conversation_id": "conversation-id",
  "channel": "facebook_messenger",
  "text": "Ok zidhali taille 42 lel panier.",
  "identity": {},
  "security": {},
  "state": {}
}
```

## Required downstream behavior

- WF-05 consumes sales intents.
- WF-06 consumes support intents.
- WF-08 consumes escalation intents.
- `clarification` means do not guess and do not call commerce tools.
- `security_suspicion` has priority over ordinary business intent.
