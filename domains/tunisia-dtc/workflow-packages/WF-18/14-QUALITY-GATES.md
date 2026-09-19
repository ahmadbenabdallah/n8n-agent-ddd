# Knowledge Quality Gates

Minimum checks before publication:

## Structural
- document parsed;
- encoding valid;
- required metadata present;
- source/version/checksum present.

## Content
- no major extraction corruption;
- headings preserved;
- tables preserved where necessary;
- no empty/duplicate chunks beyond configured tolerance.

## Policy
- source is approved;
- effective date valid;
- supersession rules resolved;
- no conflicting active policy.

## Security
- prompt injection scan passed;
- suspicious instructions quarantined;
- secrets/credentials removed;
- untrusted provenance blocked.

## Retrieval
- embeddings generated;
- vector dimensions match configured model;
- sample retrieval tests pass;
- provenance returned.

Only passing documents can move to `PUBLISHED`.
