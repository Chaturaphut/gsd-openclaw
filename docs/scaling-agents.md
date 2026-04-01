# Scaling Agents — From 5 to 50 Agents

> Practical guide for growing a GSD-OpenClaw multi-agent team without chaos

---

## The Scaling Problem

Running 5 agents is easy. At 20+ agents, you hit:

- **Coordination overhead** — MumuX spends more time managing than delivering
- **Context collisions** — Two agents modify the same file simultaneously
- **Decision bottlenecks** — Everything waits for human approval
- **Visibility gaps** — No one knows what's actually running right now
- **Spawn storms** — Spawning 15 agents at once overwhelms context and costs

This guide covers patterns to scale gracefully.

---

## The 5-Agent Foundation (Start Here)

Before scaling, get these 5 roles rock-solid:

| Role | Agent | Responsibility |
|---|---|---|
| Coordinator | MumuX | Plans, routes, tracks, reports |
| Architect | Son (Nathan/BA) | Reviews plans, guards contracts |
| Dev Lead | Moses or David | Owns a workstream end-to-end |
| QA | Titus (QA Lead) | Gate-keeps quality |
| Deployer | Gideon (DevSecOps) | Ships to prod |

**Rule:** Do not add more agents until these 5 are working smoothly. Each addition multiplies coordination cost.

---

## Wave-Based Scaling (5–20 Agents)

At this scale, use **wave execution** to parallelize without chaos:

### Wave Design Principles

1. **Independence first** — Only parallelize truly independent tasks
2. **Contract before parallel** — Define API/data contracts BEFORE spawning parallel agents
3. **Wave size limit** — Max 5 agents per wave (cognitive limit for MumuX to track)
4. **Gate between waves** — MumuX reviews all HANDOFF.json files before spawning next wave

### Example: 12-Agent Feature Delivery

```
Wave 1 (Parallel — 4 agents, 30 min):
  Moses → API endpoints
  Levi → DB schema
  Miriam → UI wireframes
  Nathan → Requirements review

    ↓ MumuX gate: review 4 HANDOFF.json files

Wave 2 (Parallel — 5 agents, 45 min):
  David → Frontend (uses Moses' API contract)
  Isaiah → AI integration (uses Levi's schema)
  Michael → Security review (uses Nathan's spec)
  Silas → Mobile (uses Miriam's wireframes)
  Ezra → Server config

    ↓ MumuX gate: integration check

Wave 3 (Sequential — 3 agents):
  Titus → QA full regression
  Gideon → Deploy staging
  Samuel → NOC verify production
```

Total: 12 agents, 3 waves, ~2.5 hours. Without waves: 12 agents running loose = 6 hours of conflicts.

---

## Workstream Namespacing (20–35 Agents)

At 20+ agents, you're running multiple parallel features. Use workstreams to prevent `.planning/` conflicts:

```
.planning/
├── workstreams/
│   ├── ws-ai-dashboard/         ← Feature A team (6 agents)
│   │   ├── STATE.md
│   │   ├── PLAN-01.md
│   │   └── phases/
│   ├── ws-payment-api/          ← Feature B team (5 agents)
│   │   ├── STATE.md
│   │   └── phases/
│   └── ws-security-audit/       ← Infra team (4 agents)
│       ├── STATE.md
│       └── phases/
└── STATE.md                     ← MumuX master view
```

**MumuX master STATE.md tracks:**
```markdown
## Active Workstreams (2026-04-02)
| Workstream | Lead Agent | Wave | Status | ETA |
|---|---|---|---|---|
| ws-ai-dashboard | Moses | Wave 2 | In Progress | 14:00 |
| ws-payment-api | David | Wave 1 | Planning | 16:00 |
| ws-security-audit | Michael | Solo | Review | 12:00 |
```

---

## Agent Pool Management (35–50 Agents)

At this scale, treat agents like a resource pool, not a fixed org chart.

### Pool Types

**Execution Pool** — Can be spawned for any task in their domain:
- Backend Pool: Moses, Elijah-BE, Caleb
- Frontend Pool: David, Silas-Web, Thomas
- QA Pool: Titus, Elijah-QA, Gam, Aom

