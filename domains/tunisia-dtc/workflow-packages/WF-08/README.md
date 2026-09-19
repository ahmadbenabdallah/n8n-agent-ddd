# Tunisia DTC Agent System FINAL v4 — WF-08 Escalation Engine

Production specification for WF-08.

WF-08 is the **human escalation and conversation-ownership control workflow**. Escalation is not merely a notification or boolean flag: it creates/manages a human case and changes who owns the conversation.

Core invariant:

> LLM proposes → n8n validates/authorizes → commerce executes → n8n verifies → renderer replies.

WF-08 controls:
- escalation decision
- human case creation
- case idempotency
- ownership lifecycle
- AI automation mode
- human assignment/takeover
- safe waiting
- release/reopen
- SLA/priority metadata
- audit events

WF-08 does not itself grant commerce permissions and does not replace WF-10 authorization.
