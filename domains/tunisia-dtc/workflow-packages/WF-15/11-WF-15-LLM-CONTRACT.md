# WF-15 LLM Contract

WF-09 may consume verified payment/transaction facts.

The LLM cannot:
- mark a transaction paid;
- infer payment from order creation;
- infer successful card authorization from customer wording;
- fabricate transaction IDs;
- expose payment secrets;
- override a `PENDING`, `FAILED`, `UNKNOWN` or reconciliation state.

Customer-facing claims must be based on the latest verified authoritative result.
