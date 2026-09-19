# Node-by-node configuration

1 Trigger — called by upstream business workflows.
2 Validate input — canonical contract gate.
3 Input valid — fail closed.
4 Fail closed — no model call.
5 Security reasoning gate — consumes WF-01 security contract.
6 LLM allowed — prevents unsafe model calls.
7 Block LLM — security stop.
8 Build trusted context — allowlisted application facts only.
9 Fence context — customer/history/tool text explicitly marked untrusted.
10 OpenAI Reasoning Call — Responses API, low temperature, bounded output, no tools.
11 Parse Structured Output — parse JSON.
12 JSON Output Valid — rejects malformed output.
13 Invalid LLM Output — retry/escalate boundary.
14 Normalize LLM Proposal — action allowlist and proposal contract.
15 Validate Proposal Boundary — script and secret leakage checks.
16 Proposal Valid — final gate.
17 Block Invalid Proposal — prevents downstream use.
18 Build Reasoning Contract — consumed by WF-10/WF-16.

For production, use the structured-output/schema capability supported by the selected OpenAI API/model, then keep the post-response validator mandatory.
