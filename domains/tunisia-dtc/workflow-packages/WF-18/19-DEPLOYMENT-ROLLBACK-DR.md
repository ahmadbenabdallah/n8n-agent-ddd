# Deployment, Rollback & Disaster Recovery

## Deployment

- version parser;
- version chunker;
- version embedding model;
- run staging ingestion;
- run retrieval evaluation;
- approve;
- publish.

## Rollback

If a published KB version is defective:
1. stop publication;
2. mark defective version quarantined/retired;
3. restore previous approved version;
4. invalidate affected retrieval cache if applicable;
5. emit rollback audit event;
6. run regression retrieval tests.

## Disaster recovery

Back up:
- source metadata;
- document versions;
- approval records;
- chunk metadata;
- vector index/rebuild inputs.

Because embeddings can be regenerated, source/version integrity is more important than treating the vector index as the only copy.
