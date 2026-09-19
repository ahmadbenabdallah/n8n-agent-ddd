# WF-01 — Security Gate

## Nodes

1. `INPUT`
2. `SET — Limits`
3. `DB — Velocity Query`
4. `IF — Velocity Exceeded`
5. `CODE — Message Size`
6. `CODE — Suspicious Pattern Signal`
7. `DB — Security Event`
8. `SWITCH — Risk`
9. `RETURN — Continue / Hold / Escalate`

## Limits

Configure centrally:
- max message characters;
- max messages/window;
- max automated turns;
- max tool calls/turn;
- max RAG calls/turn;
- max retries;
- max workflow execution duration.

## Injection signal

Detect signals such as:
- prompt extraction;
- instruction override;
- fake system messages;
- requests to reveal tools/credentials;
- instructions embedded in retrieved/customer content.

Detection does not mean the customer is malicious. It means the agent must remain strictly inside the allowlisted path.

## High-risk result

```json
{
  "security_status": "restricted",
  "reason": "PROMPT_INJECTION_SIGNAL",
  "allow_write_actions": false,
  "allow_sensitive_reads": false
}
```
