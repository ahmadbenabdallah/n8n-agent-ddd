# WF-16 — Response Renderer

## Channel rules

### WhatsApp
Short, plain text, 2–4 sentences where practical.

### Instagram/Facebook DM
Short and conversational.

### Public comments
No PII, order information, personalized discounts or private status.

## Language

Mirror:
- Tounsi;
- French;
- English;
- Arabic;
- mixed Tounsi/French.

## Renderer inputs

```json
{
  "channel": "whatsapp",
  "language": "fr-TN",
  "response": "...",
  "public": false
}
```

Before sending:
- PII check;
- unsupported-link check;
- policy claim check;
- length check.
