# Node-by-node configuration

1. **Execute Workflow Trigger** — internal/scheduled ingestion.
2. **Validate KB Ingestion Input** — requires documents.
3. **Documents Present?** — fail closed.
4. **Reject Empty Ingestion**.
5. **Normalize Documents** — canonical path/content/hash.
6. **Parse and Validate Frontmatter** — requires `id`, `type`, `last_updated`.
7. **Metadata Valid?**.
8. **Reject Invalid KB Metadata**.
9. **KB Poisoning and Injection Scan** — checks common instruction/tool/prompt-injection indicators.
10. **KB Security Check Passed?**.
11. **Quarantine Suspicious KB**.
12. **Chunk KB Documents** — 900-character chunks with 120-character overlap.
13. **Prepare Embedding Job** — default `text-embedding-3-small`, 1536 dimensions.
14. **Receive Embeddings** — adapter boundary.
15. **Build Supabase Vector Upsert Payload** — document + chunk rows.
16. **Build KB Ingestion Contract**.

## Embedding adapter

Insert OpenAI/HTTP/connector node between `Prepare Embedding Job` and `Receive Embeddings`.

Return:
`{ embeddings: [[...],[...],...] }`

Embedding count must equal chunk count.

## Persistence adapter

Insert Supabase/Postgres node or Execute Workflow between `Build Supabase Vector Upsert Payload` and the final contract. Upsert documents and chunks transactionally where possible.
