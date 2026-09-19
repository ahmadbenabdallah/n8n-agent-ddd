# n8n Implementation — WF-18

Recommended workflow:

```text
Trigger
 -> Register Source
 -> Checksum
 -> Validate File/Format
 -> Extract Content
 -> Normalize
 -> Classify
 -> Security/Poisoning Scan
 -> Metadata Validation
 -> Chunk
 -> Embed
 -> Write Staging Index
 -> Quality Checks
 -> Approval Gate
 -> Publish / Quarantine
 -> Audit
```

For batch ingestion:
- use an ingestion run ID;
- make every chunk traceable to its source/version;
- make reruns idempotent;
- do not partially publish an unvalidated document.

For embedding failures:
- preserve source/document status;
- retry bounded times;
- do not mark publication successful.

Do not connect WF-18 directly to customer-facing channels.
