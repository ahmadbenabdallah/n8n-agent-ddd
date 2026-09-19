# Node-by-node configuration

1. **Execute Workflow Trigger** — invoked by WF-04/WF-06 or future maintenance workflows.
2. **Validate Escalation Input** — validates required canonical context.
3. **Escalation Input Valid?** — fail-closed gate.
4. **Fail Closed** — blocks unsafe escalation requests with malformed input.
5. **Determine Escalation Reason** — maps intent/security signals to a reason.
6. **Severity Classifier** — deterministic critical/high/medium classification.
7. **Check Existing Escalation** — avoids duplicate cases.
8. **Build Minimal Identity Summary** — only identifiers needed for human support.
9. **Build Escalation Context** — strips secrets and unnecessary fields.
10. **Set Handoff Priority** — selects immediate/priority/standard handling.
11. **Existing Escalation Open?** — determines append vs. new case.
12. **Append Existing Case** — plan to append to an existing human case.
13. **Create New Case Plan** — plan to create a new case.
14. **Build Customer Response Policy** — gives renderer a bounded acknowledgement policy.
15. **Build Escalation Contract** — final contract.

## Human-support adapter

The actual CRM/helpdesk action should be a separate authenticated integration. It must:
- use server-side credentials;
- accept only the structured escalation contract;
- avoid customer-controlled destination/URLs;
- enforce agent/team permissions;
- return a case ID and status;
- be idempotent.
