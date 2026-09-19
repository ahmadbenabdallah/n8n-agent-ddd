# WF-09 — LLM Reasoning

## Inputs

Only provide:
- canonical customer message;
- bounded conversation history;
- conversation state;
- authorized capabilities;
- relevant business rules;
- approved retrieval results;
- verified tool results.

## Output

```json
{
  "response": "...",
  "language": "fr-TN",
  "intent": "product_question",
  "sales_stage": "CONSIDERING",
  "actions": [],
  "sources": ["product-001"],
  "requires_human": false,
  "escalation_reason": null,
  "claims_grounded": true
}
```

## Critical rule

The LLM output is an untrusted proposal. It must pass the action validator before any tool executes.
