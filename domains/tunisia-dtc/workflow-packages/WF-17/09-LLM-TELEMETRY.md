# LLM Telemetry

Record model behavior without turning telemetry into a prompt/content dump.

Recommended:
- model identifier;
- model version;
- system prompt version hash;
- orchestrator prompt version hash;
- rendering prompt version hash;
- request latency;
- input/output token counts where available;
- retry count;
- structured-output validation result;
- proposal acceptance/rejection;
- refusal/escalation category;
- retrieval reference IDs;
- uncertainty category.

Do not store:
- hidden prompts;
- secrets;
- raw payment information;
- unnecessary customer content.

Useful metrics:
- proposal rejection rate;
- authorization denial rate;
- hallucination/claim validation failures;
- tool/action proposal frequency;
- average latency;
- token consumption;
- fallback frequency.
