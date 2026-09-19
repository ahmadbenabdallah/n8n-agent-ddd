# Runtime integration tests

These tests are designed to run after the target n8n runtime is deployed.

They intentionally distinguish:
- static architecture tests
- live readiness
- authenticated control-plane access
- full business E2E tests

Never convert `NOT_EXECUTED` into `PASS`.
