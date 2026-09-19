# WF-08 Escalation Engine — Production Specification v4

## 1. Purpose

WF-08 converts mandatory or requested human escalation into a controlled case-ownership lifecycle.

The key design decision is:

> Human escalation = conversation ownership state + case lifecycle + routing, not a notification alone.

A notification without ownership control is insufficient because the AI could continue performing conflicting actions after a human has taken over.

## 2. Mandatory escalation triggers

Escalate or stop conflicting automation for:

```text
safety
payment_dispute
chargeback
legal_threat
serious_unresolved_complaint
damaged_or_defective_review_required
identity_uncertainty_for_sensitive_operation
unauthorized_activity
security_incident
repeated_failed_resolution
explicit_human_request
human_case_already_active
```

These conditions are derived from the existing escalation policy and security requirements.

## 3. Human case lifecycle

Canonical lifecycle:

```text
ACTIVE
  ↓
HUMAN_REQUESTED
  ↓
HUMAN_ASSIGNED
  ↓
HUMAN_IN_PROGRESS
  ↓
RESOLVED
  ↓
CLOSED
```

Allowed exceptional transitions:

```text
HUMAN_REQUESTED → CLOSED
HUMAN_IN_PROGRESS → HUMAN_REQUESTED
RESOLVED → HUMAN_REQUESTED
CLOSED → HUMAN_REQUESTED
```

Reopening is permitted only through an explicit new escalation event or configured human workflow.

WF-08 must reject arbitrary state transitions.

## 4. Conversation ownership

Canonical fields:

```json
{
  "conversation_owner": "AI",
  "automation_mode": "FULL",
  "human_owner_id": null,
  "case_id": null,
  "escalation_status": "NONE"
}
```

When human ownership begins:

```json
{
  "conversation_owner": "HUMAN",
  "automation_mode": "PAUSED",
  "human_owner_id": "agent_123",
  "case_id": "case_123",
  "escalation_status": "HUMAN_IN_PROGRESS"
}
```

Possible automation modes:

```text
FULL
SAFE_ONLY
PAUSED
```

Meaning:

- `FULL`: normal AI automation permitted subject to all other controls.
- `SAFE_ONLY`: acknowledgement/routing and explicitly permitted non-conflicting handling only.
- `PAUSED`: no autonomous consequential action.

## 5. Request vs assignment vs takeover

These are separate events.

### HUMAN_REQUESTED
Customer or policy requests human assistance.

AI may still be running in `SAFE_ONLY` while assignment is pending.

### HUMAN_ASSIGNED
A human agent/case owner has been assigned.

The system records ownership but the exact messaging behavior remains controlled.

### HUMAN_IN_PROGRESS
Human has explicitly taken ownership.

Set:

```text
conversation_owner = HUMAN
automation_mode = PAUSED
```

### RESOLVED
Human marks case resolved.

AI should not automatically resume until release/reopen policy permits it.

### CLOSED
Case is administratively closed.

A new customer issue can create/reopen a new case.

## 6. Customer-facing behavior

When escalation is triggered, the renderer should use a controlled acknowledgement.

Examples of intent-level acknowledgement states:

```text
HANDING_TO_HUMAN
```

Possible response:

“Tawa nwaslek m3a équipe mta3na باش ychoufoulek el mawthou3.”

The exact wording is channel/language controlled by WF-16.

Do not tell the customer:
- a human has replied if they have not
- a case is assigned if assignment is not confirmed
- a refund is approved
- a manager is reviewing it
unless the corresponding state/event is verified.

## 7. Human-owned conversation behavior

When `conversation_owner=HUMAN`:

### Related message
Example:
Customer continues discussing the active complaint.

Expected:
- route/attach to the active case
- notify/queue for human
- controlled acknowledgement if permitted
- no independent conflicting resolution

### Unrelated message
Example:
Customer asks a new product question.

The system may classify it as a separate topic, but must not silently interfere with the active human case.

A safe implementation is:
- attach to the existing conversation
- preserve human ownership
- permit only explicitly configured safe automation
- create a new case only when policy requires it

The ownership policy must be deterministic.

## 8. Human takeover

Takeover is an authoritative event.

Required checks:
- case exists
- case is assignable
- conversation matches case
- agent identity is valid
- no conflicting takeover race
- event is idempotent

On success:

```text
conversation_owner = HUMAN
automation_mode = PAUSED
human_owner_id = assigned agent
escalation_status = HUMAN_IN_PROGRESS
```

The change must be persisted atomically with optimistic concurrency/version checks.

## 9. Release back to AI

Human release is also an explicit event.

Recommended:

```text
HUMAN_IN_PROGRESS
→ RESOLVED
→ AI_RESTORED
```

On AI restoration:

```text
conversation_owner = AI
automation_mode = FULL
human_owner_id = null
```

However, if unresolved risk remains, restore:

```text
automation_mode = SAFE_ONLY
```

and require further human handling.

Never resume FULL automation merely because a case was marked closed if security/risk flags still prohibit it.

## 10. SLA and priority

Case metadata should support:

```text
priority
created_at
assigned_at
first_human_response_at
resolved_at
closed_at
sla_deadline
escalation_reason
risk_level
channel
conversation_id
customer_id
```

Do not place secrets or unnecessary sensitive content in case metadata.

## 11. Case idempotency

Case creation must use a stable idempotency key derived from:

```text
conversation_id + escalation_reason + active_case_scope
```

The same inbound webhook or repeated escalation detection must not create duplicate active cases.

Takeover, assignment, resolution and release events also require idempotent event handling.

## 12. Race conditions

WF-08 must protect against:

- two agents taking the same case
- AI acting while takeover occurs
- two escalation events creating duplicate cases
- resolution arriving before assignment
- stale release event overwriting newer ownership
- webhook retries

Use:
- state version
- atomic conditional updates
- idempotency keys
- event timestamps/sequence where available

## 13. Interaction with WF-10

WF-08 changes conversation ownership.

WF-10 remains the hard authorization boundary.

Therefore:

```text
WF-08 HUMAN ownership
        ↓
WF-10 authorization
        ↓
consequential action allowed/blocked
```

WF-08 must never set:

```text
execution_allowed=true
```

## 14. Interaction with WF-17

WF-08 emits case and ownership events.

WF-17 stores/audits them.

Audit does not grant authority.

## 15. Failure behavior

If case creation fails:

- do not claim human handoff succeeded
- use safe fallback acknowledgement
- retry only with idempotency
- escalate operationally if the failure persists

If takeover persistence fails:
- do not tell customer human has taken over
- preserve safe mode
- prevent conflicting autonomous actions

If case system is unavailable:
- fail closed for mandatory escalation
- enter safe fallback state
- surface operational alert
