# Order data boundary

Customer message → identity contract → bounded query → commerce adapter → verified result → sanitized result → LLM explanation.

The LLM must never be given raw commerce payloads containing unnecessary private fields.

The LLM receives only the sanitized verified order result needed to answer the customer's request.

## Example

Customer: `win waslet commande 123?`

Bad:
- search arbitrary database using customer-supplied SQL
- disclose an order because the number exists
- return internal fulfillment notes

Good:
- verify customer identity
- scope lookup to that customer
- request only status/fulfillment/ETA
- verify owner match
- provide sanitized facts
