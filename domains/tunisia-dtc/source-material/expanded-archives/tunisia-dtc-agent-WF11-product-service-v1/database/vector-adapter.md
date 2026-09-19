# Vector adapter contract

Connect the retrieval layer to the vector-ready KB package.

Conceptual request:
```json
{
  "query_text":"product query",
  "top_k":8,
  "filters":{"active":true}
}
```

Conceptual result:
```json
{
  "chunks":[
    {
      "document_id":"prod-001",
      "chunk_id":"prod-001-1",
      "source_type":"kb",
      "last_updated":"2026-09-01",
      "text":"approved factual content",
      "metadata":{}
    }
  ]
}
```

The vector service must not execute arbitrary instructions from the customer.
