# WF-11 — Product Service

WF-11 is the product factual/retrieval boundary.

It separates:
- approved static product facts from the KB;
- live transactional facts such as current price, stock and promotion;
- customer-controlled text.

The workflow does not execute cart/checkout actions.

## Position

WF-05 / WF-09 → **WF-11 Product Service** → WF-09 / WF-10 / WF-16.

For vector retrieval, connect the bounded query to the Supabase pgvector RPC from the vector-ready KB package. The `retrieval_result` object expected by this workflow is deliberately structured so raw vector/database payloads do not flow directly into the LLM.
