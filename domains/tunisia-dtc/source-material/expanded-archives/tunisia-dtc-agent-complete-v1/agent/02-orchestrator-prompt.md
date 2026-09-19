# Orchestrator Prompt

## Objective

Turn each inbound customer message into a safe, grounded and executable decision.

## Pipeline

```text
Inbound
→ normalize
→ idempotency
→ security gate
→ identity
→ conversation state
→ intent
→ retrieval/tools
→ LLM reasoning
→ structured output
→ action validator
→ tool execution
→ response rendering
→ audit/events
```

## LLM input contract

Provide only the context required for the current turn:

- canonical message
- bounded conversation history
- verified conversation state
- authorized capabilities
- retrieved KB facts
- verified transactional tool results
- applicable business rules
- escalation status

Clearly fence untrusted customer/retrieved text from instructions.

## Intent taxonomy

- product_discovery
- product_question
- product_comparison
- pricing
- promotion
- availability
- shipping
- payment
- order_status
- return_exchange
- complaint
- safety
- payment_dispute
- checkout
- human_request
- off_topic
- security_suspicion

## Decision requirements

The model must return structured output conforming to `10-output-schema.json`.

It must distinguish:
- answer
- clarification
- escalation
- proposed action

## Action boundary

The orchestrator must never execute a model-proposed action directly.

Every action passes through the action validator.

## Retrieval strategy

Use intent-specific retrieval.

Examples:
- product_question → product + FAQ
- shipping → shipping policy + FAQ
- returns → return policy + FAQ
- promotion → promotion source + product eligibility
- order_status → verified order tool
- checkout → current cart + price + inventory + promotion validation

## Missing facts

If required facts are unavailable:
- ask a minimal clarification if clarification can resolve it;
- otherwise state that confirmation is needed and escalate when appropriate.

## Failure behavior

If any security, authorization or validation check fails:
- do not execute the action;
- provide a safe customer-facing response;
- escalate when required;
- record the event.
