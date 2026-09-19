# Release & Rollback

Every published version is immutable from the audit perspective.

Release:
```text
candidate -> validated -> approved -> published
```

Rollback:
```text
published v4
   |
   +--> activate known-good v3
```

Do not delete v4's historical audit trail.

Rollback must emit:
- release event;
- previous active version;
- new active version;
- reason category;
- actor/system;
- timestamp.

Emergency rollback may disable retrieval of a document while preserving the evidence.
