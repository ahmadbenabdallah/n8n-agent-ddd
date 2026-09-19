# WF-01 — Security Gate

This workflow is the security boundary immediately after WF-00.

## Node sequence

Execute Workflow Trigger
→ Validate Canonical Input
→ Input Valid?
→ Normalize Text Security
→ Input Bounds
→ Injection Pattern Scan
→ Sensitive Data Scan
→ Velocity / Repetition Check
→ Security Decision
→ Route Security Decision
→ Safe Security Response / Controlled Response Boundary / Continue to Identity
→ Security Contract

## What it protects

- malformed input
- oversized input
- prompt injection / instruction override attempts
- system/developer prompt extraction
- credential/secret requests
- payment/authentication secret references
- repeated/abusive message patterns
- excessive message velocity
- unauthorized tool execution attempts

## Security principle

The customer message is untrusted data. Detection is a gate; it does not give the LLM
authority to change system rules.

`tools_allowed=false` unless the message passes the security decision.

## Downstream

WF-02 consumes the `security_contract`.
