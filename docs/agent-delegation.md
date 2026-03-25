# 👥 Agent Delegation & Orchestration

> **Rule:** The coordinator agent NEVER does the work. It delegates, quality-checks, and reports.

In a multi-agent team, the coordinator is the CEO's Chief of Staff — not a developer, not a tester, not a designer. Its job is to put the right agent on the right task and ensure quality output.

---

## Delegation Principles

### 1. Match Task to Expertise

Every task should go to the agent with the most relevant expertise:

```
CEO Request: "Build a user authentication system"

❌ Wrong: Coordinator writes the code itself
✅ Right: Coordinator orchestrates:
   → Backend Dev Agent: API endpoints + JWT logic
   → Frontend Dev Agent: Login/Register UI
   → Security Agent: Review auth implementation
   → QA Agent: Full security + functional testing
```

### 2. Never Self-Execute

The coordinator agent should:
- ✅ Create plans and specifications
- ✅ Spawn specialized agents
- ✅ Review and quality-check results
- ✅ Report verified results to stakeholders
- ❌ Write code
- ❌ Run tests
- ❌ Design interfaces
- ❌ Perform security audits

### 3. Quality Gate Before Reporting

```
Dev Agent → "Feature done!" → QA Agent → "3 bugs found" → Dev Agent → "Fixed"
→ QA Agent → "All pass ✅" → Coordinator → Report to stakeholder

NEVER:
Dev Agent → "Feature done!" → Coordinator → Report to stakeholder
                                              ↑ QA SKIPPED = BAD
```

---

## Agent Pool Architecture

### Recommended Team Structure

```
Coordinator (1)
├── Dev Pool
│   ├── Backend Agents (3-7)
│   ├── Frontend Agents (3-7)
│   └── Mobile Agent (1-2)
├── QA Pool (2-4)
├── UX/UI Pool (2-4)
├── Security Pool (1-2)
├── Architecture (1-2)
│   ├── Solution Architect
│   └── Pre-Sales SA
├── Operations
│   ├── DevOps Agent
│   ├── SysAdmin Agent
│   └── Cron Manager
└── Business
    ├── Sales/BD Agents
    ├── Content/Marketing
    └── Project Manager
```

### Model Assignment Strategy

Not every agent needs the most expensive model:

| Agent Type | Recommended Model | Why |
|-----------|------------------|-----|
| Dev (coding) | High-end (Opus/Sonnet) | Code quality matters |
| QA (testing) | High-end (Opus/Sonnet) | Needs deep analysis |
| UX/UI (design) | High-end (Opus/Sonnet) | Creative + technical |
| Coordinator | High-end (Opus/Sonnet) | Strategic decisions |
| Cron jobs | Fast/cheap (Flash) | Routine tasks |
| Monitoring | Fast/cheap (Flash) | Simple checks |
| Content | Mid-tier (Sonnet) | Good enough for writing |
| Security | High-end (Opus) | Zero tolerance for mistakes |

---

## Delegation Templates

### Spawn a Dev Agent
```markdown
## Task: [Feature Name]
**Agent:** [Name] ([Role])
**Branch:** feat/[feature-name]

### Context
[Brief project context — keep under 500 words]

### Plan
[Link to or inline the PLAN.md tasks for this agent]

### API Schema
[If applicable — exact field names, types, endpoints]

### Rules
1. Follow Conventional Commits
2. No hardcoded credentials
3. Run `git diff --cached` before commit
4. Create SUMMARY.md when done
5. Do NOT merge — QA first
```

### Spawn a QA Agent
```markdown
## QA Task: [Feature Name]
**Agent:** [Name] (QA)
**URL:** [Test environment URL]

### What to Test
[Feature description + expected behavior]

### Test Account
Create a new test account. Do NOT use admin accounts.

### Checklist
Use the 10-section QA report format.

### Viewports
Desktop: 1920x1080, 1366x768
Mobile: 390x844, 360x800

### Previous Phase Tests
Also run: [List of previous phase test suites for regression]
```

---

## Wave-Based Parallel Delegation

Maximize throughput by spawning independent agents in parallel:

```
Wave 1 (spawn together — no dependencies):
├── Agent A: Backend API endpoints
├── Agent B: Database schema + migrations
└── Agent C: Authentication middleware

Wait for Wave 1 completion...

Wave 2 (depends on Wave 1):
├── Agent D: Frontend pages (needs API from A)
└── Agent E: Integration tests (needs schema from B)

Wait for Wave 2 completion...

Wave 3 (integration):
└── Agent F: End-to-end wiring + smoke tests

QA Wave:
└── QA Agent: Full 10-section QA
```

---

## Communication Pattern

### Agent → Coordinator (task complete)
```
📬 Result from [Agent Name] ([Role]):
- ✅ Completed: [task description]
- 📁 Files modified: [list]
- ⚠️ Notes: [any concerns or deviations from plan]
- 🔗 Branch: feat/[branch-name]
```

### Coordinator → Stakeholder (after QA pass)
```
✅ [Feature Name] — QA Passed

Summary: [What was built]
QA Result: [PASS/CONDITIONAL PASS]
Deploy: [Ready/Needs action]
```

### Coordinator → Stakeholder (QA failed, in progress)
```
🔄 [Feature Name] — QA Found [N] bugs, Dev fixing

Bugs: [Brief list]
ETA: [When fix expected]
```

---

## Anti-Patterns

| ❌ Don't | ✅ Do |
|----------|------|
| Coordinator writes code | Delegate to Dev Pool |
| Report before QA | Always QA first |
| One agent does everything | Specialize by role |
| Vague instructions | Structured task with plan + schema |
| Skip handoff docs | Always create HANDOFF.json |
| Same agent for Dev + QA | Different agents = fresh perspective |

---

*Running a 59-agent virtual team across 5+ projects simultaneously.*
