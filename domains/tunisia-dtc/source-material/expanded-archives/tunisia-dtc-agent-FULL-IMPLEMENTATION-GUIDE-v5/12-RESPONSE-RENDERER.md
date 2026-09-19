# WF-16 Response Renderer

## Position
WF-16 is the final customer-facing trust boundary.

## Inputs
Only verified facts:
- verified product data;
- verified availability;
- verified price;
- verified promotion result;
- verified cart result;
- verified checkout result;
- verified order status;
- verified human ownership state.

## Rendering rules

Never render:
- unverified action success;
- internal IDs;
- secrets;
- stack traces;
- private order details without scope;
- invented operational acknowledgements.

## Language/script

Keep language and script separate.

Example:
```json
{
  "language": "tn",
  "script": "latin",
  "register": "casual",
  "mixed_languages": ["tn", "fr"]
}
```

If the customer uses Latin/Arabizi, the customer-facing response should contain no Arabic Unicode unless explicitly requested or a legitimate quote requires it.

## Unknown execution

Use a reconciliation-safe response. Do not claim:
- “order created”
- “cart updated”
- “payment completed”
until verification confirms it.

## Human-owned case

Renderer must respect:
`HUMAN_REQUESTED`, `HUMAN_ASSIGNED`, `HUMAN_IN_PROGRESS`.

Operational acknowledgement must reflect actual system state.
