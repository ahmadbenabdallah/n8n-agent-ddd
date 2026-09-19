# Docker Runtime

Local development uses Docker Compose.

Production images must use pinned versions rather than `latest`.

The local compose file is intentionally a development foundation; production deployment is defined separately and must include durable external state, secrets, health checks, backup strategy and controlled rollout.
