# WF-10 Human Ownership

WF-08 is authoritative for case ownership.

If `conversation_owner=HUMAN` or `automation_mode=PAUSED`, normal automated mutations are not authorized.

If `automation_mode=SAFE_ONLY`, only explicitly safe actions may pass.

Human takeover is never inferred from an LLM statement. WF-08 must provide authoritative ownership state.

Ownership must be rechecked immediately before consequential execution to prevent takeover races.
