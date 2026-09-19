# Queue & Stuck Execution Monitoring

Monitor:
- queue depth;
- queue age;
- execution duration;
- concurrent executions;
- stalled executions;
- worker availability;
- retry queues;
- dead-letter queues.

Define stuck thresholds from observed workload.

When a workflow is stuck:
1. detect;
2. correlate;
3. classify;
4. alert;
5. apply approved recovery;
6. verify recovery;
7. audit.

Do not automatically replay consequential commerce actions unless the workflow's idempotency/reconciliation contract explicitly permits it.
