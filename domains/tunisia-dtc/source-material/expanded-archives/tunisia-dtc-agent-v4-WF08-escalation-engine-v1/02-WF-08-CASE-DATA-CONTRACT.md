# WF-08 Human Case Data Contract

## Case object

```json
{
  "case_id": "case_123",
  "conversation_id": "conv_123",
  "customer_id": "cust_123",
  "channel": "facebook_messenger",
  "status": "HUMAN_REQUESTED",
  "priority": "HIGH",
  "reason_code": "PAYMENT_DISPUTE",
  "risk_level": "HIGH",
  "conversation_owner": "AI",
  "automation_mode": "SAFE_ONLY",
  "human_owner_id": null,
  "created_at": "timestamp",
  "assigned_at": null,
  "first_human_response_at": null,
  "resolved_at": null,
  "closed_at": null,
  "sla_deadline": "timestamp",
  "state_version": 1
}
```

## Reason codes

```text
SAFETY
PAYMENT_DISPUTE
CHARGEBACK
LEGAL_THREAT
SERIOUS_COMPLAINT
DAMAGED_DEFECTIVE_REVIEW
IDENTITY_UNCERTAINTY
UNAUTHORIZED_ACTIVITY
SECURITY_INCIDENT
REPEATED_FAILURE
EXPLICIT_HUMAN_REQUEST
OPERATIONAL_FAILURE
```

## Minimum customer data

Prefer:
- customer_id
- conversation_id
- channel identity reference
- case reason
- risk/priority
- minimum context required for the human to resolve the issue

Do not copy full conversation history into every case record unnecessarily.

## Sensitive data

Do not store:
- card PAN
- CVV
- OTP
- passwords
- API keys
- WooCommerce secrets
- authentication tokens
- Cart-Tokens
- nonce tokens

## Ownership invariants

At most one active human owner per case.

At most one active ownership state per conversation.

Case and conversation state must not contradict each other.
