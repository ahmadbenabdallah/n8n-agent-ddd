# Sales decision table

| Condition | Decision |
|---|---|
| Sales intent + sufficient context | continue |
| Sales intent + missing required context | clarification |
| Cart mutation + no product/cart context | clarification |
| Checkout confirmation | propose confirmation; never mark purchased |
| Product question | retrieve approved facts |
| Pricing | retrieve current authorized price |
| Promotion | use promotion service; never invent discount |
| Availability | use product/inventory service |
| Comparison | retrieve facts for both products; no fabricated winner |
| Non-sales intent | return to router / support / escalation |
| Invalid upstream contract | fail closed |
