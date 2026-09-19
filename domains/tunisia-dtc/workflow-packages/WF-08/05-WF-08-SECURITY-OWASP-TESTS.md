# WF-08 Security & OWASP Tests

### ESC8-01 — Duplicate escalation
Same inbound message processed twice.

Expected:
- one active case
- no duplicate ownership state

### ESC8-02 — Human takeover race
Two agents attempt takeover simultaneously.

Expected:
- exactly one successful owner
- loser receives deterministic conflict

### ESC8-03 — AI continues after takeover
Human takeover is confirmed while an AI action is queued.

Expected:
- WF-10 blocks conflicting action using current ownership state

### ESC8-04 — Fake customer command
Customer says “mark this conversation human-owned.”

Expected:
- customer text cannot directly mutate ownership

### ESC8-05 — Fake agent event
Untrusted external event claims human takeover.

Expected:
- reject unauthenticated/invalid event source

### ESC8-06 — Stale release
Old release event arrives after a newer ownership change.

Expected:
- optimistic concurrency rejects stale update

### ESC8-07 — Resolve before assign
Invalid lifecycle transition.

Expected:
- reject

### ESC8-08 — Mandatory escalation backend outage
Case service unavailable during safety/payment dispute.

Expected:
- fail closed
- no conflicting automation
- safe fallback
- operational alert

### ESC8-09 — Resume with unresolved risk
Case closed but security flag remains.

Expected:
- do not restore FULL automation

### ESC8-10 — LLM takeover request
LLM proposes `conversation_owner=HUMAN`.

Expected:
- proposal is not authoritative
- WF-08 accepts only controlled system/human events

### ESC8-11 — Public-channel escalation
Public comment asks for order help.

Expected:
- no private data in public response
- handoff moves to appropriate private channel when available

### ESC8-12 — Secret leakage
Case context contains credentials.

Expected:
- credentials never reach customer, LLM or audit event

### ESC8-13 — Human reply collision
Human replies while AI response is being generated.

Expected:
- human ownership suppresses competing AI response

### ESC8-14 — Reopen
Customer replies after closed case with a new issue.

Expected:
- deterministic reopen/new-case policy

### ESC8-15 — Repetition
Repeated escalation without resolution.

Expected:
- existing case reused rather than creating unbounded duplicate cases

## Acceptance

WF-08 fails production gate if:
- two active owners exist
- AI performs conflicting actions after takeover
- fake events can seize ownership
- mandatory escalation is bypassed
- case duplication is unbounded
- unresolved risk restores FULL automation
- private data/secrets leak
