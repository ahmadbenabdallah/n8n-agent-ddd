# Language & Script Rendering Policy

Language and script are independently validated.

Canonical example:

```json
{
  "language": "tn",
  "script": "latin",
  "register": "casual",
  "mixed_languages": ["tn", "fr"]
}
```

## Latin / Arabizi

When `script=latin`, final customer-visible text must contain no Arabic Unicode characters unless:
- the customer explicitly requested Arabic script; or
- a legitimate short quote must be preserved.

Example:
- Input: `Ok zidhali taille 42 lel panier.`
- Output should remain Latin/Arabizi/Tunisian style, not switch to Arabic script.

## Arabic script

When `script=arabic`, Arabic Unicode is allowed.

## French / English

Use the requested language unless deterministic policy requires clarification.

## Validation

Renderer checks:
- language consistency;
- script consistency;
- forbidden Unicode/script mismatch;
- register constraints;
- accidental internal terminology.

On failure:
1. retry wording transformation if configured;
2. otherwise use a deterministic safe template in the requested script.
