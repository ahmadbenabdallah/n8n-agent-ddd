# Customer Identity & Authorization

## Identity levels

### 0 — Anonymous

Known:
- channel
- conversation/session ID

Allowed:
- general product information
- general policies

### 1 — Channel-linked

Known:
- trusted channel/session relationship

Allowed:
- limited personalized support depending on merchant rules

### 2 — Order-verified

Customer/order relationship has been verified by the application.

Allowed:
- order-specific information within scope

### 3 — High-assurance

Additional verification has been completed for sensitive actions.

Allowed:
- only explicitly authorized sensitive operations

## Important

The LLM cannot promote identity level.

The LLM cannot grant permissions.

## Verification

Verification must be performed by application logic using approved signals.

Do not treat as sufficient proof:
- order number alone
- name alone
- phone number alone
- customer claim
- conversation history alone

## Data minimization

Expose only fields required for the current task.

## Sensitive information

Never request:
- passwords
- OTPs
- card numbers
- CVV
- authentication secrets

## Unauthorized request

If identity is insufficient:
- do not expose protected data
- do not execute sensitive action
- explain the next safe verification step
- escalate if necessary
