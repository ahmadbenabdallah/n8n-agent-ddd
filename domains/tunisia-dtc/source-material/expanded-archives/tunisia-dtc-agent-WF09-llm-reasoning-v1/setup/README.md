# WF-09 — LLM Reasoning

The model boundary: **LLM reasons/proposes; it never authorizes or executes.**

Position: WF-05/WF-06/WF-07/WF-08 → WF-09 → WF-10 → services.

This workflow uses an n8n HTTP Request node to call the OpenAI Responses API. Set server-side environment variables:
- OPENAI_API_KEY
- OPENAI_REASONING_MODEL (default gpt-4.1-mini)
- WF09_SYSTEM_PROMPT

Do not put secrets in workflow inputs or customer messages.
