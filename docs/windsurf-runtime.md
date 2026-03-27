# Windsurf Runtime Support

## Overview
GSD-OpenClaw now includes full support for the **Windsurf (Codeium)** AI agent runtime. This allows you to run structured GSD workflows directly within the Windsurf environment, leveraging its native agent capabilities.

## Installation
To install GSD for Windsurf:
```bash
npx get-shit-done-cc@latest --windsurf
```

This will:
1. Detect your Windsurf configuration.
2. Install the necessary GSD hooks and agents into the Windsurf directory.
3. Map GSD commands to Windsurf-native tools.

## Command Conversion
When running in Windsurf, GSD automatically converts high-level commands to Windsurf actions:
- `/gsd:plan-phase` → Planning session with file context.
- `/gsd:execute-phase` → Wave-based execution using Windsurf's edit tools.
- `/gsd:verify-work` → QA verification using Windsurf's shell and test tools.

## Configuration
You can specify Windsurf as your default runtime in `.planning/config.json`:
```json
{
  "runtime": "windsurf",
  "windsurf": {
    "model": "claude-3-5-sonnet",
    "capabilities": ["edit", "shell", "browser"]
  }
}
```

## Best Practices
- **Use the Edit Tool:** Windsurf is highly optimized for structured edits. Ensure your `PLAN.md` has clear file targets.
- **Leverage Windsurf Skills:** You can combine GSD's structured workflow with Windsurf's native skills for even more power.
