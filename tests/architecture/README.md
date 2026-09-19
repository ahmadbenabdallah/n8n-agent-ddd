# Architecture Tests

Architecture tests are executable versions of the platform invariants.

Initial required checks:

- LLM cannot directly execute WooCommerce mutations.
- Only WF-10 can authorize commerce execution.
- Only WF-20 can execute privileged WooCommerce mutations.
- Renderer cannot become an external mutation path.
- Audit cannot authorize.
- Domain state cannot be coupled to transient n8n execution history.
- Unknown external outcomes require reconciliation.
- Runtime secrets cannot be represented in customer/LLM contracts.

As implementation progresses, these checks become automated tests against workflow graphs, contracts and runtime configuration.
