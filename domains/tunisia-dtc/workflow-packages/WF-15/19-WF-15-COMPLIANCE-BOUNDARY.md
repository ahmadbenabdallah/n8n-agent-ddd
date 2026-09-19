# WF-15 Payment Compliance Boundary

The initial Tunisia DTC deployment uses COD.

Therefore the production scope should avoid collecting card credentials in Messenger/n8n/LLM.

If online payment is introduced later:
- use a PCI-compliant payment provider/hosted payment flow;
- keep raw payment credentials outside the agent;
- return only provider-safe payment references/status;
- update threat model, data retention, audit and red-team tests before activation.

This document does not authorize a specific payment provider or imply compliance certification.
