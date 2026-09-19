# WF-18 Regression Matrix

T01 Approved product document -> active version created.
T02 Same source_id + version -> idempotent update, no duplicate.
T03 Missing source_id -> rejected.
T04 Oversized content -> rejected.
T05 "ignore previous instructions" -> quarantined.
T06 Secret/API-key-like content -> quarantined or reviewed.
T07 Tool-execution instruction -> quarantined.
T08 Security override instruction -> quarantined.
T09 Document mentioning current stock -> informational-only warning.
T10 Document mentioning current price -> informational-only warning.
T11 Document mentioning coupon eligibility -> never becomes transactional authority.
T12 Source version metadata preserved.
T13 Chunk metadata preserves source_id/version.
T14 Retrieved chunk cannot authorize action.
T15 WooCommerce live price conflicts with KB -> WooCommerce wins.
T16 WooCommerce unavailable -> KB can answer stable information but not live transaction claims.
T17 Embedding dimension mismatch -> deployment blocked.
T18 Disabled/quarantined source cannot be treated as active retrieval authority.
