# WF-08 End-to-End Flows

## A — Customer requests human

Customer:
“nheb نحكي مع humain.”

1. WF-06 detects `human_request`.
2. WF-08 creates case idempotently.
3. State becomes `HUMAN_REQUESTED`.
4. Automation becomes `SAFE_ONLY`.
5. WF-16 sends controlled acknowledgement.
6. Human system assigns case.
7. Takeover changes ownership to HUMAN/PAUSED.
8. Human replies through supported channel.
9. Human resolves.
10. Release policy determines whether AI returns FULL or SAFE_ONLY.

## B — Chargeback

Customer threatens chargeback.

1. WF-06 classifies `payment_dispute`.
2. WF-08 creates HIGH-priority case.
3. AI cannot negotiate or promise outcome.
4. Human takeover pauses conflicting automation.
5. Human handles dispute.
6. Case resolution is audited.

## C — Safety complaint

Customer reports dangerous defect.

1. WF-06 identifies safety escalation.
2. WF-08 creates case.
3. SAFE_ONLY/PAUSED prevents unsafe autonomous action.
4. Controlled safe acknowledgement.
5. Human takes over.
6. Resolution is recorded.

## D — AI action racing with takeover

1. AI proposes cart/checkout action.
2. Human takeover event occurs.
3. WF-03 ownership state updates.
4. WF-10 rechecks current state.
5. Conflicting action is blocked.

The action must not be assumed safe merely because it was proposed before takeover.

## E — Human-owned new message

Customer sends:
“mazelt ma sar chay?”

1. Inbound routed to active case.
2. No duplicate case.
3. Human receives/queues message.
4. AI does not independently perform conflicting resolution.
5. Optional safe acknowledgement.

## F — Closed case reopened

Customer returns with the same unresolved issue.

1. WF-08 detects closed prior case.
2. Policy decides reopen vs new case.
3. New lifecycle event is idempotent.
4. Risk state is recalculated.
5. AI remains restricted until ownership policy allows release.

## G — Case system unavailable

Safety escalation occurs while case service is unavailable.

Expected:
- no conflicting autonomous action
- safe fallback
- operational alert
- bounded retry/reconciliation
