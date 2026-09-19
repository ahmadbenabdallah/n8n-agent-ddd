# Requirements

- n8n 1.x with Code and IF nodes.
- WF-03 must invoke WF-04 with the required input contract.
- No credentials are required by WF-04.
- No LLM call is required for the deterministic router.
- Unit/regression tests should run before activating the workflow.
- Do not allow intent output to authorize an action. WF-10 remains the authorization boundary.

## Production hardening

1. Replace simplistic keyword scoring with a versioned classifier/ruleset as the phrase library grows.
2. Keep customer text as data; never concatenate it into executable prompts or code.
3. Log `intent`, `confidence`, `candidate_matches`, language/script metadata and rule version in WF-17.
4. Add locale-specific tests for Tounsi Arabizi, Arabic script, French, English and mixed messages.
5. Treat `confidence` as routing metadata, never as permission.
