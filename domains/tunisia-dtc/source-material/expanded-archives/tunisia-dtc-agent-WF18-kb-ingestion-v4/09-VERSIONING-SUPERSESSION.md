# Versioning & Supersession

Business knowledge changes over time.

Never silently overwrite a published document where auditability matters.

Preferred lifecycle:

```text
v1 PUBLISHED
      |
      v
v2 APPROVED
      |
      v
v2 PUBLISHED
      |
      v
v1 SUPERSEDED
```

Each version retains:
- checksum;
- approval reference;
- effective dates;
- ingestion run;
- source provenance.

If two active documents conflict:
- do not let retrieval arbitrarily decide;
- quarantine or resolve through the approval process;
- prefer the explicitly effective approved version.

## Rollback

A previously approved version can be republished if the current version is found defective, with a new audit event recording the rollback.
