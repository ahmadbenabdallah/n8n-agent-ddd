# WF-00 — Inbound Gate

## Purpose
Convert channel-specific webhooks into one canonical event.

## Nodes

1. `TRIGGER — Channel Webhook`
2. `NORMALIZE — Provider Payload`
3. `SET — Correlation ID`
4. `DB — Idempotency Lookup`
5. `IF — Duplicate?`
6. `DB — Create Message Receipt`
7. `EXECUTE — Security Gate`
8. `EXECUTE — Identity`
9. `EXECUTE — State`
10. `EXECUTE — Intent Router`

## Canonical input

```json
{
  "channel": "whatsapp",
  "external_message_id": "msg_123",
  "external_thread_id": "thread_123",
  "external_customer_id": "cust_123",
  "text": "slt fama taille L?",
  "attachments": [],
  "received_at": "2026-09-16T18:00:00Z",
  "correlation_id": "uuid"
}
```

## Idempotency

Unique key:

`channel:external_message_id`

If duplicate:
- do not call the LLM;
- do not send a second reply;
- terminate successfully.

## Security boundary

Only normalized fields enter downstream workflows. Do not forward raw provider payloads to the LLM.
