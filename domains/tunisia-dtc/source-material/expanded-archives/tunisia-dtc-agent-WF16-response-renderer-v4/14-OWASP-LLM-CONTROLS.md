# OWASP LLM / Agent Controls

## LLM01 Prompt Injection
Customer/retrieved text cannot override renderer policy.

## LLM02 Sensitive Information Disclosure
Privacy filter blocks secrets, private data, prompts, credentials and tokens.

## LLM03 Supply Chain
Only approved rendering prompt/model/configuration versions are accepted.

## LLM04 Data/Model Poisoning
Retrieved content cannot establish live commerce facts without authoritative verification.

## LLM05 Improper Output Handling
LLM wording is treated as untrusted text and passes deterministic validation.

## LLM06 Excessive Agency
WF-16 has no commerce authorization or execution privilege.

## LLM07 System Prompt Leakage
System prompts and hidden instructions never enter customer output.

## LLM08 Vector/Embedding Weakness
RAG-derived facts are provenance-bound and cannot override live commerce state.

## LLM09 Misinformation
Claim validator requires matching verified facts.

## LLM10 Unbounded Consumption
Bound output size, retries, token budgets and message length.

Agent-specific controls:
- no authorization in renderer;
- no direct tools;
- human ownership blocks autonomous action claims;
- unknown execution requires reconciliation;
- delivery retries never replay commerce actions.
