# Handoff Best Practices — Session Continuity for Multi-Agent Workflows

> **Adapted from GSD v1.26 Session Handoff pattern**  
> OpenClaw-specific guidance for Ruk-Com virtual team

---

## Why Handoffs Fail

The most common cause of broken multi-agent workflows is **context rot** — when an agent resumes a task mid-stream without knowing what the previous agent decided, what files were changed, or what blockers remain. The result:

- Duplicate work (re-implementing what's already done)
- Contradictory decisions (different DB schemas, different field names)
- Silent drops (agent finishes "successfully" but skips a blocker it didn't know about)

---

## The HANDOFF.json Contract

Every agent that **hands off** work must create a `HANDOFF.json` in the phase directory before exiting.

```json
{
  "phase": "phase-1-api-setup",
  "status": "complete | partial | blocked",
  "completedTasks": ["task-1", "task-2"],
  "pendingTasks": ["task-3"],
  "decisions": [
    {
      "id": "D001",
      "summary": "Use Redis for session storage",
      "reason": "Performance: 10ms vs 80ms for MariaDB sessions",
      "alternatives_rejected": ["MariaDB sessions", "in-memory"]
    }
  ],
  "blockers": [
    {
      "id": "B001",
      "description": "Missing S3 bucket credentials",
      "blocked_tasks": ["task-3"],
      "waiting_on": "CEO / Infra team"
    }
  ],
  "modifiedFiles": [
    "src/api/routes.ts",
    "src/services/auth.ts",
    ".env.example"
  ],
  "apiContracts": {
    "POST /api/auth/login": "returns { token: string, user: UserDTO }",
    "GET /api/profile": "requires Bearer token"
  },
  "nextSteps": [
    "Start phase-2 frontend — pass HANDOFF.json to agent",
    "Resolve B001 before task-3"
  ],
  "timestamp": "2026-04-02T00:00:00Z",
  "agentId": "mai (Moses/Backend)"
}
```

**Storage location:** `.planning/phases/{phase}/HANDOFF.json`

---

## Receiving Agent Protocol

When MumuX spawns the next agent in a chain, the agent instruction **must include**:

```
## Context from Previous Agent
Read `.planning/phases/{prev-phase}/HANDOFF.json` before starting.

Key decisions already made:
- D001: Redis for sessions (do not re-open this decision)

Pending tasks you inherit: [task-3]
Modified files: src/api/routes.ts, src/services/auth.ts

Do NOT re-implement completed tasks. Start from pendingTasks.
```

**Rule:** If HANDOFF.json is absent and the previous phase is marked "complete" in STATE.md — ask MumuX to reconstruct it from SUMMARY.md before proceeding.

---

## Partial Handoffs (Phase Not Complete)

When a phase must pause (timeout, blocker, resource limit):

1. Set `"status": "partial"` in HANDOFF.json
2. List `pendingTasks` explicitly
3. Record current file state in `modifiedFiles`
4. Update `.planning/STATE.md` with `Blocked: true` + reason

The next agent picks up `pendingTasks` only — skips `completedTasks`.

---

## Cross-Agent API Contracts

Frontend and Backend agents often work in parallel waves. To prevent field-name mismatches:

**Before Wave 2 starts**, MumuX extracts `apiContracts` from the backend HANDOFF.json and injects it into the frontend agent instruction:

```markdown
## API Contract (from Backend Handoff)
POST /api/auth/login → { token: string, user: { id, name, email, role } }
GET /api/profile → requires Authorization: Bearer <token>

⚠️ These field names are final. Do NOT deviate.
```

This prevents the #1 integration bug: frontend expecting `user_id` when backend returns `id`.

---

## Handoff Anti-Patterns

| Anti-Pattern | Problem | Fix |
|---|---|---|
| Skipping HANDOFF.json | Next agent re-does work or misses decisions | Always write HANDOFF.json before exiting |
| Vague `nextSteps` | Receiving agent guesses | Be specific: file paths, task IDs, what was decided |
| `completedTasks` includes stubs | QA passes, but feature is incomplete | Stub Detection rule: grep for TODO/FIXME before marking complete |
| No `apiContracts` when handing to frontend | Field name mismatch | Always include contract for cross-team handoffs |
| Status = "complete" when blockers exist | Next agent starts on blocked work | Use `"partial"` + populate `blockers[]` |

---

## Multi-Wave Handoff Chain

In a 3-wave workflow:

```
Wave 1: Moses (Backend) → writes HANDOFF.json (phase-1)
           ↓  MumuX reads, extracts apiContracts
Wave 2: David (Frontend) → reads HANDOFF.json → writes HANDOFF.json (phase-2)
           ↓  MumuX reads, confirms integration
Wave 3: Titus (QA Lead) → reads both HANDOFFs → verifies against all contracts
```

MumuX is the **handoff broker** — never let agents directly chain without MumuX review.

---

## OpenClaw Implementation

In the OpenClaw multi-agent architecture, handoff files live in the workspace:

```
/root/.openclaw/workspace/
├── .planning/
│   └── phases/
│       └── phase-1-api/
│           ├── PLAN-01.md
│           ├── SUMMARY.md
│           └── HANDOFF.json   ← Agent writes here
```

MumuX reads HANDOFF.json via `read` tool and injects relevant sections into next agent's `sessions_spawn` task parameter.

---

## Quick Reference

```bash
# Check if handoff exists before spawning next agent
ls .planning/phases/phase-1-api/HANDOFF.json

# Read decisions to inject into next agent
cat .planning/phases/phase-1-api/HANDOFF.json | jq '.decisions, .apiContracts'
```

---

*Part of GSD-OpenClaw — multi-agent GSD workflow for OpenClaw*  
*Cherry-picked from GSD v1.26 Session Handoff | Adapted for OpenClaw architecture*
