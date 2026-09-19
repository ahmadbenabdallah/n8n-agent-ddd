# Dependency map

Approved KB Repository
        ↓
WF-18 KB Ingestion
        ├── security scan
        ├── chunking
        └── embeddings
        ↓
Supabase / pgvector
        ↓
WF-11 Product Service
        ↓
WF-09 LLM Reasoning

WF-17 Audit receives ingestion events.

Live price/stock/order/promotion facts remain outside the KB.
