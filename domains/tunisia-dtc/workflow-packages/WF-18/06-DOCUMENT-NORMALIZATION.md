# Document Normalization

Normalize before chunking:

- encoding;
- whitespace;
- headings;
- tables;
- repeated headers/footers;
- OCR artifacts;
- language metadata;
- document version;
- effective dates.

Do not silently change business meaning.

If extraction changes or loses important content:
- mark ingestion as degraded;
- quarantine when required;
- require review before publication.

Preserve original source reference so a reviewer can trace every production chunk back to its source.
