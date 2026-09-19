# n8n MCP Runtime Integration

The project uses n8n's instance-level MCP server as the agent-facing n8n control interface.

Official n8n Skills are expected to be installed in the coding-agent environment.
The official protocol requires the relevant skill before n8n actions, validation
before publishing, and post-write verification with `get_workflow_details`.

For local n8n:

```text
N8N_BASE_URL=http://localhost:5678
MCP URL=http://localhost:5678/mcp-server/http
```

Do not commit MCP credentials.

The repository contains the synchronization contract and MCP configuration
example. A live MCP session must be supplied by Claude Code/Codex/another
MCP-capable agent; this repository's shell scripts do not pretend to invoke
MCP as if it were a normal HTTP deployment API.
