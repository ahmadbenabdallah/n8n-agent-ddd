# WF-08 Takeover, Safe Waiting & Release

## State machine

```text
AI / FULL
   ↓ escalation
AI / SAFE_ONLY
   ↓ assignment
HUMAN / SAFE_ONLY
   ↓ takeover
HUMAN / PAUSED
   ↓ resolve
HUMAN / PAUSED
   ↓ release
AI / FULL or SAFE_ONLY
```

## Event contracts

### request_human

```json
{
  "event_type": "HUMAN_REQUESTED",
  "conversation_id": "conv_123",
  "case_id": "case_123",
  "idempotency_key": "..."
}
```

### assign_human

```json
{
  "event_type": "HUMAN_ASSIGNED",
  "case_id": "case_123",
  "human_owner_id": "agent_123",
  "idempotency_key": "..."
}
```

### takeover

```json
{
  "event_type": "HUMAN_TAKEOVER",
  "case_id": "case_123",
  "conversation_id": "conv_123",
  "human_owner_id": "agent_123",
  "idempotency_key": "..."
}
```

### resolve

```json
{
  "event_type": "HUMAN_RESOLVED",
  "case_id": "case_123",
  "resolution_code": "RESOLVED",
  "idempotency_key": "..."
}
```

### release

```json
{
  "event_type": "AI_RELEASED",
  "case_id": "case_123",
  "conversation_id": "conv_123",
  "automation_mode": "FULL",
  "idempotency_key": "..."
}
```

## Safety rule

Before AI resumes FULL mode, check:
- case resolved
- no active mandatory escalation
- no unresolved security flag
- no active human ownership
- conversation state version is current

Otherwise remain SAFE_ONLY/PAUSED.

## Human reply routing

Human replies should enter the same conversation/channel context and be tagged as human-originated.

The AI must not treat a human's internal message as customer text or generate a competing reply.

## Customer message during human ownership

Default behavior:
- attach to case
- notify/queue for human
- no conflicting autonomous action

Safe automated acknowledgement may be sent if the channel policy allows it.
