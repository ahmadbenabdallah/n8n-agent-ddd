# Tunisia DTC Agent — WF-17 Audit & Analytics v4

Production implementation package for **WF-17 Audit & Analytics**.

Core invariant:

> **WF-17 records and analyzes what happened; it never authorizes, executes, or grants permission.**

WF-17 is the audit/observability boundary for the full agent system.

It must provide:
- immutable-ish structured audit events;
- security/audit trail;
- action lifecycle correlation;
- identity and order-scope auditability;
- human-handoff auditability;
- commerce execution/reconciliation visibility;
- LLM proposal telemetry;
- renderer/delivery telemetry;
- operational analytics;
- anomaly detection inputs;
- retention/redaction controls.

WF-17 is explicitly **not** an authorization boundary. WF-10 remains the sole authorization boundary and WF-20 remains the sole privileged WooCommerce integration boundary.
