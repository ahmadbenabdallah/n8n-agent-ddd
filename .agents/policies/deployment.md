# Deployment Policy

Production deployment: build immutable artifact → deploy green → health check → smoke test → route traffic → drain old runtime → verify → rollback if needed. Persistent state lives outside disposable runtime instances.
