# WF-17 Idempotency

Event ingestion key:

`event_id`

Projection updates should be idempotent by:
- event_id;
- action_id for action projections;
- response_id for response delivery projections;
- case_id + lifecycle event for human case projections.

Duplicate events must not:
- double-count successful orders;
- double-count payments;
- create duplicate cases;
- inflate security incident counts;
- overwrite a newer state with an older event.

Use event timestamp plus monotonic sequence/version where ordering matters.
