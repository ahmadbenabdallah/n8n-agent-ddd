# Audit & Observability

## Audit event lifecycle

Record:
- request received;
- security decision;
- identity decision;
- intent;
- LLM proposal;
- authorization decision;
- execution attempt;
- execution result;
- verification;
- response;
- escalation;
- human ownership;
- errors;
- reconciliation.

## Event fields

At minimum:
- event_id;
- event_type;
- timestamp;
- conversation_id;
- channel;
- customer_id where allowed;
- intent;
- language;
- source_ids;
- action_id;
- action_type;
- authorization_result;
- security_flags;
- success;
- metadata.

## Metrics

Track:
- response latency;
- LLM latency;
- authorization rejection rate;
- action success rate;
- unknown execution rate;
- reconciliation rate;
- escalation rate;
- human takeover time;
- webhook failure rate;
- WooCommerce error rate;
- stale-data incidents;
- KB retrieval quality indicators.

## SLO examples

Define target values per production volume rather than copying arbitrary defaults.

Alert on:
- sustained workflow failures;
- elevated unknown execution;
- security spikes;
- stuck human cases;
- webhook outage;
- WooCommerce degradation;
- KB ingestion failures.
