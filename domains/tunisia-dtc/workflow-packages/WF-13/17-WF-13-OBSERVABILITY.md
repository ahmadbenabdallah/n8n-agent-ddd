# WF-13 Observability

Track:
- validation requests;
- valid/invalid outcomes;
- reason-code distribution;
- latency;
- commerce errors/timeouts;
- revalidation frequency;
- checkout promotion mismatches;
- suspicious repeated coupon attempts.

Do not log:
- credentials;
- payment secrets;
- unnecessary customer PII;
- internal sensitive promotion metadata.

Security anomalies should feed WF-17 and operational handling through WF-19.
