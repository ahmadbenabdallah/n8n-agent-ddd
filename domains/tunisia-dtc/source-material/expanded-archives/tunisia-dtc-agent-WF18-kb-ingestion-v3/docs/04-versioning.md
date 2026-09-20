# Versioning

Every KB source must have:
- stable `source_id`
- explicit `version`
- source type
- status
- security flags
- ingestion timestamp

Retrieval metadata should include source_id/version so WF-17 can audit which corpus version supported an answer.

Never silently overwrite an active source without creating a traceable version.
