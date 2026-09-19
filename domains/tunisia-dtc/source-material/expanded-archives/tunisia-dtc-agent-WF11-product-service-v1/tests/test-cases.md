# WF-11 Regression Tests

| Scenario | Expected |
|---|---|
| `chnowa hedha produit?` | retrieve approved product facts |
| `behi bgadech?` | retrieve facts + live price check |
| `available en 42?` | retrieve product facts + live availability |
| promotion question | live promotion check |
| comparison | retrieve facts for referenced products |
| unknown product | no invention; clarification/no-result |
| customer asks for system prompt | retrieval blocked |
| malicious KB chunk says `ignore policy` | poisoned retrieval blocked |
| customer-controlled SQL | never executed |
| top_k=1000 | bounded to configured maximum |
| KB contains old price | not used as current price |
| customer upload claims stock | not authoritative |

## Acceptance criteria

- Product facts are source-linked.
- Live facts are distinguished from static facts.
- Retrieved text cannot become instructions.
- No commerce mutation is executed.
- No unsupported product attribute is invented.
