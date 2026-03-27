# 📊 Agent Performance Profiling

> **Adapted from:** GSD v1.26 Developer Profiling Pipeline
> **Purpose:** Track and optimize individual agent performance across GSD workflows.

---

## Overview

Agent Performance Profiling goes beyond aggregate analytics — it builds a **profile per agent** (or agent type) that tracks strengths, weaknesses, and patterns over time. Use this to make smarter delegation decisions and identify training opportunities.

---

## Profile Structure

Each agent accumulates a profile in `.planning/profiles/`:

```
.planning/profiles/
├── backend-dev.json
├── frontend-dev.json
├── qa-agent.json
└── security-reviewer.json
```

### Profile Schema

```json
{
  "agentId": "backend-dev",
  "model": "claude-sonnet-4-20250514",
  "totalTasks": 47,
  "metrics": {
    "firstPassRate": 0.82,
    "avgReworkCycles": 0.3,
    "stubRate": 0.02,
    "regressionRate": 0.05,
    "avgCompletionTime": "4m 30s",
    "planAdherenceRate": 0.95
  },
  "strengths": ["API design", "error handling", "TypeScript"],
  "weaknesses": ["CSS layout", "complex SQL queries"],
  "recentTrend": "improving",
  "lastUpdated": "2026-03-27T10:00:00Z"
}
```

---

## Key Metrics

| Metric | What It Measures | Target |
|--------|-----------------|--------|
| **First-Pass Rate** | Tasks accepted by QA on first attempt | ≥ 80% |
| **Rework Cycles** | Average rounds of QA rejection per task | ≤ 0.5 |
| **Stub Rate** | % of tasks with leftover TODO/FIXME | ≤ 2% |
| **Regression Rate** | % of tasks that break previous phases | ≤ 5% |
| **Plan Adherence** | How closely output matches PLAN.md spec | ≥ 90% |
| **Completion Time** | Time from task assignment to QA pass | Trend ↓ |

---

## How to Use Profiles

### 1. Smart Delegation

The coordinator reads profiles before assigning tasks:

```
Task: "Build complex SQL reporting endpoint"

Profile Check:
  backend-dev → weakness: "complex SQL queries" (0.6 first-pass rate on SQL tasks)
  data-agent  → strength: "SQL optimization" (0.95 first-pass rate)

Decision: Assign to data-agent, or pair backend-dev WITH data-agent as reviewer.
```

### 2. Model Selection

Profile data helps choose the right model per task type:

```
Pattern Observed:
  claude-sonnet-4-20250514 → Great for straightforward CRUD (95% first-pass)
  claude-sonnet-4-20250514 → Better for complex architecture decisions (90% first-pass)
  gemini-2.5-pro → Strong at frontend CSS/layout tasks

Action: Update agent config to use best model per task category.
```

### 3. Continuous Improvement

After each QA cycle, update the profile:

```bash
# In your QA agent's post-verification step:
# 1. Read current profile
# 2. Update metrics based on QA result
# 3. Recalculate trends
# 4. Write updated profile
```

---

## Collecting Profile Data

### From QA Reports

After each QA pass/fail, extract:
- Task type (API, UI, DB, infrastructure)
- Pass/fail on first attempt
- Number of rework cycles
- Stubs found (yes/no)
- Regressions introduced (yes/no)

### From HANDOFF.json

Extract per-phase:
- Tasks completed vs planned
- Decisions made (quality indicator)
- Blockers encountered

### From Analytics Tool

Use the existing `tools/analytics/collect-metrics.sh` with the `--per-agent` flag:

```bash
./tools/analytics/collect-metrics.sh --per-agent --output .planning/profiles/
```

---

## Profile-Driven Orchestration Pattern

```
Coordinator receives task:
  1. Classify task type (API / UI / DB / Infra / Security)
  2. Read agent profiles from .planning/profiles/
  3. Score each available agent for this task type
  4. Assign to highest-scoring agent
  5. If no agent scores > 0.7 → pair two agents (executor + reviewer)
  6. After QA → update profile with results
```

This creates a **feedback loop** where your agent team gets smarter over time — the coordinator learns who's best at what.

---

## Integration with OpenClaw

In your agent spawn config:

```javascript
// Coordinator reads profile before spawning
const profile = readProfile('backend-dev');
const taskType = classifyTask(task);

if (profile.getScore(taskType) < 0.7) {
  // Spawn with a reviewer
  spawn('backend-dev', { task, reviewer: 'senior-dev' });
} else {
  // Direct assignment
  spawn('backend-dev', { task });
}
```

---

## Anti-Patterns

- ❌ **Never profile once and forget** — update after every QA cycle
- ❌ **Don't over-specialize** — rotate agents occasionally to build breadth
- ❌ **Don't punish low scores** — use them to improve delegation, not to exclude agents
- ❌ **Don't ignore model differences** — same agent prompt on different models = different profile

---

## Related

- [Agent Delegation Guide](agent-delegation.md) — How to delegate tasks
- [QA Standards](qa-standards.md) — QA report format that feeds profiling
- [Agent Performance Analytics](../tools/analytics/README.md) — Aggregate metrics tool