**Specialist Pool** — Only for specific tasks:
- Security: Michael, Obadiah (pentest only)
- DBA: Levi (schema changes only)
- Infra: Noah, Ephraim

**Coordination Pool** — Never spawn for execution:
- MumuX (Coordinator)
- Joshua (PM — tracking only)
- Hannah (BI — reporting only)

### Pool Spawn Rules

```markdown
1. Check pool availability before spawning (sessions_list)
2. Max 2 agents from same pool per wave (prevent interference)
3. Specialist pool: get explicit approval from MumuX before spawn
4. Coordination pool: NEVER spawn for code execution tasks
```

---

## Anti-Patterns at Scale

### The Spawn Storm
**Problem:** Spawn 15 agents simultaneously for a big feature  
**Symptoms:** Context overflow, agents working on same files, cost explosion  
**Fix:** Max 5 per wave. Gate between waves. Always.

### The Invisible Agent
**Problem:** Spawn agent, forget about it, it runs for 30 minutes on the wrong thing  
**Symptoms:** Wasted tokens, conflicting changes in git  
**Fix:** Every spawn → POST to team.ruk-com.ai/api/agent-activity. Check `subagents list` every 10 min.

### The Bottleneck Coordinator
**Problem:** Everything routes through MumuX, who becomes the slowest link  
**Symptoms:** Agents waiting idle, MumuX context grows huge  
**Fix:** Delegate coordination to Wave Leads. Moses owns Wave 1 completion. David owns Wave 2 start signal.

### The Shared State Race
**Problem:** Two agents write to the same file at the same time  
**Symptoms:** Git conflicts, one agent's work overwrites the other's  
**Fix:** File ownership per wave. Each file has exactly one writer per wave. Declare in PLAN.md.

### The Approval Bottleneck
**Problem:** Every decision waits for CEO approval  
**Symptoms:** Agents blocked for hours waiting on human  
**Fix:** Define Decision Authority Matrix:
- Code changes ≤ 100 lines: MumuX autonomous
- New API endpoints: Nathan/SA review (no CEO needed)
- New external service: CEO approval required
- DB schema change: Levi + MumuX (no CEO needed)

---

## Monitoring at Scale

### Real-Time Dashboard
Always report to `team.ruk-com.ai/api/agent-activity`. This is your command center.

### MumuX Status Check Protocol (every 5 min during active work)
```bash
# Quick check without polling loop:
# 1. sessions_list (activeMinutes=10) → see what's running
# 2. Check team.ruk-com.ai dashboard
# 3. Read latest HANDOFF.json from any completed waves
```

### Escalation Triggers
Escalate to CEO when:
- Agent stuck > 10 minutes with no output
- WAITING.json created (decision required)
- QA fails 3+ times on same task
- Cost > $5 on single task (something is looping)

---

## Scaling Checklist

Before adding more agents, verify:

- [ ] HANDOFF.json workflow is working reliably
- [ ] Workstream namespacing is set up
- [ ] File ownership declared in PLAN.md per wave
- [ ] team.ruk-com.ai dashboard showing all active agents
- [ ] Decision Authority Matrix defined
- [ ] Wave size ≤ 5 agents enforced
- [ ] MumuX has master STATE.md with all workstreams

---

## Cost Management at Scale

50 agents × 30 min tasks = significant token cost. Control it:

| Strategy | Implementation |
|---|---|
| Fast Mode first | 1-file tasks use Fast Mode (no planning overhead) |
| Spawn only on demand | Don't pre-spawn agents "just in case" |
| Context size limits | PLAN.md ≤ 2,000 words, agent instruction ≤ 4,000 words |
| Wave gates | Stop waves early if quality issues detected |
| Reuse vs respawn | Check if an existing session can handle the task before spawning new |

---

*Part of GSD-OpenClaw — multi-agent GSD workflow for OpenClaw*  
*Ruk-Com virtual team architecture — 39+ agents, wave-based execution*
