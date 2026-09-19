# WF-00 — Inbound Gateway

Receive Messenger/webhook input, normalize envelope, attach correlation context.

**Security boundary:** No business mutation; reject malformed/oversized/untrusted envelopes.

**Dependencies:** WF-01
