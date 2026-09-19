# Tunisia DTC Agent System FINAL v4 — WF-03 Conversation State

Version 4 incremental update: WF-03 Conversation State.

Purpose:
- make conversation state the deterministic canonical runtime state;
- carry the V4 Customer Identity Graph safely;
- introduce human ownership and automation mode;
- track acknowledgement, action and recovery state;
- prevent the LLM from promoting identity, permissions, ownership, or canonical state.

Preserved boundaries:
WF-10 = authorization; WF-20 = privileged WooCommerce boundary; LLM = proposal/reasoning only.

This package is a WF-03 contract/implementation specification, not executable n8n JSON.
