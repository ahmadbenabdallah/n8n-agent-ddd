# WF-19 Change Control

Every production change should identify:
- change ID;
- owner;
- reason;
- affected workflows;
- config/prompt/model versions;
- risk;
- rollback plan;
- validation plan;
- deployment time;
- post-deployment verification.

High-risk changes:
- WF-10;
- WF-20;
- identity/security controls;
- payment flows;
- checkout;
- human ownership;
- privacy filters.

WF-19 should detect drift but must not silently overwrite unauthorized changes.
