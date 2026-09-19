# Tunisia DTC Agent — WF-18 Knowledge Base Ingestion v4

Production implementation package for **WF-18 Knowledge Base Ingestion**.

Core invariant:

> **WF-18 controls what becomes trusted static knowledge; it never turns static KB content into live commerce truth.**

WF-18 ingests, validates, versions, chunks, embeds, indexes, publishes, retires, and monitors approved knowledge for the Tunisia DTC agent.

Architecture:
- Source documents → validation → normalization → classification → chunking → metadata → embeddings → pgvector → retrieval
- Supabase + pgvector are the initial RAG persistence layer.
- Live commerce facts remain authoritative in WooCommerce through WF-20 and the relevant service workflows.
- Customer/retrieved text is never allowed to override system policy, authorization, identity, or security controls.
