# WF-18 Knowledge Base Ingestion

## Source lifecycle

```text
REGISTER
→ FETCH
→ NORMALIZE
→ CHUNK
→ QUALITY CHECK
→ EMBED
→ INDEX
→ REVIEW
→ PUBLISH
```

## Trust classes

Use explicit source trust categories and publication status.

## Poisoning controls

Quarantine content that:
- contains instruction-like payloads;
- attempts to alter system behavior;
- contains unsupported claims;
- conflicts with approved policy;
- has suspicious metadata;
- is outside its effective date.

## Versioning

Every published document must have:
- source_id;
- version;
- effective date;
- status;
- provenance.

Rollback means changing publication state to a known-good version, not deleting history.

## Static vs dynamic

Static KB:
- policies;
- approved product documentation;
- FAQs;
- brand voice;
- shipping policy.

Live systems:
- stock;
- price;
- order status;
- payment status;
- active promotion eligibility;
- checkout totals.
