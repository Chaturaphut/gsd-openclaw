# ⚡ Fast Inline Task Mode (`/gsd:fast`)

> **Adapted from:** GSD v1.27 `/gsd:fast` command
> **Purpose:** Skip planning entirely for trivial inline changes.

---

## Overview

Not every change needs a full GSD workflow — or even a Quick Mode plan. `/gsd:fast` is for changes so small they don't warrant any planning overhead: rename a variable, fix a typo, update a config value, add a log statement.

---

## When to Use Fast Mode

### ✅ Fast Mode (No Plan, No Research)
- Single file change
- ≤ 20 lines modified
- No new API endpoints
- No new dependencies
- No schema changes
- No security implications

### ❌ NOT Fast Mode
- Changes spanning multiple files
- New functionality (even small)
- Anything touching auth/permissions
- Database migrations
- Changes requiring tests to be updated

---

## 3-Tier Task Sizing

| Mode | Files | Lines | Plan | Research | QA |
|------|-------|-------|------|----------|-----|
| 🏎️ **Fast** | 1 | ≤ 20 | ❌ | ❌ | Spot check |
| 🚗 **Quick** | ≤ 3 | Any | Brief | ❌ | Full |
| 🚀 **Full GSD** | > 3 or new API | Any | Full | ✅ | Full |

---

## Fast Mode Workflow

```
1. Agent receives tiny task
2. Classify as Fast Mode (single file, ≤20 lines)
3. Make the change directly
4. Spot check: does it compile? Does it break obvious things?
5. Commit with conventional commit message
6. Done — no PLAN.md, no QA-REPORT.md, no HANDOFF.json
```

---

## Examples

### ✅ Good Fast Mode Tasks

```
"Fix the typo in the error message on line 42 of auth.ts"
→ 1 file, 1 line change → Fast Mode ✅

"Update the API timeout from 5000 to 10000 in config.ts"  
→ 1 file, 1 line change → Fast Mode ✅

"Add console.log for debugging the auth flow"
→ 1 file, ~3 lines → Fast Mode ✅

"Rename 'getUserData' to 'fetchUserProfile' in user-service.ts"
→ 1 file, ~5 lines → Fast Mode ✅
```

### ❌ NOT Fast Mode

```
"Rename 'getUserData' to 'fetchUserProfile' across the codebase"
→ Multiple files affected → Quick Mode 🚗

"Add a new /api/health endpoint"
→ New API endpoint → Quick Mode 🚗 or Full GSD 🚀

"Refactor auth to use refresh tokens"
→ Multiple files, new logic → Full GSD 🚀
```

---

## Coordinator Decision Logic

```
function classifyTask(task):
  files = estimateFilesAffected(task)
  lines = estimateLinesChanged(task)
  hasNewAPI = detectNewEndpoints(task)
  hasSchemaChange = detectSchemaChange(task)
  
  if files == 1 AND lines <= 20 AND !hasNewAPI AND !hasSchemaChange:
    return "FAST"
  elif files <= 3 AND !hasNewAPI:
    return "QUICK"
  else:
    return "FULL_GSD"
```

---

## Guardrails

Even in Fast Mode, enforce these:

1. **Conventional Commits** — Still use `fix:`, `feat:`, `docs:` prefixes
2. **No secrets** — Never hardcode credentials, even for "quick" changes
3. **Compilation check** — Run build/compile after change
4. **Branch flow** — Still use feature branches for non-trivial repos

---

## Configuration

```json
// .planning/config.json
{
  "workflow": {
    "fastMode": {
      "enabled": true,
      "maxFiles": 1,
      "maxLines": 20,
      "requireSpotCheck": true,
      "allowedWithoutBranch": false
    }
  }
}
```

---

## Related

- [Auto Advance](auto-advance.md) — Workflow advancement (skips to ship for Fast)
- [Git Branch Flow](git-branch-flow.md) — Commit conventions apply even in Fast Mode
- [QA Standards](qa-standards.md) — When Full QA is required vs spot check
