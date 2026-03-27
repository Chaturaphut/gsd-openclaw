# 🏢 Multi-Repo Workspace

> **Adapted from:** GSD v1.27 Multi-Repo Workspace + v1.28 Multi-Project Commands
> **Purpose:** Manage multiple GSD projects and repositories from a single OpenClaw workspace.

---

## Overview

Real-world systems span multiple repositories — backend, frontend, mobile, infrastructure. GSD Multi-Repo Workspace provides patterns for coordinating GSD workflows across repos while maintaining project isolation.

---

## Workspace Structure

```
~/.openclaw/workspace/
├── projects/
│   ├── backend-api/           # Repo 1
│   │   └── .planning/
│   ├── frontend-app/          # Repo 2
│   │   └── .planning/
│   ├── mobile-app/            # Repo 3
│   │   └── .planning/
│   └── infrastructure/        # Repo 4
│       └── .planning/
├── .workspace/                # Cross-project coordination
│   ├── PORTFOLIO.md           # All projects overview
│   ├── CROSS-PROJECT.md       # Cross-project dependencies
│   ├── contracts/             # Shared data contracts
│   │   ├── api-v1.json
│   │   └── events.json
│   └── STATE.md               # Portfolio-level state
└── config/
    └── gsd-openclaw/          # This repo
```

---

## Portfolio Management

### PORTFOLIO.md

```markdown
# Portfolio Overview

## Active Projects

### backend-api
- **Phase:** 2 of 4 (Frontend Integration)
- **Status:** Executing Wave 2
- **Blockers:** None
- **Next:** QA for Phase 2

### frontend-app
- **Phase:** 1 of 3 (Core UI)
- **Status:** ⏳ Waiting on backend-api Phase 2 (API endpoints)
- **Blockers:** Depends on backend-api auth endpoints
- **Next:** Execute when backend API ready

### mobile-app
- **Phase:** Not started
- **Status:** 🔜 Starts after frontend-app Phase 1 (shared components)
- **Blockers:** Component library from frontend
- **Next:** Requirements definition

### infrastructure
- **Phase:** 1 of 2 (CI/CD Setup)
- **Status:** ✅ Complete
- **Next:** Phase 2 after all apps deployed
```

---

## Cross-Project Dependencies

### Dependency Map

```markdown
# .workspace/CROSS-PROJECT.md

## Dependency Graph

backend-api Phase 2 (Auth API)
  └── frontend-app Phase 1 (needs auth endpoints)
       └── mobile-app Phase 1 (needs shared components)

infrastructure Phase 1 (CI/CD)
  └── ALL projects (need CI pipeline before shipping)
```

### Shared Contracts

Store API contracts in `.workspace/contracts/` so all projects reference the same source:

```json
// .workspace/contracts/api-v1.json
{
  "auth": {
    "POST /api/auth/login": {
      "request": { "email": "string", "password": "string" },
      "response": { "token": "string", "user": { "id": "string" } }
    }
  }
}
```

All projects import contracts from this shared location — single source of truth.

---

## Multi-Project Commands

### Status Overview

Check all projects at once:

```bash
# Quick status of all GSD projects
for dir in projects/*/; do
  if [ -d "$dir/.planning" ]; then
    echo "📁 $(basename $dir):"
    head -5 "$dir/.planning/STATE.md" 2>/dev/null || echo "  No STATE.md"
    echo ""
  fi
done
```

### Cross-Project Advance

When a project completes a phase that unblocks another:

```
backend-api Phase 2 complete → Check CROSS-PROJECT.md
  → frontend-app was waiting on auth endpoints
  → Auto-trigger: "frontend-app can now start Phase 1 execution"
  → Coordinator notifies user or auto-advances
```

### Portfolio Dashboard

Use the existing dashboard tool with multi-project support:

```bash
# Export all project data
for dir in projects/*/; do
  ./config/gsd-openclaw/dashboard/export-data.sh "$dir/.planning"
done

# View portfolio dashboard
open config/gsd-openclaw/dashboard/index.html
```

---

## Coordinator Pattern for Multi-Repo

```markdown
## Multi-Repo Coordinator Instructions

You manage a portfolio of GSD projects. Your workflow:

1. Read .workspace/PORTFOLIO.md for current state of all projects
2. Read .workspace/CROSS-PROJECT.md for dependency map
3. Determine which projects can advance (no blockers)
4. For each advanceable project:
   a. Read its .planning/STATE.md
   b. Determine next action (use /gsd:next logic)
   c. Spawn appropriate agents for that project
5. After any project phase completes:
   a. Update PORTFOLIO.md
   b. Check if completion unblocks other projects
   c. Notify about newly unblocked projects
6. Never work on two projects simultaneously unless they're independent
```

---

## Git Workflow for Multi-Repo

Each repo maintains its own branch flow:

```
backend-api:   main → feat/phase-2-auth → PR → merge
frontend-app:  main → feat/phase-1-ui → PR → merge
mobile-app:    main → feat/phase-1-core → PR → merge
```

The `.workspace/` directory lives in the OpenClaw workspace (not in any repo) — it's coordination metadata only.

---

## Related

- [Auto Advance](auto-advance.md) — Single-project advancement
- [Execution Hardening](execution-hardening.md) — Cross-plan contracts
- [Wave Execution Guide](wave-execution-guide.md) — Parallel execution patterns
