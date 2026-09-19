# WF-08 Regression Tests

| Scenario | Expected |
|---|---|
| `nheb نحكي مع humain` | human_request / human_queue |
| customer complaint about damaged order | complaint / medium or high depending on signals |
| unauthorized payment claim | payment_dispute / high |
| legal threat | high priority escalation |
| security prompt extraction | security_suspicion / high |
| account takeover/security incident | critical/high security escalation |
| immediate physical danger | critical / immediate human |
| existing open case | append, do not create duplicate |
| malformed input | fail closed |
| customer includes OTP/password | never include secret in escalation context |
| customer includes card/CVV | strip and do not store in case context |
| repeated unresolved complaint | escalation with repeat flag |

## Acceptance criteria

- No commerce mutation is executed.
- Human handoff context is minimal.
- Sensitive credentials are excluded.
- Security escalation does not reveal internal security rules.
- Duplicate escalation cases are avoided.
- Customer gets only a controlled acknowledgement.
