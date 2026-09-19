# Node-by-node configuration

1. **Execute Workflow Trigger** — internal renderer workflow.
2. **Validate Renderer Input** — requires response plan, channel and language context.
3. **Renderer Input Valid?** — fail closed.
4. **Reject Invalid Renderer Input**.
5. **Build Channel + Language Context** — separates language from script.
6. **Build Grounded Response Plan** — keeps only verified customer-safe facts.
7. **Build Rendering Constraints** — constructs renderer instructions.
8. **Receive LLM Draft** — adapter boundary for the rendering LLM.
9. **Validate Customer Output** — checks script, secrets, internal leakage and public-channel PII.
10. **Output Valid?** — failed output cannot be sent.
11. **Regeneration Required** — return machine-readable failure for controlled regeneration.
12. **Build Final Customer Response** — normalizes whitespace and applies 1,500-character safety bound.
13. **Build Renderer Contract** — final output contract.

## LLM connection

The package uses `llm_response.text` / `generated_text` / `draft_response` as the adapter input.

In production, connect the rendering LLM explicitly after `Build Rendering Constraints`. Keep the LLM output separate from the send operation.
