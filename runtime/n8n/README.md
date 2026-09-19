# n8n Runtime

n8n is the orchestration/runtime layer, not the system of record.

## Rules

- Workflow definitions are version-controlled in Git.
- Critical state is externalized to Supabase/Postgres.
- Credentials are injected at runtime and never committed.
- Workflow changes pass validation before deployment.
- Production deployments use controlled CI/CD.
- Old runtimes are drained before termination when deployment strategy requires it.
