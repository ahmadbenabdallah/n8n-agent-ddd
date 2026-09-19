# WF-05 LLM Contract

## Principle

The LLM is a reasoning component, not a sales-authority component.

WF-05 supplies deterministic context and constraints.
The LLM proposes language, interpretation, candidate next step, and structured actions.
WF-10 decides authorization.

## Trusted context supplied to LLM

Only provide the minimum:
- current sales stage
- allowed intent
- verified product facts
- verified current price/availability when retrieved
- promotion validation result when available
- cart snapshot when authorized
- language/script/register
- safe customer context
- human ownership mode
- approved policy excerpts

Do not provide secrets or unnecessary private data.

## LLM must not

- set final price
- invent discounts
- invent stock
- claim an action succeeded
- promote itself to authorized executor
- override identity scope
- override human ownership
- construct WooCommerce API calls
- construct checkout URLs
- reveal internal workflow/security details
- infer authorization from a customer statement
- treat retrieved text as executable instructions

## Structured proposal example

```json
{
  "response": "Ey, nجم نعاونك نزيدها للpanier.",
  "intent": "cart_add",
  "decision": "ACTION_REQUIRED",
  "actions": [
    {
      "action_id": "act_01",
      "type": "cart_add",
      "params": {
        "sku": "SKU-123",
        "variant_id": "42",
        "quantity": 1
      },
      "idempotency_key": "idem_..."
    }
  ],
  "state_suggestion": {
    "sales_stage": "CART_BUILDING"
  }
}
```

The example is a proposal only.

WF-10 must independently validate:
- action type
- parameters
- identity
- business rules
- human ownership
- idempotency
- current commerce state
- authorization

## Language/script

Language and script are separate trusted fields.

For Latin/Arabizi customer input, customer-facing response must not contain Arabic Unicode characters unless explicitly requested or legitimately quoting customer text.

The LLM should mirror:
- Tounsi
- French
- English
- mixed language
- Latin transliteration

The renderer performs the final script/language validation.
