# WF-06 Support Engine — Production Specification v4

## 1. Purpose

WF-06 is the support-business-logic workflow for customer questions and post-purchase service.

It determines:
- what support policy applies
- what factual source is required
- whether a safe response is possible
- whether another workflow must be invoked
- whether human escalation is mandatory

It does not authorize protected operations.

## 2. Supported support intents

```text
shipping
payment
order_status
return_exchange
complaint
payment_dispute
human_request
safety
security_suspicion
```

Additional generic support questions may be routed here when they are not sales-specific.

## 3. Source authority

For current operational facts:

1. verified transactional result
2. current approved policy
3. current approved product document
4. approved FAQ
5. otherwise do not guess

Live order status, payment status, current fulfillment information and other transactional facts must come from authorized systems.

## 4. Support decision model

```text
Inbound support intent
        ↓
Load WF-03 state
        ↓
Human ownership check
        ↓
Privacy / identity check
        ↓
Support policy classification
        ↓
Required evidence decision
        ↓
KB or live service retrieval
        ↓
LLM explanation (if needed)
        ↓
WF-10 authorization for consequential action
        ↓
Downstream service
        ↓
Post-verification
        ↓
WF-16 renderer
```

## 5. Shipping

WF-06 may answer shipping questions from approved policy/KB.

For an order-specific shipping/status question:
- route to WF-07
- require appropriate order scope
- retrieve fresh order information
- return only minimum necessary fields

Never infer delivery status from an old conversation.

## 6. Payment

WF-06 can explain approved payment methods and policy.

Payment status for a specific order must come from the authoritative commerce/transaction system.

Never claim:
- payment received
- payment failed
- refund completed
- payment reversed
unless verified by the relevant backend result.

Never request or process:
- card numbers
- CVV
- OTP
- PIN
- passwords
- payment secrets

## 7. Returns and exchanges

WF-06:
1. identify the policy category
2. retrieve current approved return/exchange policy
3. determine whether order-specific facts are needed
4. route to WF-07 for authorized order context
5. escalate when policy or condition requires human review

Do not promise eligibility when required facts are missing.

Do not invent exceptions.

## 8. Complaints

Complaint flow:

```text
acknowledge
→ classify
→ gather minimum necessary facts
→ apply approved policy
→ resolve safely if deterministic
→ escalate if required
```

Escalate for:
- serious unresolved complaint
- damaged/defective claim requiring review
- safety concern
- legal threat
- repeated failed resolution
- customer explicitly requests human support

Do not diagnose product safety or legal matters.

## 9. Payment disputes

Payment disputes/chargebacks are mandatory escalation conditions.

WF-06 may:
- acknowledge
- collect minimum non-sensitive context
- create/route a human case through WF-08

WF-06 must not:
- promise a refund
- admit liability
- change payment status
- cancel a transaction
- negotiate a chargeback outcome without an approved human/business process

## 10. Safety

For product safety concerns:
- prioritize immediate safe guidance from approved policy
- do not provide unsupported medical/technical diagnosis
- stop unsafe automation
- escalate to human review

## 11. Security suspicion

Examples:
- customer reports account/order activity they did not perform
- suspected unauthorized transaction
- suspicious request for another person's order
- suspected data exposure

Response:
- avoid exposing protected details
- restrict further protected operations
- create escalation case when required
- preserve security event for audit

## 12. Human ownership

WF-03 is authoritative for:

```text
conversation_owner
automation_mode
case_id
human_owner_id
escalation_status
```

If:

```text
conversation_owner = HUMAN
automation_mode = PAUSED
```

WF-06 must not independently resolve the active case or perform conflicting consequential actions.

If:

```text
automation_mode = SAFE_ONLY
```

WF-06 may provide explicitly permitted safe acknowledgement/routing, but protected operations still require the normal authorization path.

## 13. Dynamic acknowledgement

Operational acknowledgement is separate from the final factual answer.

Allowed controlled states:

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

WF-06 may select the acknowledgement state.
The renderer uses approved templates.

The LLM must not fabricate operational claims such as:
- “I checked your order”
- “your refund is processing”
- “your payment is confirmed”

unless the corresponding verified backend result exists.

## 14. Public channels

For public comments:
- do not expose order details
- do not expose phone/address
- do not expose payment information
- do not expose private customer data

Redirect order-specific matters to private DM.

## 15. Support response pattern

For ordinary support:

```text
1. acknowledge
2. answer from verified source
3. state limitation if required
4. provide next step
```

For unresolved support:

```text
1. acknowledge
2. explain what is known
3. avoid guessing
4. hand off when required
```

## 16. Failure behavior

Fail closed for:
- missing required evidence
- identity conflict
- expired/revoked order scope
- human ownership conflict
- policy conflict
- security-sensitive uncertainty
- unavailable transactional source for a live fact

Never substitute guessed data for unavailable live data.
