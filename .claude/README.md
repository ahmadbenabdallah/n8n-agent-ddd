# Claude Code Adapter

Repository-wide source of truth: `AGENTS.md`. Shared skills: `.agents/skills/`. Lifecycle/validation: `harness/`. Claude-specific hooks and commands should invoke the shared validators rather than duplicate policy.

## Folders

- `agents/`: project subagents, one Markdown file per agent (Claude Code loads every `.md` here, so keep documentation out of this folder). Roles are defined in `.agents/agents/`.
- `commands/`: project slash commands, one Markdown file per command (every `.md` here becomes a command).
- `hooks/`: hook scripts referenced from `.claude/settings.json`.

All three are empty for now.
