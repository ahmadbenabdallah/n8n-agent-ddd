# Normalization & Chunking

Pipeline:

```text
raw source
 -> encoding normalization
 -> HTML/markup cleanup
 -> boilerplate removal
 -> language/script detection
 -> section extraction
 -> semantic chunking
 -> metadata enrichment
 -> content hash
```

Each chunk should retain:
- source_id;
- document version;
- section/heading;
- language;
- script;
- classification;
- content hash;
- chunk index;
- effective/expiry dates;
- approval status.

Avoid chunking that destroys policy qualifiers, conditions, exceptions, or tables.

Never remove negations or conditions during normalization.
