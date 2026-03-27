# ⚙️ Workflow Configuration Settings

> **Adapted from:** GSD v1.28 `workflow.skip_discuss` / `discuss_mode` settings
> **Purpose:** Fine-tune GSD workflow behavior per project via config.json.

---

## Overview

Not every project needs every GSD stage. Configuration settings let you skip, modify, or auto-trigger specific workflow behaviors to match your project's needs.

---

## Configuration File

All settings live in `.planning/config.json`:

```json
{
  "version": "1.6",
  "project": "my-project",
  "workflow": {
    "skipDiscuss": false,
    "discussMode": "async",
    "autoAdvance": false,
    "executionMode": "autonomous",
    "taskSizing": "auto",
    "peerReview": {
      "enabled": true,
      "requiredFor": ["full"],
      "skipFor": ["fast"]
    },
    "fastMode": {
      "enabled": true,
      "maxFiles": 1,
      "maxLines": 20
    },
    "verificationDebt": {
      "enabled": true,
      "blockShipAbove": 80
    },
    "uiPhase": {
      "autoDetect": true,
      "triggerKeywords": ["frontend", "UI", "component", "page", "form"]
    },
    "tempReaper": {
      "enabled": true,
      "patterns": ["*.tmp", "*.bak", "*.orig", "debug-*"],
      "reapOnShip": true
    }
  },
  "context": {
    "maxInstructionTokens": 5400,
    "progressiveSummarization": true
  }
}
```

---

## Key Settings

### `skipDiscuss`
Skip the discussion/requirements refinement stage. Useful when requirements are already well-defined.

```json
"skipDiscuss": true  // Jump straight to Research after Requirements
```

### `discussMode`
How requirements discussion happens:

| Mode | Behavior |
|------|----------|
| `"sync"` | Real-time back-and-forth with user |
| `"async"` | Agent proposes clarifications, waits for response |
| `"auto"` | Agent makes reasonable assumptions, documents them |
| `"skip"` | Same as `skipDiscuss: true` |

### `autoAdvance`
Automatically progress through stages without asking:

```json
"autoAdvance": true,
"pauseAt": ["ship"]  // Still ask before creating PRs
```

### `executionMode`
How tasks are executed:

| Mode | Behavior |
|------|----------|
| `"autonomous"` | Agents execute without asking (default) |
| `"interactive"` | Pause before each task for approval |
| `"supervised"` | Execute but show code before committing |

### `taskSizing`
How to classify task complexity:

| Mode | Behavior |
|------|----------|
| `"auto"` | Agent classifies based on file count and scope |
| `"always-full"` | Every task uses Full GSD |
| `"always-quick"` | Every task uses Quick Mode (use with caution) |

---

## UI-Phase Auto-Detection

When enabled, the coordinator automatically recommends UI-Phase workflow steps when tasks involve frontend work:

```json
"uiPhase": {
  "autoDetect": true,
  "triggerKeywords": ["frontend", "UI", "component", "page", "form", "CSS", "React", "Vue"],
  "includeUIReview": true
}
```

When triggered:
```
Coordinator detects: Task involves "Create login page component"
  → Keywords matched: "page", "component"
  → Auto-recommend: Add UI-Phase and UI-Review steps to plan
  → Generate UI-SPEC.md template
```

---

## Temp File Reaper

Automatically clean up temporary files before shipping:

```json
"tempReaper": {
  "enabled": true,
  "patterns": ["*.tmp", "*.bak", "*.orig", "debug-*", "*.log"],
  "directories": [".planning/scratch/", "tmp/"],
  "reapOnShip": true,
  "reapOnPhaseComplete": false
}
```

The reaper runs during `/gsd:ship` and removes matching files:

```bash
# Reaper execution
Cleaning up temp files before ship...
  Removed: .planning/scratch/draft-v1.md
  Removed: src/debug-auth.ts
  Removed: tests/output.tmp
  Cleaned: 3 temp files
```

---

## Data-Flow Tracing

Enable data-flow tracing during verification to catch integration issues:

```json
"verification": {
  "dataFlowTracing": true,
  "environmentAudit": true
}
```

When enabled, QA agents trace data through the system:

```
Data Flow Trace: User Login
  1. UI Form → POST /api/auth/login { email, password }
  2. API Route → AuthService.login(email, password)
  3. AuthService → DB query: users.findOne({ email })
  4. AuthService → JWT.sign({ userId, role })
  5. API Response → { token, refreshToken, user }
  6. UI → Store token in localStorage
  7. UI → Redirect to /dashboard

  ✅ All field names consistent
  ❌ Step 6: localStorage for JWT — security concern (use httpOnly cookie)
```

---

## Environment Audit

QA agents verify all required environment variables exist:

```
Environment Audit:
  ✅ JWT_SECRET — set in .env
  ✅ DATABASE_URL — set in .env
  ❌ REDIS_URL — MISSING (required by session service)
  ✅ NODE_ENV — set to "development"
  
  Action: Add REDIS_URL to .env.example and .env
```

---

## Related

- [Fast Mode](fast-mode.md) — Fast Mode configuration
- [Interactive Executor](interactive-executor.md) — Interactive Mode settings
- [Auto Advance](auto-advance.md) — Auto-advance configuration
- [Context Window Optimization](context-window-optimization.md) — Context settings
