# Architecture

Four layers: Platform, Agent System, Runtime, Domains.

Platform is domain-agnostic. The Agent System contains skills, roles, policies and the harness. Runtime uses n8n as orchestration, Supabase as durable state and Redis as optional queue. Domains contain business logic and workflows.

Deployment principle: compute is disposable; state is durable; business rules are versioned; execution is idempotent; deployments are reversible.
