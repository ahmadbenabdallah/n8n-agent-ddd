# Railway adapter

Railway is an optional deployment target, not a platform dependency.

Deploy the pinned n8n Docker image configured by `runtime/n8n/n8n-version.yaml`.
Set runtime variables through the provider secret/environment mechanism.
Use a persistent volume for `/home/node/.n8n`.
Use Railway PostgreSQL or an external PostgreSQL service according to the deployment profile.

Before production:
1. Configure HTTPS and `N8N_BASE_URL`.
2. Inject `N8N_ENCRYPTION_KEY` as a secret.
3. Configure PostgreSQL.
4. Confirm persistent n8n storage.
5. Run `runtime:doctor` and staging smoke tests.
6. Record the release manifest and rollback target.

Do not treat provider environment variables as business configuration.
