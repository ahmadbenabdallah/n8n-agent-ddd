# Requirements

### Upstream
- WF-01 Security Gate
- WF-02 Identity
- WF-03 Conversation State
- WF-04 Intent Router
- WF-06 Support Engine

### Downstream
- Human support/CRM adapter
- WF-16 Response Renderer
- WF-17 Audit & Analytics

### Escalation principles

1. Security incidents take priority over ordinary business intents.
2. Do not expose security detection signals to the customer.
3. Do not include secrets in the human case.
4. Do not include unnecessary PII.
5. Do not create duplicate cases for an already-open escalation.
6. Critical situations should receive immediate human handling.
7. Customer acknowledgement must not speculate about facts.
8. Escalation itself does not authorize refunds, cancellations, account changes or other commerce actions.

### Suggested persistence fields

- escalation_id
- conversation_id
- message_id
- reason
- severity
- status
- assigned_team
- assigned_agent
- created_at
- updated_at
- case_reference
- resolution_code
