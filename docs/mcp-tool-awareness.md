# 🔧 MCP Tool Awareness

> **Adapted from:** GSD v1.26 MCP Tool Awareness
> **Purpose:** Document how GSD sub-agents discover and use MCP (Model Context Protocol) tools.

---

## Overview

OpenClaw agents can access external tools via MCP servers. GSD workflows should be **tool-aware** — agents should discover available tools before planning and use them during execution instead of reinventing functionality.

---

## Tool Discovery Phase

### During Research (Stage 2)

Before writing any code, research agents should catalog available MCP tools:

```markdown
## Available MCP Tools

### File System
- `read` — Read file contents
- `write` — Write/create files
- `edit` — Precise text replacement

### Web
- `web_search` — Search via Brave API
- `web_fetch` — Fetch URL content as markdown

### Browser
- `browser` — Full browser automation (navigate, click, type, snapshot)

### External (via mcporter)
- `github` — GitHub API operations
- `database` — Direct DB queries (if configured)
- `slack` — Send notifications (if configured)
```

### Tool Inventory Template

Add to RESEARCH.md:

```markdown
## MCP Tool Inventory

| Tool | Available | Use Case in This Project |
|------|-----------|-------------------------|
| `exec` | ✅ | Run build commands, tests |
| `browser` | ✅ | UI testing, screenshot verification |
| `web_search` | ✅ | Research dependencies, check docs |
| `github` | ✅ | Create PRs, manage issues |
| `database` | ❌ | N/A — no direct DB access needed |

### Tool Gaps
Tools we need but don't have:
- [ ] Redis CLI — need for cache testing → workaround: use `exec` with redis-cli
- [ ] Docker API — need for container management → workaround: `exec` with docker CLI
```

---

## Planning with Tools

### In PLAN.md

Each task should specify which tools it needs:

```markdown
## Task 3: Create authentication middleware
- **Files:** src/middleware/auth.ts
- **Tools Required:** `write`, `exec` (for running tests)
- **Action:** [implementation steps]
- **Verify:** Use `exec` to run `npm test -- auth.test.ts`
```

### Tool-Dependent Tasks

If a task depends on an MCP tool that might not be available:

```markdown
## Task 7: Verify deployment
- **Tools Required:** `browser` (for UI verification)
- **Fallback:** If browser not available, verify via `web_fetch` + `exec` curl commands
- **Action:** [verification steps]
```

---

## Agent Tool Instructions

When spawning sub-agents, include tool awareness in their instructions:

```markdown
## Available Tools

You have access to these MCP tools:
- `read/write/edit` — File operations
- `exec` — Shell commands (approval may be required)
- `web_search` — Internet search
- `browser` — Browser automation

### Tool Usage Rules
1. Prefer `edit` over `write` for modifying existing files (surgical edits)
2. Use `exec` for running tests, builds, and CLI commands
3. Use `web_search` before implementing complex algorithms (check for known solutions)
4. Use `browser` for UI verification only after code is deployed/served

### Tool Limitations
- `exec` commands may require approval — batch related commands
- `browser` requires a running server — start it first via `exec`
- File `write` overwrites entirely — use `edit` for partial changes
```

---

## Discovering Custom MCP Tools

If your OpenClaw instance has custom MCP servers configured (via mcporter):

```bash
# List available MCP tools
mcporter tools list

# Get tool details
mcporter tools describe <tool-name>
```

### mcporter Integration

Document custom tools in PROJECT.md:

```markdown
## Custom MCP Tools (via mcporter)

### database-query
- **Server:** postgres-mcp
- **Use:** Direct SQL queries for data verification
- **Auth:** Configured via mcporter

### email-send
- **Server:** ms365-mcp
- **Use:** Send notifications on workflow completion
- **Auth:** OAuth token in config
```

---

## Best Practices

1. **Discover before planning** — Run tool inventory during Research stage
2. **Document in RESEARCH.md** — So all agents know what's available
3. **Specify per task** — Each PLAN.md task lists required tools
4. **Plan fallbacks** — If a tool isn't available, have a Plan B
5. **Don't reinvent** — If an MCP tool does it, use the tool instead of writing code

---

## Related

- [Auto-Plan Generation](../tools/auto-plan/README.md) — Plan generation considers available tools
- [Agent Delegation](agent-delegation.md) — Tool requirements affect agent selection
- [Context Management](context-management.md) — Tool output counts against context limits
