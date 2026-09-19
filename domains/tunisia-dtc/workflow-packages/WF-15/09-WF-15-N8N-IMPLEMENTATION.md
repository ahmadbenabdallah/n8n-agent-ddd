# WF-15 n8n Implementation

Recommended flow:

Trigger
→ Validate Request
→ Validate Identity/Order Scope
→ Validate WF-10 Authorization if mutation
→ Load Current Order/Transaction Context
→ Query Authoritative Payment Source through controlled boundary
→ Normalize Status
→ Detect Unknown/Conflict
→ Reconcile when required
→ Persist Safe Transaction State
→ Audit WF-17
→ Return verified status.

No credential-bearing fields should pass through ordinary workflow data.
Payment provider credentials remain in protected n8n credentials/WF-20 or a dedicated compliant payment boundary.
