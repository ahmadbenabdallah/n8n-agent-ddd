# Identity, Order Scope & Human Handoff

## Identity ladder

1. ANONYMOUS
2. CHANNEL-LINKED
3. COMMERCE-MATCHED
4. ORDER-VERIFIED
5. HIGH-ASSURANCE

The identity level is system-controlled.

## Website-originated orders

If a customer messages through Messenger about an order created on the website:
1. map Messenger identity if already linked;
2. if linked and order is in scope, retrieve status;
3. otherwise request the minimum checkout identifier needed;
4. discover candidate order;
5. verify according to policy;
6. establish order scope;
7. persist relationship.

Do not expose candidate order details before verification.

## Human ownership

Explicit human request or mandatory escalation creates a case.

States:
ACTIVE → HUMAN_REQUESTED → HUMAN_ASSIGNED → HUMAN_IN_PROGRESS → RESOLVED → CLOSED

When human ownership is active:
- AI acknowledges appropriately;
- AI must not contradict human decisions;
- AI must not perform conflicting mutations;
- new messages can update the case but do not silently transfer ownership back to automation.

## Dynamic acknowledgements

Operational acknowledgements must come from system state. The LLM may propose wording but may not invent:
- “a human has been notified”;
- “your case is assigned”;
- “someone will call you”;
unless the system confirms those facts.
