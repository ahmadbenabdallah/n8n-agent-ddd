# Data Flow & Data Minimization

Customer message:
→ normalize
→ security
→ identity/state
→ intent
→ LLM proposal

Only minimum required context enters each downstream workflow.

Sensitive values excluded from:
- LLM context;
- audit;
- customer response;
- analytics.

Commerce data is filtered by operation and order scope.

Static KB data is provenance-bound.

Live commerce data is fetched on demand when current truth is required.
