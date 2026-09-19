---
title: Getting Started
summary: Install n8n Agent DDD locally, run the development runtime, and work with Claude Code or Codex.
---

# Getting Started

Start with the root repository README. The recommended path is:

1. Install Git, Node.js 22, pnpm 10.15.0, Docker and Docker Compose.
2. Clone the repository.
3. Run `pnpm install`.
4. Run `pnpm run doctor`, `pnpm validate`, and `pnpm test`.
5. Copy `infrastructure/environments/local/.env.example` to `.env`.
6. Start the local n8n runtime with the Docker Compose file.
7. Open `http://localhost:5678`.
8. Use Claude Code or Codex from the repository root.
9. Read `AGENTS.md` and the relevant adapter instructions before making changes.
10. Use Harness validation and Git/CI gates before merging.

The root README contains the complete first-session path, runtime explanation, AI coding-agent setup, deep-dive reading order, and development workflow.
