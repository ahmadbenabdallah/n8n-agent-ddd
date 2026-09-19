# WF-08 n8n Implementation Blueprint

## Recommended sequence

```text
Execute Workflow Trigger
→ Load WF-03 conversation state
→ Load/create human case
→ Evaluate escalation reason
→ Idempotency check
→ Determine target case state
→ Conditional atomic case update
→ Update WF-03 ownership/automation state
→ Emit WF-17 audit event
→ Return renderer acknowledgement state
```

## Human assignment/takeover workflow

```text
Human system event
→ authenticate/validate event source
→ load case
→ optimistic concurrency check
→ assign/takeover
→ atomically update case + conversation ownership
→ emit audit
→ channel behavior update
```

## n8n implementation rules

1. Never allow arbitrary status strings from customer input.
2. Use enum/allowlist transitions.
3. Use idempotency for case creation and lifecycle events.
4. Use conditional database updates for ownership races.
5. Keep human credentials in n8n credentials/secrets.
6. Do not send raw case internals to the LLM.
7. Keep WF-10 separate from WF-08.

## Suggested database operations

Case creation:

```sql
INSERT ... ON CONFLICT (idempotency_key) DO NOTHING
```

Takeover concept:

```sql
UPDATE human_cases
SET status = 'HUMAN_IN_PROGRESS',
    human_owner_id = :agent,
    state_version = state_version + 1
WHERE case_id = :case
  AND status IN ('HUMAN_ASSIGNED', 'HUMAN_REQUESTED')
  AND state_version = :expected_version;
```

Then update conversation ownership using the same concurrency strategy.

## Error codes

```text
WF08_INVALID_REASON
WF08_INVALID_TRANSITION
WF08_CASE_NOT_FOUND
WF08_CASE_ALREADY_OWNED
WF08_OWNERSHIP_CONFLICT
WF08_STALE_STATE
WF08_IDEMPOTENCY_CONFLICT
WF08_CASE_SYSTEM_UNAVAILABLE
WF08_RELEASE_BLOCKED
WF08_ESCALATION_REQUIRED
```

## Notifications

Notification delivery is separate from ownership.

A notification can fail while the case still exists.
Do not treat “notification sent” as “human took over.”

If the notification subsystem fails:
- retain case
- maintain safe mode
- retry safely
- alert operations
