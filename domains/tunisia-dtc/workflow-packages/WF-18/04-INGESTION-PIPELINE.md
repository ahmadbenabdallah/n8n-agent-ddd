# WF-18 Ingestion Pipeline

```text
source registered
      |
      v
checksum / duplicate detection
      |
      v
format + encoding validation
      |
      v
malware / unsafe-file screening
      |
      v
content extraction
      |
      v
normalization
      |
      v
classification
      |
      v
policy / poisoning scan
      |
      v
metadata validation
      |
      v
chunking
      |
      v
embedding
      |
      v
staging index
      |
      v
quality validation
      |
      v
approval gate
      |
      v
production index
      |
      v
audit event
```

A failed quality/security gate cannot publish to production.
