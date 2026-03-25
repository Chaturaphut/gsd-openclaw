# 🧠 Context Management for Long-Running Agent Teams

> **Rule:** Context is your most precious resource. Manage it or lose it.

AI agents have finite context windows. When context fills up, output quality degrades — agents forget instructions, hallucinate, repeat themselves, and make errors they wouldn't with fresh context. This guide prevents context rot.

---

## The Context Problem

```
Session start:  🟢 High quality — agent knows what to do
30 min later:   🟡 Good — some details getting fuzzy
1 hour later:   🟠 Declining — starts forgetting earlier instructions
2 hours later:  🔴 Context rot — output quality tanks, hallucinations increase
```

## Solutions

### 1. Document Size Limits

Keep planning documents concise:

| Document | Max Size | Tips |
|----------|----------|------|
| PROJECT.md | 2,000 words | Vision only — no implementation details |
| REQUIREMENTS.md | 3,000 words | Bullet points, not paragraphs |
| RESEARCH.md | 3,000 words | Actionable findings only — cut the fluff |
| PLAN.md (per plan) | 2,000 words | One plan per task group |
| Agent instruction | 4,000 words | Plan + context combined |
| SUMMARY.md | 1,000 words | What changed, not why |
| HANDOFF.json | ~500 words | Structured, machine-readable |

### 2. Session Handoff Protocol

When passing work between sessions, use `HANDOFF.json`:

```json
{
  "phase": "phase-1-api",
  "status": "complete",
  "completedTasks": ["task-1", "task-2"],
  "pendingTasks": ["task-3"],
  "decisions": [
    {"id": "D001", "summary": "Used Redis for caching", "reason": "Performance"}
  ],
  "blockers": [],
  "nextSteps": ["Implement task-3 using the Redis client from task-1"],
  "modifiedFiles": ["src/cache.ts", "src/api/users.ts"],
  "timestamp": "2026-03-26T10:00:00Z"
}
```

### 3. Memory Architecture

For long-running agent systems:

```
memory/
├── YYYY-MM-DD.md          # Daily session notes (ephemeral)
├── MEMORY.md              # Long-term memory (distilled)
├── projects-*.md          # Project-specific details
├── archive-YYYY-QN.md     # Quarterly archives
└── heartbeat-state.json   # Recurring task state
```

**Daily → Long-term distillation:**
- Daily notes capture everything
- Periodically (weekly/monthly), distill important items into MEMORY.md
- Archive completed projects quarterly
- Keep MEMORY.md under 5,000 words

### 4. Fresh Context Per Agent

Each spawned agent gets a clean context:

```
✅ Good: Spawn new agent → Pass specific plan + context → Agent works with fresh context
❌ Bad: Keep one agent session running for hours → Context fills → Quality drops
```

### 5. Agent Instruction Template

Structure agent instructions to maximize signal-to-noise:

```markdown
## Task: [Name] (keep under 4,000 words total)

### Context (brief — 200 words max)
[What the project is, what's been done, what matters now]

### Your Task (specific — 500 words max)
[Exact plan from PLAN.md for this agent's tasks]

### API Schema (if applicable)
[Exact field names, types, endpoints — no ambiguity]

### Rules (bullet points — 200 words max)
[Git, security, testing requirements]

### Verify (clear criteria)
[How to know the task is done correctly]
```

---

## Anti-Patterns

| ❌ Don't | ✅ Do |
|----------|------|
| Copy entire codebase into context | Include only relevant files/sections |
| Write essay-length plans | Bullet points and structured data |
| Keep agent running for hours | Fresh session per major task |
| Duplicate info across documents | Single source of truth, reference by path |
| Include "nice to know" context | Only include what the agent NEEDS to act |

---

*Managing context across 59 agents with zero context-rot incidents in production.*
