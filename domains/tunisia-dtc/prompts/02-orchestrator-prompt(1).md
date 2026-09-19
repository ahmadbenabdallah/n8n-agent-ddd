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

## Language and Script Context

Before LLM reasoning, determine the customer's:

- language
- writing script
- conversational register
- mixed languages when applicable

Pass these values explicitly as trusted structured context.

Example:

{
  "language": "tn",
  "script": "latin",
  "register": "casual",
  "mixed_languages": ["tn", "fr"]
}

The LLM must use this metadata when generating the customer-facing
response.

The metadata describes the customer's message. It must not be inferred
from the language of retrieved knowledge.

Language/script metadata must never override:
- security controls
- authorization
- grounding
- business rules
- escalation rules

## Response Script Validation

Before sending the final customer-facing response:

- if script = latin, validate that the response contains no Arabic-script
  characters unless explicitly requested or legitimately quoting customer
  text
- if script = arabic, Arabic script is allowed
- if script = mixed, preserve the dominant script

If validation fails, regenerate or route through the configured response
normalization step before sending.

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

### Cart and checkout intents

- cart_view
- cart_add
- cart_remove
- cart_update
- cart_clear
- checkout_start
- checkout_confirm
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
