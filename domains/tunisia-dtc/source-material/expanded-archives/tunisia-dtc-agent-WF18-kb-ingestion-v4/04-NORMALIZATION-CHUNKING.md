# Normalization & Chunking

## Normalization

Before embedding:
- remove accidental duplicated content;
- normalize whitespace;
- preserve headings;
- preserve lists and tables where meaningful;
- normalize Unicode carefully;
- preserve business terminology;
- remove secrets;
- remove irrelevant navigation boilerplate;
- retain source references.

Do not silently rewrite business meaning.

## Chunking

Chunks should be semantically coherent.

Recommended metadata:
- document_id;
- version;
- chunk_id;
- heading path;
- source_type;
- tenant_id;
- language;
- script;
- effective dates;
- sensitivity;
- content hash.

Avoid chunks that mix unrelated policies.

For policy documents, preserve enough context for exceptions and conditions.

For product documentation, preserve product/variation references where necessary.

## Chunk integrity

A chunk must be traceable back to:
`document_id + version + content_hash`.
