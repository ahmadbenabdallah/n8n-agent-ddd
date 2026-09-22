# Claude Code Adapter

Repository-wide source of truth: `AGENTS.md`. Shared skills: `.agents/skills/`. Lifecycle/validation: `harness/`. Claude-specific hooks and commands should invoke the shared validators rather than duplicate policy.

## Folders

- `agents/`: project subagents, one Markdown file per agent (Claude Code loads every `.md` here, so keep documentation out of this folder). Roles are defined in `.agents/agents/`.
- `commands/`: project slash commands, one Markdown file per command (every `.md` here becomes a command).
- `hooks/`: hook scripts referenced from `.claude/settings.json`.

All three are empty, deliberately. This directory configures Claude Code for
work *on this repository*, and that is a maintainer concern with no value to an
adopter.

## What ships instead

What an adopter needs is shipped as an installable plugin, not as checked-in
project configuration they would have to copy:

```
/plugin marketplace add ahmadbenabdallah/n8n-agent-ddd
/plugin install domain-builder@n8n-agent-ddd
```

`plugins/domain-builder/` builds domain packs: `/scaffold-domain`,
`/adopt-workflow`, `/validate-domain` and the `domain-pack` skill. The
marketplace manifest is `.claude-plugin/marketplace.json`. See
`plugins/domain-builder/README.md`.
