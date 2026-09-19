# Update / Change-Control Guide

## Rule
Do not update a workflow directly in production without a versioned change.

Every change gets:
- change ID;
- reason;
- affected workflows;
- affected contracts;
- security impact;
- migration requirement;
- test plan;
- rollback plan;
- version.

## Dependency impact map

### If WF-02 changes
Review:
WF-03, WF-07, WF-08, WF-10, WF-16, WF-17, WF-20.

### If WF-10 changes
Review:
all mutation workflows, WF-20, WF-16, WF-17, red-team suite.

### If WF-20 changes
Review:
WF-07, WF-11, WF-12, WF-13, WF-14, WF-15, WF-10, WF-16.

### If output schema changes
Review:
WF-09, WF-10, WF-16, tests.

### If KB schema changes
Review:
WF-18, retrieval layer, WF-09, audit.

## Release process

1. create branch/version;
2. update documentation;
3. update contract;
4. implement;
5. unit tests;
6. integration tests;
7. architecture tests;
8. red-team;
9. staging deployment;
10. E2E;
11. approval;
12. production rollout;
13. monitor;
14. document result.

## Rollback

Rollback to the previous known-good workflow/version. Do not use ad-hoc edits as rollback.

## Prompt changes

Treat system/orchestrator prompts as production code:
- version;
- diff;
- test;
- security review;
- deploy;
- monitor.

A prompt change can change authorization proposals and therefore requires WF-10 regression tests even if WF-10 itself is unchanged.
