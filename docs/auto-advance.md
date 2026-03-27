# ⏩ Auto Workflow Advancement (`/gsd:next`)

> **Adapted from:** GSD v1.26 `/gsd:next` command
> **Purpose:** Automatically determine and advance to the next workflow stage.

---

## Overview

Instead of manually telling the coordinator "move to research" or "start planning," the `/gsd:next` pattern inspects the current `.planning/` state and automatically advances to the next logical stage.

---

## How It Works

The coordinator reads `.planning/STATE.md` and determines the next action:

```
Current State Analysis:
  ├── REQUIREMENTS.md exists? → Yes ✅
  ├── RESEARCH.md exists?     → Yes ✅
  ├── PLAN-01.md exists?      → Yes ✅
  ├── Plan verified?          → Yes ✅
  ├── Execution started?      → Yes (Wave 1 complete)
  ├── All waves complete?     → No (Wave 2 pending)
  └── QA passed?              → N/A
  
  → NEXT: Execute Wave 2
```

---

## State Machine

```
[No .planning/]     → Initialize: Create PROJECT.md + REQUIREMENTS.md
[Has REQUIREMENTS]  → Research: Spawn researcher agents
[Has RESEARCH]      → Plan: Generate PLAN.md
[Has PLAN]          → Verify: Run plan verification checklist
[Plan Verified]     → Execute Wave 1: Spawn dev agents for Wave 1 tasks
[Wave N Complete]   → Execute Wave N+1: Continue if more waves exist
[All Waves Done]    → QA: Spawn QA agent for verification
[QA Passed]         → Ship: Create PR/MR
[QA Failed]         → Fix: Spawn dev agents for failed items, then re-QA
[Shipped]           → Next Phase: Check ROADMAP.md for next phase
[All Phases Done]   → Complete: Project finished 🎉
```

---

## Implementation

### Reading Current State

```bash
# The coordinator checks these files to determine state:
STATE_FILE=".planning/STATE.md"
REQUIREMENTS=".planning/REQUIREMENTS.md"
RESEARCH=".planning/phases/$PHASE/RESEARCH.md"
PLAN=".planning/phases/$PHASE/PLAN-01.md"
QA=".planning/phases/$PHASE/QA.md"
HANDOFF=".planning/phases/$PHASE/HANDOFF.json"
```

### Decision Logic

```
function determineNext(phase):
  if not exists(REQUIREMENTS):
    return "DEFINE_REQUIREMENTS"
  
  if not exists(RESEARCH) and taskSize == "full":
    return "RESEARCH"
  
  if not exists(PLAN):
    return "PLAN"
  
  if not planVerified(PLAN):
    return "VERIFY_PLAN"
  
  nextWave = getNextIncompleteWave(PLAN, HANDOFF)
  if nextWave:
    return "EXECUTE_WAVE_" + nextWave
  
  if not exists(QA) or qaResult(QA) == "FAIL":
    return "QA"
  
  if qaResult(QA) == "PASS":
    return "SHIP"
  
  return "COMPLETE"
```

### Coordinator Prompt Pattern

Add to your coordinator's instructions:

```markdown
## Auto-Advance Rule

When asked to advance the workflow (or after completing any stage):

1. Read .planning/STATE.md for current status
2. Check which artifacts exist for the current phase
3. Determine next action using the state machine above
4. Report: "Next step: [ACTION] — [REASON]"
5. Ask for confirmation or auto-execute if in autonomous mode

Never skip stages. Never go backward without explicit instruction.
```

---

## Autonomous vs Interactive Mode

### Interactive (Default)
```
Coordinator: "QA passed for Phase 1. Next step: Ship (create PR/MR). Proceed?"
User: "Yes"
Coordinator: [creates PR]
```

### Autonomous
```json
// .planning/config.json
{
  "workflow": {
    "autoAdvance": true,
    "pauseAt": ["ship"]  // Still pause before creating PRs
  }
}
```

In autonomous mode, the coordinator advances through stages without asking — except at configured pause points.

---

## Edge Cases

### Multiple Phases
When a roadmap has multiple phases, `/gsd:next` considers the full roadmap:

```
Phase 1: Complete ✅
Phase 2: Execute Wave 2 ← CURRENT
Phase 3: Not started

→ NEXT: Continue Phase 2 Wave 2 execution
```

### Blocked State
If `WAITING.json` exists with unresolved decisions:

```
→ NEXT: Resolve WAITING decisions before continuing
  Decision needed: "Which database? PostgreSQL vs MongoDB"
  Blocked since: 2026-03-27T08:00:00Z
```

### Regression Detected
If regression gate fails after execution:

```
→ NEXT: Fix regressions in Phase 1 tests before proceeding
  Failing: test-auth-login, test-auth-refresh
```

---

## Related

- [Ship Workflow](ship-workflow.md) — The ship step that `/gsd:next` triggers
- [Wave Execution Guide](wave-execution-guide.md) — How waves advance
- [Context Management](context-management.md) — STATE.md format and usage
