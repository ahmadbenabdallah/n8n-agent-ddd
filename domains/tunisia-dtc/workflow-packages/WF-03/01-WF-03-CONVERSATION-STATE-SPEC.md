# WF-03 Conversation State — Production Specification

## 1. Responsibility

WF-03 owns the deterministic canonical state of the current conversation.

It receives normalized context from WF-00/WF-01/WF-02 and makes that state available to downstream workflows.

The LLM may suggest values, but it cannot directly mutate canonical state.

## 2. Canonical state model

```json
{
  "conversation_id": "conv_123",
  "channel": "facebook",
  "channel_subject_id_ref": "internal-channel-ref",
  "customer_id": "cust_uuid",
  "channel_identity_id": "channel_identity_uuid",
  "commerce_identity_id": "commerce_identity_uuid",
  "identity_level": 1,
  "identity_status": "channel_linked",
  "identity_conflict": false,

  "order_scope_ids": [],
  "active_order_scope_count": 0,

  "intent": "product_question",
  "sub_intent": null,
  "sales_stage": "BROWSING",

  "selected_products": [],
  "cart_id": null,
  "commerce_session_ref": null,

  "conversation_owner": "AI",
  "automation_mode": "FULL",
  "human_owner_id": null,
  "case_id": null,
  "escalation_status": "NONE",

  "acknowledgement_state": null,
  "pending_action_id": null,
  "last_action_id": null,
  "last_idempotency_key": null,
  "execution_status": null,
  "reconciliation_status": null,

  "verification_status": null,
  "last_verified_at": null,

  "turn_count": 1,
  "automated_turn_count": 1,
  "risk_flags": [],
  "security_flags": [],

  "last_updated_at": "2026-09-17T10:00:00Z"
}
```

## 3. Identity state

WF-03 stores identity context produced by application logic.

Allowed identity levels:
- 0 ANONYMOUS
- 1 CHANNEL_LINKED
- 2 ORDER_VERIFIED
- 3 HIGH_ASSURANCE

`COMMERCE_MATCHED` can exist as a non-privileged status but is not an authorization level.

### Hard rules
- LLM cannot increase identity level.
- LLM cannot create order scope.
- LLM cannot change customer_id.
- LLM cannot link a channel to another customer.
- LLM cannot grant permissions.

Identity transitions must originate from WF-02/application verification.

## 4. Order scope state

WF-03 may cache references to active scope IDs for orchestration.

It must not treat cached scope as final authorization.

Before protected commerce execution, WF-10 must revalidate:
- scope status;
- customer relationship;
- requested order;
- requested permissions;
- human ownership constraints.

If scope becomes revoked/expired, downstream authorization must fail closed.

## 5. Human ownership state

```text
conversation_owner:
  AI | HUMAN | SYSTEM

automation_mode:
  FULL | SAFE_ONLY | PAUSED
```

Recommended lifecycle:

```text
AI/FULL
  ↓ escalation
AI/HUMAN_REQUESTED + SAFE_ONLY
  ↓ human accepts
HUMAN/HUMAN_ASSIGNED + PAUSED or SAFE_ONLY
  ↓ human begins
HUMAN/HUMAN_IN_PROGRESS + SAFE_ONLY
  ↓ release
AI/FULL
```

The exact automation mode during human ownership is policy-controlled, but consequential conflicting actions must never continue automatically.

## 6. Human case linkage

When escalation creates a case:
- `case_id` becomes the canonical case reference;
- `human_owner_id` is populated when assigned;
- `conversation_owner` changes only through the human-ownership control path;
- state changes are audited.

A notification to a human is not equivalent to takeover.

## 7. New message during human ownership

When a new inbound message arrives:

### Related to active case
- retain human ownership;
- do not independently execute conflicting consequential actions;
- acknowledge safely if configured;
- notify/route to human.

### Clearly unrelated and policy permits
The system may handle the unrelated request, but WF-10 still applies to every consequential action.

WF-03 must not automatically release human ownership merely because a message appears unrelated.

## 8. Dynamic acknowledgement state

Supported deterministic states:

```text
CHECKING_ORDER
CHECKING_PRODUCT
CHECKING_AVAILABILITY
CHECKING_PRICE
CHECKING_CART
VALIDATING_PROMOTION
PREPARING_CHECKOUT
HANDING_TO_HUMAN
RECONCILING_ORDER
```

These are UX/control states, not claims that an action succeeded.

WF-16 selects the customer-facing acknowledgement from the approved template catalog.

The LLM cannot fabricate an acknowledgement that claims success.

## 9. Action state

For every consequential action, track:

```text
pending_action_id
last_action_id
idempotency_key
execution_status
reconciliation_status
```

Recommended execution statuses:

`NONE | PROPOSED | AUTHORIZED | EXECUTING | SUCCEEDED | FAILED | UNKNOWN`

Recommended reconciliation statuses:

`NOT_REQUIRED | PENDING | VERIFIED | RECOVERY_REQUIRED`

An `UNKNOWN` result must never be converted to `SUCCEEDED` by the LLM.

## 10. Turn controls

Track:
- total turn count;
- automated turn count;
- repetition guard;
- velocity/abuse state;
- escalation state.

The existing maximum automated-turn policy remains 15 unless merchant configuration explicitly changes it.

## 11. State mutation authority

| Field group | Authoritative owner |
|---|---|
| customer_id / identity level | WF-02/application |
| order scope | verification + WF-10 |
| intent suggestion | LLM/WF-04, validated by orchestration |
| sales stage | deterministic sales/state logic |
| cart reference | commerce/service layer |
| human ownership | WF-08/human-control path |
| acknowledgement state | orchestration |
| action execution state | action executor/WF-10/WF-20 |
| reconciliation | verification layer |
| audit event | WF-17 |

## 12. Stale state

WF-03 state is orchestration context, not live commerce truth.

Before answering or executing an operation that depends on current:
- stock;
- price;
- promotion;
- cart;
- order status;
- payment status;

the relevant commerce service must fetch fresh authoritative state.

## 13. State transition invariant

No state transition may:
- grant permissions;
- expose protected data;
- create a WooCommerce order;
- change payment state;
- bypass WF-10;
- bypass human ownership controls.

## 14. Persistence

Recommended Supabase conversation-state fields should be stored separately from high-volume raw message payloads.

Never persist secrets, card data, CVV, OTPs, API keys, or raw authentication credentials in conversation state.

## 15. Failure behavior

If state cannot be loaded or is inconsistent:
- fail closed for protected actions;
- preserve correlation ID;
- do not guess identity, ownership, cart, order scope, or action status;
- route to safe recovery/human escalation where appropriate.
