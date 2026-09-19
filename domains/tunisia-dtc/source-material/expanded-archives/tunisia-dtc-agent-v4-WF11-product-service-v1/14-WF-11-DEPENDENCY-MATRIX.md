# WF-11 Dependency Matrix

| Workflow | Relationship |
|---|---|
| WF-02 | identity context only when needed |
| WF-03 | conversation/product selection context |
| WF-05 | sales candidates and requirements |
| WF-09 | requests factual product context |
| WF-10 | authorization for consequential actions |
| WF-12 | consumes product/variation facts for cart |
| WF-13 | promotion/product eligibility inputs |
| WF-14 | checkout preconditions |
| WF-16 | receives verified product facts for rendering |
| WF-17 | audit/correlation |
| WF-20 | sole WooCommerce boundary |

Key rule: WF-11 provides product facts; it does not authorize or execute commerce mutations.
