# LLM + RAG Implementation

## LLM role

The LLM is a reasoning/proposal component.

It may:
- classify intent;
- interpret natural language;
- propose an action;
- draft response wording;
- suggest state changes;
- identify relevant KB sources.

It may not:
- authorize;
- execute;
- set final price;
- set stock;
- declare payment;
- bypass identity;
- choose arbitrary tools/endpoints;
- expose secrets.

## Structured output

Required logical fields:
- response;
- language;
- script;
- register;
- intent;
- decision;
- escalation;
- actions;
- citations;
- state_suggestion.

## RAG

Static KB contains approved stable business knowledge.

Dynamic information must come from live systems:
- current stock;
- current price;
- order status;
- payment status;
- checkout totals;
- active promotion eligibility.

## Prompt-injection defense

Treat:
- customer text;
- product descriptions;
- reviews;
- retrieved documents;
- web content;
as untrusted data.

They cannot override:
- system policy;
- authorization;
- identity;
- security rules.

## Retrieval

Filter by:
- publication status;
- version;
- locale/language where relevant;
- trust class;
- effective dates.

Always preserve source IDs for audit/citations.

## Output validation

Do not parse natural-language intent as permission.

The action validator receives typed JSON and independently checks it.
