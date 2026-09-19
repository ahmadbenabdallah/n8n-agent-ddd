# Language / Script Metadata

Language and script remain separate.

Example:

```json
{
  "language": "tn",
  "script": "latin",
  "register": "casual"
}
```

KB language does not dictate customer response language.

A French policy may be retrieved to support a Tunisian customer response, provided the underlying business fact is relevant and approved.

The response renderer (WF-16) remains responsible for final customer-facing language/script enforcement.

Do not use Unicode/script metadata as a security boundary by itself.
