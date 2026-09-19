# Requirements

- n8n
- WF-09 LLM Reasoning or a dedicated rendering LLM call
- verified facts/contracts from service workflows
- channel metadata
- language/script metadata
- final Meta/Messenger sender workflow

## LLM boundary

The renderer LLM receives:
- customer-safe verified facts
- intent/goal
- language/script/register
- verified action result

It must NOT receive:
- system prompts
- credentials
- internal security signals
- raw payment secrets
- unrelated customer records

## Production recommendation

Use structured output:
{
  "text": "customer-facing message",
  "language": "tn",
  "script": "latin"
}

Then run deterministic validators before sending.
