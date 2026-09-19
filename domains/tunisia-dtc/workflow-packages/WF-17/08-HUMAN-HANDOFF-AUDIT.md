# Human Handoff Audit

WF-17 must make human ownership auditable.

Lifecycle:

```text
ACTIVE
 -> HUMAN_REQUESTED
 -> HUMAN_ASSIGNED
 -> HUMAN_IN_PROGRESS
 -> RESOLVED
 -> CLOSED
```

Also record:
- trigger category;
- priority;
- SLA timestamps;
- ownership changes;
- automation mode changes;
- AI release event;
- case reopen event.

Do not expose internal staff identifiers to customers.

Important:
- `human_requested` does not mean `human_assigned`;
- `human_assigned` does not mean `human_in_progress`;
- `resolved` does not automatically authorize AI resumption;
- explicit release is required before autonomous AI resumes.
