# Node-by-node configuration

1. **Execute Workflow Trigger** — invoked from WF-04.
2. **Validate Support Input** — checks the canonical contract.
3. **Support Input Valid?** — fail-closed gate.
4. **Fail Closed** — no tools or LLM when the contract is malformed.
5. **Classify Support Scope** — separates standard support from specialist escalation.
6. **Standard Support?** — sends standard support intents into this engine.
7. **Escalation Support Route** — sends specialist intents to WF-08.
8. **Apply Support Identity Policy** — evaluates whether the requested support task requires verified order access.
9. **Order Verification Required?** — prevents unauthorized order disclosure.
10. **Request Safe Verification** — requests only the application's approved verification path; never asks for passwords, OTPs, CVV or card secrets.
11. **Build Support Plan** — maps the intent to bounded retrieval topics and tool permissions.
12. **Build Support Contract** — creates the downstream support contract.
13. **Sensitive Request Check** — detects credential/authentication-secret requests.
14. **Credential Request?** — blocks unsafe credential handling.
15. **Safe Sensitive Response Route** — no commerce tools.
16. **Finalize Support Contract** — final output for WF-09/WF-11/WF-15/WF-16.
