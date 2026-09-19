# WF-19 Regression Matrix

T01 Health request -> bounded checks created.
T02 Invalid operation -> rejected.
T03 Invalid scope -> rejected.
T04 Duplicate run_id -> single maintenance record.
T05 WooCommerce outage -> degraded/pending state and alert signal.
T06 Database outage -> no fabricated healthy state.
T07 Transaction verification failure -> high-severity signal.
T08 Duplicate order detection -> critical signal.
T09 Security exposure signal -> critical/high signal without payload leakage.
T10 KB freshness failure -> knowledge alert.
T11 Quarantined KB source -> security/knowledge signal.
T12 n8n failure spike -> workflow reliability signal.
T13 Cleanup cannot remove active transaction evidence.
T14 Maintenance output contains no credentials/tokens.
T15 Maintenance event cannot authorize a commerce action.
