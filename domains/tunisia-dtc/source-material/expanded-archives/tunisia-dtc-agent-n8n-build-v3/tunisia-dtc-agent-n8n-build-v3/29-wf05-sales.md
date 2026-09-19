# WF-05 — Sales Engine

## State machine

```text
BROWSING
 → DISCOVERY
 → PRODUCT_INTEREST
 → CONSIDERING
 → PRODUCT_SELECTED
 → CART_BUILDING
 → CHECKOUT_READY
 → PURCHASED
```

## Nodes

1. `STATE — Read`
2. `RAG — Sales Knowledge`
3. `EXECUTE — Product Search`
4. `SET — Candidate Facts`
5. `LLM — Recommendation Explanation`
6. `VALIDATE — Claims`
7. `STATE — Update`
8. `ANALYTICS — Recommendation Event`

## Recommendation rule

The product engine supplies candidate facts. The LLM may explain:
- why it matches;
- relevant differences;
- what to consider.

The LLM may not invent:
- stock;
- price;
- reviews;
- scarcity;
- performance claims.

## Tunisia conversation

If customer says:

`nheb haja behya lel chita ama ma tkounch th9ila`

the agent should extract:
- use case: winter;
- weight preference: light/medium;
then retrieve products rather than guessing.
