# Node-by-node configuration

1. Trigger — receives product-related request.
2. Validate Product Input — canonical input gate.
3. Product Input Valid? — fail closed.
4. Fail Closed — blocks malformed requests.
5. Product Intent Gate — allowlists supported product intents.
6. Product Intent? — routes non-product requests away.
7. Route Non-Product — no retrieval.
8. Build Bounded Product Query — query text + explicit filters + bounded top_k.
9. Retrieval Security Check — rejects obvious secret/system-prompt requests.
10. Retrieval Safe? — fail-closed retrieval gate.
11. Block Unsafe Retrieval — no KB access.
12. Normalize Retrieval Result — allowlists source/chunk/text metadata and truncates chunk text.
13. KB Trust + Poison Check — treats retrieved text as untrusted data and detects instruction-like poisoning.
14. Trusted Retrieval? — trust gate.
15. Block Poisoned Retrieval — no facts forwarded.
16. Build Product Fact Contract — creates factual evidence and identifies live-fact needs.
17. Live Fact Required? — pricing/promotion/availability require live verification.
18. Request Live Product Check — signals a live service lookup.
19. KB Facts Sufficient — static facts only.
20. Build Product Service Contract — downstream contract.

## Supabase vector integration

Recommended input/output boundary:

`retrieval_query → match_kb_chunks() → retrieval_result.chunks[]`

Each chunk should contain:
`document_id`, `chunk_id`, `source_type`, `last_updated`, `text`, `metadata`.

Do not pass arbitrary SQL, table names, RPC names, or embedding vectors supplied by the customer.
