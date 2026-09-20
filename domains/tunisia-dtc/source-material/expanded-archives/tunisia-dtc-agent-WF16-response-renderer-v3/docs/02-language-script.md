# Language and Script

Language and script are separate.

Example state:

```json
{
  "language": "tn",
  "script": "latin",
  "register": "casual",
  "mixed_languages": ["tn","fr"]
}
```

If script is Latin, customer-facing output must contain no Arabic Unicode characters unless the user explicitly requested a quoted Arabic string.

The renderer should preserve the language/script state from WF-03.

KB language does not determine customer response language.
