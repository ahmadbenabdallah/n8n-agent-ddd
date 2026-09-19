# Definition of Done — WF-19 v4

WF-19 is production-ready only when:

1. Critical dependencies have health checks.
2. Monitoring itself is observable.
3. Retry and dead-letter policies are bounded.
4. Unknown commerce execution is actively monitored.
5. Reconciliation backlog is measurable.
6. Workflow/configuration drift is detectable.
7. Security-control health is monitored.
8. Security failures fail closed.
9. Maintenance actions are idempotent and allowlisted.
10. WF-19 cannot authorize customer actions.
11. WF-10 remains the sole authorization boundary.
12. WF-20 remains the sole privileged WooCommerce boundary.
13. Audit events are sent to WF-17.
14. KB maintenance does not bypass WF-18 approval.
15. Incident/recovery runbooks are tested.
16. Rollback and DR are validated.
17. Red-team and E2E suites pass.
18. Return to NORMAL requires explicit health validation.
