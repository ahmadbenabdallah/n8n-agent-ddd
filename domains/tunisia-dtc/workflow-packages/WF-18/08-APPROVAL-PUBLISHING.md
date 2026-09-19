# Approval & Publishing

Recommended lifecycle:

```text
DRAFT
 -> REVIEW
 -> APPROVED
 -> PUBLISHED
```

Publishing requires:
- source owner;
- reviewer or approved automated policy where explicitly permitted;
- content hash;
- classification;
- version;
- effective dates;
- security scan;
- validation results.

A generated summary must not replace the source for high-risk policy facts unless explicitly approved.

Superseding a document should preserve historical versions for audit/rollback.
