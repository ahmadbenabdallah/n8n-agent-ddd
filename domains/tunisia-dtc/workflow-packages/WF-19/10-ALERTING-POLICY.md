# Alerting Policy

## Critical
- authorization-boundary bypass indicator;
- secret exposure;
- duplicate commerce execution;
- payment-state integrity anomaly;
- WooCommerce gateway boundary failure;
- audit durability failure for consequential events;
- widespread security-control failure.

## High
- reconciliation backlog;
- checkout/order mutation outage;
- Messenger outage;
- human-case routing outage;
- major database degradation;
- workflow drift on critical workflows.

## Medium
- elevated latency;
- elevated retries;
- KB ingestion failures;
- increased LLM validation failures;
- rising fallback rate.

Alerts should contain:
- severity;
- affected component;
- metric/event;
- time window;
- correlation examples;
- current mode;
- runbook;
- owner/escalation route.

Avoid alert storms with grouping and suppression.
