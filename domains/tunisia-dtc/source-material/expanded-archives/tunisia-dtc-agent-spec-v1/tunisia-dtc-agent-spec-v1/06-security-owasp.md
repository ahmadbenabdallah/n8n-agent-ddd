# Security Policy --- OWASP GenAI / LLM Top 10

This agent uses the latest OWASP GenAI Security Project guidance as the
security baseline. The OWASP project currently identifies a 2026 Top 10
as its latest initiative while retaining the named LLM01--LLM10
workstreams. The implementation must be reviewed whenever OWASP
publishes a new revision.

## LLM01 --- Prompt Injection

Controls: - trust-boundary separation; - untrusted-data fencing; - tool
allowlists; - deterministic authorization; - output validation; -
indirect-injection tests.

## LLM02 --- Sensitive Information Disclosure

Controls: - field-level access; - verified identity; - tenant/customer
isolation; - PII redaction; - no prompt/tool disclosure.

## LLM03 --- Supply Chain

Controls: - dependency inventory; - n8n node allowlist; - pinned
versions where practical; - vendor/API review; - provenance for models,
embeddings and KB data.

## LLM04 --- Data and Model Poisoning

Controls: - KB provenance; - ingestion scanning; - approval workflow; -
versioning; - supersession; - suspicious-content quarantine.

## LLM05 --- Improper Output Handling

Controls: - JSON schema; - enum-based actions; - input/output
validation; - no arbitrary code/SQL/URL execution; - sanitization at
system boundaries.

## LLM06 --- Excessive Agency

Controls: - least privilege; - separate read/write tools; - approval for
high-impact actions; - deterministic policy checks; - no self-granted
permissions.

## LLM07 --- System Prompt Leakage

Controls: - do not rely on secrecy alone; - minimize secrets in
prompts; - never put credentials in prompts; - refuse prompt
extraction; - keep sensitive logic outside prompts.

## LLM08 --- Vector and Embedding Weaknesses

Controls: - metadata ACLs; - tenant isolation; - retrieval thresholds; -
source provenance; - stale-document filtering; - poisoning detection.

## LLM09 --- Misinformation

Controls: - grounding; - authoritative-source hierarchy; - freshness
checks; - conflict detection; - abstention/escalation.

## LLM10 --- Unbounded Consumption

Controls: - token budgets; - tool-call limits; - RAG-call limits; -
conversation caps; - retry limits; - workflow timeouts; - per-customer
rate limits; - cost monitoring.

## Security decision

The model is never the final security authority. n8n/application
services enforce the controls.
