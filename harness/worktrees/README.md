# Worktree Orchestration

Tasks that can modify repository state should execute in isolated git worktrees when dispatched by the harness.

Target model:

```text
main
├── worktree/TASK-001
├── worktree/TASK-002
└── worktree/TASK-003
```

The harness must verify dependency completion before dispatching a task and must never place unrelated agents in the same mutable working tree.
