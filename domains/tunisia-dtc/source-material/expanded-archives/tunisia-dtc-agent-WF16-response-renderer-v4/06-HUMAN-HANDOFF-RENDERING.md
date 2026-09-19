# Human Handoff Rendering

When:

```text
conversation_owner = HUMAN
automation_mode = PAUSED
```

WF-16 must not render normal autonomous sales/support claims.

### Human requested, case not yet assigned

Render a concise acknowledgement that the request is being handed to a human.

### Human assigned / in progress

Render a waiting message without claiming facts that were not verified.

### Human resolved

AI resumes only after the explicit release condition defined by WF-08/WF-03.

### New message while human-owned

The renderer should acknowledge receipt only if that acknowledgement is allowed by the current automation mode. It must not silently resume normal automation.

Do not expose `human_owner_id`, case IDs, staff names, or internal SLA data unless an explicit customer-facing policy permits it.
