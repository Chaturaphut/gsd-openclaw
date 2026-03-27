# Agent Skill Injection

## Overview
GSD-OpenClaw now supports **Agent Skill Injection**. This feature allows you to inject project-specific skills (MCP tools, custom scripts, or domain knowledge) into your GSD subagents at runtime.

## How it Works
In your `.planning/config.json`, you can define an `agent_skills` section. This section maps project-specific skills to either all subagents or specific roles.

## Configuration Example
In `.planning/config.json`:
```json
{
  "agent_skills": [
    {
      "name": "project-db-utils",
      "path": "tools/db-utils.sh",
      "description": "Custom database utilities for this project",
      "roles": ["dev", "qa"]
    },
    {
      "name": "api-validator",
      "mcp": "http://localhost:3000/mcp",
      "roles": ["qa"]
    }
  ]
}
```

## Supported Skill Types
1.  **Local Scripts**: Inject custom shell scripts as tools.
2.  **MCP Servers**: Connect to Model Context Protocol servers for external data and tools.
3.  **Prompt Snippets**: Inject domain knowledge (e.g., API schemas, style guides) into the agent's system prompt.

## Benefits
- **Domain Specificity**: Agents don't just have general coding knowledge; they have *your* project's specific tools.
- **Dynamic Capabilities**: Add new skills as the project evolves without updating the core GSD installation.
- **Better Delegation**: Give the QA agent specialized testing tools while giving the Dev agent specialized build tools.

## Implementation Details
When GSD spawns a subagent (using `agent_spawn` or `sessions_spawn`), it:
1.  Reads the `agent_skills` config.
2.  Filters skills based on the agent's role.
3.  Injects the skills into the subagent's session or system prompt.
4.  Attaches any necessary file or MCP context.
