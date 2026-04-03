<p align="center">
  <img src="assets/gsd-openclaw-banner.png" alt="GSD-OpenClaw Banner" width="800" />
</p>

<h1 align="center">🚀 GSD-OpenClaw</h1>

<p align="center">
  <strong>Spec-Driven Development for Multi-Agent Teams</strong><br/>
  A structured workflow framework that brings <a href="https://github.com/gsd-build/get-shit-done">Get Shit Done (GSD)</a> methodology to <a href="https://openclaw.ai">OpenClaw</a> multi-agent orchestration.
</p>

<p align="center">
  <a href="#-features"><img src="https://img.shields.io/badge/features-80+-blue?style=for-the-badge" alt="Features" /></a>
  <a href="#-quick-start"><img src="https://img.shields.io/badge/setup-5_min-green?style=for-the-badge" alt="Quick Start" /></a>
  <a href="CHANGELOG.md"><img src="https://img.shields.io/badge/version-1.13.0-purple?style=for-the-badge" alt="Version" /></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-orange?style=for-the-badge" alt="License" /></a>
  <a href="https://github.com/gsd-build/get-shit-done"><img src="https://img.shields.io/badge/based_on-GSD_by_TÂCHES-ff6b6b?style=for-the-badge" alt="Based on GSD" /></a>
</p>

<p align="center">
  <em>Built on top of <a href="https://github.com/gsd-build/get-shit-done"><strong>Get Shit Done (GSD)</strong></a> by <a href="https://github.com/gsd-build">TÂCHES</a> — the original spec-driven development system for AI coding agents.</em>
</p>

---

## 🤔 What Is This?

**GSD-OpenClaw** adapts the [Get Shit Done](https://github.com/gsd-build/get-shit-done) spec-driven development methodology for **OpenClaw's multi-agent architecture** — where you don't have one developer, you have an entire virtual team of AI agents working in parallel.

### The Problem

When you orchestrate multiple AI agents (developers, QA, architects, UX designers), things go sideways fast:

- 🔀 **Field name mismatches** between frontend and backend agents
- 🔁 **QA loops 3-5 rounds** because the spec wasn't clear
- 🧠 **Context rot** in long sessions — agent output quality degrades
- 🤷 **No handoff protocol** — next agent doesn't know what the previous one did
- 📋 **Scope creep** — agents add features nobody asked for

### The Solution

GSD-OpenClaw provides a **structured workflow** that forces planning before coding:

```
📋 Requirements → 🔬 Research → 📐 Plan → ⚡ Execute (Waves) → 🧪 QA → ✅ Ship
```

Every stage has clear inputs, outputs, owners, and verification gates — specifically designed for **agent-to-agent handoffs**.

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🎯 **Spec-Driven Development** | No more "just wing it" — every task starts with requirements and a verified plan |
| 🌊 **Wave-Based Execution** | Parallel task groups with dependency tracking — maximize agent throughput |
| 📦 **Session Handoff Protocol** | `HANDOFF.json` ensures clean context transfer between agent sessions |
| 🧪 **Cross-Phase Regression Gate** | QA tests previous phases too — catch regressions early |
| ✅ **Requirements Coverage Gate** | Plan verification ensures every requirement maps to a task |
| 🔍 **Stub Detection** | Catches TODO/FIXME/placeholder code before it reaches production |
| ⚡ **3-Tier Task Sizing** | Fast / Quick / Full GSD — right-sized workflow for every task |
| 🔀 **Workstream Namespacing** | Run multiple milestones in parallel without `.planning/` conflicts |
| 🔬 **Post-Mortem Forensics** | Structured investigation when workflows go wrong |
| 👥 **Role-Based Ownership** | Clear responsibilities: Coordinator, Architect, Dev Pool, QA Pool, UX Pool |
| 📊 **Context Size Limits** | Prevents context window overflow with document size caps |
| 🔄 **Upstream Tracking** | Stay current with GSD releases — cherry-pick what matters |
| 🔑 **Credential Security** | Git-leaks integration, pre-commit scans, `.gitignore` patterns |
| 🔒 **OWASP Secure Coding** | Input validation, parameterized queries, XSS/injection prevention |
| 🔐 **Permission Registration** | 4-point pattern: constants → guards → menu → role management UI |
| 🐳 **Docker Standards** | Compose-first deployment, health checks, deploy scripts |
| 🧪 **Unit Testing Standards** | Coverage requirements, AAA pattern, mock strategies |
| 🧠 **Context Management** | Memory architecture, handoff protocol, document size limits |
| 🚫 **Error Handling** | Retry-before-report, model fallback, user-friendly errors |
| 📖 **API Documentation** | Every endpoint documented, Swagger integration |
| 🔀 **Git Branch Flow** | Protected main, Conventional Commits, squash merge |
| 👥 **Agent Delegation** | Role-based pools, wave orchestration, communication templates |
| 🌊 **Wave Execution Guide** | Patterns for parallel agent orchestration and dependency management |
| 💉 **Agent Skill Injection** | Inject project-specific skills into sub-agents via config |
| 🎨 **UI-Phase & UI-Review** | Formalized autonomous workflow steps for frontend development |
| 🤝 **Handoff Best Practices** | HANDOFF.json contract, API contract injection, multi-wave chain patterns |
| 📈 **Scaling Agents Guide** | From 5 to 50 agents: pool management, wave design, anti-patterns, cost control |
| 🚑 **Bugfix / Hotfix Fast-Track** | Triage decision tree, Hotfix vs Regression paths, forensics template and agent delegation for production bugs |
| 🛠️ **Troubleshooting Guide** | Top 10 multi-agent workflow failures — root causes, fixes, and prevention patterns |
| 🛡️ **Security Scanning CI** | Automated prompt injection and secret scanning in CI pipeline |
| 🧭 **Advisor Mode** | Lightweight parallel agent analysis for gray areas before decisions |
| 📋 **Milestone Summary** | Post-build onboarding and feature summaries for completed milestones |
| ⏳ **Decision Waiting Signal** | `WAITING.json` machine-readable signal for decision points |
| 🌱 **Plant Seed / Persistent Threads** | Backlog and context thread persistence in `.planning/seeds/` |
| 📝 **Enhanced Templates** | Ready-to-use templates: CONTEXT, MILESTONE-SUMMARY, WAITING, PLAN with acceptance criteria |
| 🔧 **CI/CD Pipeline Templates** | Pre-built GitHub Actions & GitLab CI with GSD-integrated stages |
| 🔗 **Issue Tracker Integration** | Auto-create/link/close GitHub & GitLab issues from .planning/ |
| 📐 **Auto-Plan Generation** | Generate draft PLAN.md from REQUIREMENTS.md + RESEARCH.md |
| 📊 **Agent Performance Analytics** | Track QA pass rate, rework cycles, regressions per workflow |
| 🎨 **Workflow Visualization** | Mermaid diagrams + terminal dashboard for workflow state |
| 💻 **Interactive Dashboard** | Single-file HTML dashboard — no build required, dark theme |
| 📦 **OpenClaw Skill Package** | Auto-install via ClawHub with post-install setup |
| 📊 **Agent Performance Profiling** | Per-agent metrics tracking for smarter delegation |
| 🚀 **Ship Workflow** | Standardized PR/MR creation with auto-generated descriptions |
| ⏩ **Auto Advance** | State machine that auto-progresses through workflow stages |
| 🤝 **Interactive Executor** | Pair-programming mode with human review at each task |
| 🔧 **MCP Tool Awareness** | Discover and use MCP tools in GSD workflows |
| 🛡️ **Execution Hardening** | Pre-wave dependency checks and cross-plan data contracts |
| 🏢 **Multi-Repo Workspace** | Manage multiple GSD projects with cross-project dependencies |
| ⚡ **Fast Inline Mode** | Skip planning for trivial single-file changes |
| 🔍 **Cross-AI Peer Review** | Different model reviews code before QA |
| 🌿 **Clean PR Branch** | Create clean branches with squashed commits |
| 📋 **Verification Debt** | Track untested features with debt scoring |
| 💬 **Discussion Audit Trail** | Decision log template for full traceability |
| 🧠 **Context Window Optimization** | Strategies to maximize quality within context limits |
| 🔐 **Security Hardening** | Prompt injection, path traversal, and exfiltration guards |
| ⚙️ **Workflow Configuration** | Fine-tune every aspect of GSD behavior via config.json |
| 🔄 **Data-Flow Tracing** | Trace data through the system during verification |
| 🧹 **Temp File Reaper** | Auto-cleanup of temp/debug files before shipping |
| 🤖 **GSD SDK** | Headless autonomous execution with blueprints and safety rails |
| 📝 **SDK Blueprints** | Pre-configured project templates for batch execution |
| 🌊 **Windsurf Runtime** | Full support for Windsurf (Codeium) agent environment |
| 📝 **Verified Doc Gen** | Automated workflow to maintain code-to-doc consistency via `/gsd:docs-update` |
| 🏗️ **Project Prefixing** | Namespace phase directories in shared workspaces via `project_code` config |
| 🛡️ **Security Enforcement** | Post-execution security audit stage anchored to project threat models |
| 🔗 **Chain Mode** | Seamless discuss-to-execute flow with the `--chain` flag |
| 🍳 **Feature Recipes** | Step-by-step guides for common full-stack development patterns |

---

## 📁 Project Structure

```
gsd-openclaw/
├── workflow/
│   └── gsd-workflow.md         # Core workflow specification
├── docs/                       # 27 comprehensive guides
├── recipes/                    # Step-by-step feature patterns (5 recipes)
├── templates/                  # Planning document templates
├── ci-templates/               # GitHub Actions & GitLab CI pipelines
├── integrations/               # Issue tracker sync (GitHub/GitLab)
├── tools/
│   ├── auto-plan/              # Plan generation from requirements
│   ├── analytics/              # Agent performance metrics
│   ├── audit-uat/              # Verification debt auditor
│   ├── temp-reaper/            # Temp file cleanup
│   └── visualize/              # Mermaid diagrams & terminal dashboard
├── dashboard/                  # Interactive web dashboard
├── skill/                      # OpenClaw Skill package for ClawHub
├── examples/                   # Example configurations
└── scripts/                    # Utility scripts

your-project/
└── .planning/
    ├── PROJECT.md              # Vision, scope, tech stack
    ├── REQUIREMENTS.md         # v1/v2/out-of-scope
    ├── ROADMAP.md              # Phases mapped to requirements
    ├── STATE.md                # Current state & blockers
    ├── config.json             # Workflow settings
    ├── phases/
    │   ├── phase-1-api-setup/
    │   │   ├── CONTEXT.md      # Implementation decisions
    │   │   ├── RESEARCH.md     # Technical research & pitfalls
    │   │   ├── PLAN-01.md      # Atomic task plan
    │   │   ├── UI-SPEC.md      # Design contract (if UI)
    │   │   ├── SUMMARY.md      # What was built
    │   │   ├── HANDOFF.json    # Session handoff artifact
    │   │   ├── FORENSICS.md    # Post-mortem (if needed)
    │   │   └── QA.md           # QA report
    │   └── phase-2-frontend/
    │       └── ...
    ├── workstreams/            # Parallel milestone work
    ├── research/               # Domain research cache
    ├── quick/                  # Ad-hoc task plans
    ├── threads/                # Cross-session context
    └── seeds/                  # Backlog items & persistent context threads
```

---

## ⚡ Quick Start

### 1. Install

Clone this repo into your OpenClaw workspace:

```bash
cd ~/.openclaw/workspace
git clone https://github.com/Chaturaphut/gsd-openclaw.git config/gsd-openclaw
```

Or copy the workflow file directly:

```bash
# Copy just the workflow file
curl -o config/gsd-workflow.md \
  https://raw.githubusercontent.com/Chaturaphut/gsd-openclaw/main/workflow/gsd-workflow.md
```

### 2. Reference in Your Agent Config

Add to your `AGENTS.md` or `RULES.md`:

```markdown
## GSD Workflow
- Full doc: `config/gsd-openclaw/workflow/gsd-workflow.md`
- Every Dev task must follow: Spec → Research → Plan → Execute → QA
- Quick Mode: ≤3 files + no new API
- Fast Mode: 1 file, ≤20 lines change
```

### 3. Create Your First Project Plan

```markdown
# .planning/PROJECT.md

## Project: My Feature
- **Goal:** [What you're building]
- **Tech Stack:** [Your stack]
- **Constraints:** [Timeline, dependencies]
- **Success Criteria:** [How to measure done]
```

### 4. Let Your Agents Work

Your coordinator agent (or you) orchestrates the workflow:

```
1. Define requirements → REQUIREMENTS.md
2. Spawn research agents → RESEARCH.md
3. Create plan → PLAN-01.md (verify before execute!)
4. Execute in waves → Dev agents work in parallel
5. QA verification → QA.md report
6. Ship it 🚀
```

---

## 🔄 Workflow Stages

### Stage 0: Map Codebase (Brownfield Only)
> When adding features to existing projects

Analyze the existing codebase and document:
- `STACK.md` — Tech versions & frameworks
- `ARCHITECTURE.md` — Project structure & patterns
- `CONVENTIONS.md` — Naming & formatting standards
- `CONCERNS.md` — Known tech debt & fragile areas

### Stage 1: Define Requirements
> Every project starts here

| Check | Description |
|-------|-------------|
| ✅ Goals | Clear WHAT, not HOW |
| ✅ Scope | v1 (must) / v2 (nice-to-have) / out-of-scope |
| ✅ Constraints | Tech stack, timeline, dependencies |
| ✅ Success Criteria | Measurable outcomes |

### Stage 2: Research (Parallel)
> Spawn 2-4 researcher agents simultaneously

- **Stack Researcher** — Library options, version compatibility
- **Architecture Researcher** — Design patterns, data flow
- **Pitfalls Researcher** — Common mistakes, edge cases, security
- **Domain Researcher** — Business logic, industry standards

Output: `RESEARCH.md` (≤3,000 words — actionable insights only)

### Stage 3: Plan
> The most critical stage — get this right, everything flows

```markdown
## Task 1: [name]
- **Files:** [list of files to create/modify]
- **Dependencies:** [other tasks that must complete first]
- **Wave:** [1/2/3 — parallel grouping]
- **Action:** Step-by-step implementation instructions
- **Verify:** How to test this task
- **Done When:** Acceptance criteria
```

**Plan Verification Checklist:**
- [ ] Every requirement has a mapped task
- [ ] No scope creep beyond v1
- [ ] API schemas match between frontend/backend tasks
- [ ] Dependencies are acyclic and complete
- [ ] File paths match project structure
- [ ] No field name mismatches (!!!)

### Stage 4: Execute (Wave-Based)
> Maximize parallelism, respect dependencies

```
Wave 1: Independent tasks (parallel)
         Task A (Backend API)  |  Task B (DB Schema)
                    ↓                     ↓
Wave 2: Depends on Wave 1
         Task C (Frontend — needs API from Task A)
                    ↓
Wave 3: Integration
         Task D (Wire up + end-to-end test)
```

### Stage 5: QA & Verify
> Against the plan, not just "does it look right"

- Verify against `PLAN.md` done criteria
- Compare UI vs API schema from plan
- Check every edge case from `RESEARCH.md`
- Run previous phase test suites (regression gate)
- Grep for stubs/TODOs in production code

---

## ⚡ Task Sizing Guide

| Mode | When | Plan | Research | QA |
|------|------|------|----------|-----|
| 🏎️ **Fast** | 1 file, ≤20 lines | ❌ Skip | ❌ Skip | Spot check |
| 🚗 **Quick** | ≤3 files, no new API | Brief plan | ❌ Skip | Full QA |
| 🚀 **Full GSD** | >3 files or new API | Full plan | ✅ Required | Full QA |

---

## 📦 Session Handoff Protocol

When an agent completes a phase, it creates `HANDOFF.json`:

```json
{
  "phase": "phase-1-api-setup",
  "status": "complete",
  "completedTasks": ["task-1", "task-2", "task-3"],
  "pendingTasks": [],
  "decisions": [
    {
      "id": "D001",
      "summary": "Used Redis for session caching",
      "reason": "10x faster than DB-backed sessions"
    }
  ],
  "blockers": [],
  "nextSteps": ["Start phase-2 frontend integration"],
  "modifiedFiles": [
    "src/api/routes.ts",
    "src/services/auth.ts",
    "src/middleware/session.ts"
  ],
  "timestamp": "2026-03-26T10:00:00Z"
}
```

The next agent reads this before starting — **no context lost between sessions**.

---

## 🔍 Quality Gates

### Requirements Coverage Gate
Before executing a plan, verify every requirement maps to at least one task:
```
✅ Requirement 1 → Task 2, Task 5
✅ Requirement 2 → Task 1
✅ Requirement 3 → Task 3, Task 4
❌ Requirement 4 → NO TASK MAPPED ← Block execution!
```

### Stub Detection
QA agents grep for incomplete implementations before accepting work:
```bash
grep -rn "TODO\|FIXME\|HACK\|PLACEHOLDER\|Not implemented\|// stub" src/
```
Found in production code = **BUG** → sent back to developer.

### Cross-Phase Regression Gate
After Phase N execution, QA runs Phase 1..N-1 test suites:
```
Phase 3 complete → Run Phase 1 tests ✅ → Run Phase 2 tests ✅ → Phase 3 tests ✅ → PASS
Phase 3 complete → Run Phase 1 tests ✅ → Run Phase 2 tests ❌ → REGRESSION → Fix first
```

---

## 📊 Context Size Limits

To prevent context window overflow and output quality degradation:

| Document | Max Size | Notes |
|----------|----------|-------|
| `PROJECT.md` | 2,000 words | Vision only |
| `REQUIREMENTS.md` | 3,000 words | Bullet points |
| `RESEARCH.md` | 3,000 words | Actionable findings |
| `PLAN.md` (per plan) | 2,000 words | One plan per task group |
| Agent instruction | 4,000 words | Plan + context combined |
| `SUMMARY.md` | 1,000 words | What changed, not why |

---

## 👥 Role Assignments

GSD-OpenClaw is designed for teams with these roles:

| Role | Responsibility |
|------|---------------|
| 🎯 **Coordinator** | Requirements, plans, wave orchestration, STATE.md tracking |
| 🏗️ **Solution Architect** | Plan verification, API schema review, architecture fit |
| 💻 **Dev Pool** | Execute tasks per PLAN.md — no scope changes without approval |
| 🧪 **QA Pool** | Verify against plan criteria, regression testing, stub detection |
| 🎨 **UX Pool** | UI-SPEC creation, design review, responsive verification |

---

## 🆚 GSD-OpenClaw vs Original GSD

| Aspect | Original GSD | GSD-OpenClaw |
|--------|-------------|--------------|
| **Target** | Single developer + Claude Code | Multi-agent teams on OpenClaw |
| **Execution** | Sequential | Wave-based parallel execution |
| **Handoff** | Session-based | `HANDOFF.json` protocol |
| **QA** | Verification phase | Full QA loop with regression gates |
| **Roles** | Developer + AI | Coordinator + SA + Dev Pool + QA Pool + UX Pool |
| **Task Sizing** | Full vs lightweight | 3-tier: Fast / Quick / Full |
| **Parallel Work** | Single milestone | Workstream namespacing |
| **Context** | Managed by GSD CLI | Size limits + handoff artifacts |

---

## 📚 Documentation

Comprehensive guides for every aspect of multi-agent development:

| Guide | Description |
|-------|-------------|
| [🔑 Credential Security](docs/credential-security.md) | Git-leaks integration, pre-commit scans, config patterns — keep secrets out of code |
| [🔀 Git Branch Flow](docs/git-branch-flow.md) | Protected branches, Conventional Commits, MR workflow for AI agents |
| [🧪 QA Standards](docs/qa-standards.md) | 10-section QA report, UI clickthrough, responsive testing, security testing |
| [🔒 Secure Coding](docs/secure-coding.md) | OWASP Top 10 for AI-generated code, input validation, XSS, injection prevention |
| [👥 Agent Delegation](docs/agent-delegation.md) | Orchestration patterns, wave execution, model assignment, communication templates |
| [🔐 Permission Registration](docs/permission-registration.md) | 4-point permission pattern — every endpoint locked down from day one |
| [🐳 Docker Deploy](docs/docker-deploy.md) | Compose-first deployment, health checks, deploy scripts |
| [🧪 Unit Testing](docs/unit-testing.md) | Coverage requirements, AAA pattern, mocking, naming conventions |
| [🧠 Context Management](docs/context-management.md) | Document size limits, memory architecture, preventing context rot |
| [🚫 Error Handling](docs/error-handling.md) | Retry-before-report, user-facing errors, model fallback strategy |
| [🌊 Wave Execution](docs/wave-execution-guide.md) | Parallel agent orchestration patterns, dependency management, wave sizing |
| [📊 Agent Profiling](docs/agent-profiling.md) | Per-agent performance tracking for smarter delegation decisions |
| [🚀 Ship Workflow](docs/ship-workflow.md) | Standardized PR/MR creation with auto-generated descriptions |
| [⏩ Auto Advance](docs/auto-advance.md) | State machine for automatic workflow stage progression |
| [🤝 Interactive Executor](docs/interactive-executor.md) | Pair-programming mode with human review at each step |
| [🔧 MCP Tool Awareness](docs/mcp-tool-awareness.md) | Discover and leverage MCP tools in GSD workflows |
| [🛡️ Execution Hardening](docs/execution-hardening.md) | Pre-wave dependency checks and cross-plan data contracts |
| [🔀 Workstream Namespacing](docs/workstream-namespacing.md) | Parallel milestone execution, branch isolation, merge order, cross-workstream coordination |
| [🏢 Multi-Repo Workspace](docs/multi-repo-workspace.md) | Manage multiple GSD projects with portfolio coordination |
| [⚡ Fast Mode](docs/fast-mode.md) | Skip planning for trivial single-file changes |
| [🔍 Peer Review](docs/peer-review.md) | Cross-AI code review using different models |
| [🌿 PR Branch](docs/pr-branch-workflow.md) | Clean PR branch creation with squashed commits |
| [📋 Verification Debt](docs/verification-debt.md) | Track untested features and verification gaps |
| [🧠 Context Optimization](docs/context-window-optimization.md) | Maximize quality within finite context windows |
| [🔐 Security Hardening](docs/security-hardening.md) | Prompt injection, path traversal, and exfiltration guards |
| [⚙️ Workflow Settings](docs/workflow-settings.md) | Configure every aspect of GSD behavior |
| [🤖 GSD SDK](docs/gsd-sdk.md) | Headless autonomous execution with blueprints |
| [🌊 Windsurf Runtime](docs/windsurf-runtime.md) | Using GSD within the Windsurf (Codeium) environment |
| [💉 Agent Skill Injection](docs/agent-skill-injection.md) | Inject project-specific skills into sub-agents |
| [🔬 Forensics Guide](docs/forensics-guide.md) | Post-mortem investigation workflow: FORENSICS.md template, agent delegation by failure type, debug knowledge base |
| [🧭 Advisor Mode](docs/advisor-mode.md) | Research-backed decisions with parallel specialists: spawn pattern, synthesis template, agent selection matrix |
| [🛠️ Troubleshooting](docs/troubleshooting.md) | Top 10 multi-agent workflow failures — root causes, fixes, prevention |
| [🤝 Handoff Best Practices](docs/handoff-best-practices.md) | HANDOFF.json contract, receiving agent protocol, API contract injection, anti-patterns, multi-wave chain |
| [📈 Scaling Agents](docs/scaling-agents.md) | From 5 to 50 agents: pool types, wave design, spawn anti-patterns, monitoring, cost control |
| [🏗️ Legacy Migration](recipes/legacy-code-migration.md) | Step-by-step guide for migrating legacy modules with parity checking and shadow proxying |

---

## 🔧 Tools & Integrations

### Feature Recipes
Ready-to-use patterns for common tasks:
```bash
# Backend-to-Frontend Full Stack Feature
cat recipes/api-with-frontend.md

# UI Redesign & Brand Alignment
cat recipes/ui-redesign.md

# Bugfix / Hotfix Fast-Track
cat recipes/bugfix-hotfix.md

# Safe Data Migration
cat recipes/data-migration.md

# Legacy Code Migration
cat recipes/legacy-code-migration.md
```

### CI/CD Pipeline Templates
Pre-built pipelines with GSD-integrated quality gates:
```bash
# GitHub Actions
cp ci-templates/github-actions.yml .github/workflows/gsd-ci.yml

# GitLab CI
cp ci-templates/gitlab-ci.yml .gitlab-ci.yml
```

### Issue Tracker Sync
```bash
# Create issues from requirements
./integrations/sync-script.sh create-issues

# Close issues on QA pass
./integrations/sync-script.sh close-passed
```

### Auto-Plan Generation
```bash
# Generate draft PLAN.md
./tools/auto-plan/generate-plan.sh

# Get AI prompt for manual use
./tools/auto-plan/generate-plan.sh --prompt-only
```

### Performance Analytics
```bash
# Terminal report
./tools/analytics/collect-metrics.sh

# JSON for dashboard
./tools/analytics/collect-metrics.sh --format json --output metrics.json
```

### Visualization
```bash
# Terminal dashboard
./tools/visualize/workflow-status.sh --watch

# Mermaid diagrams
./tools/visualize/generate-mermaid.sh all --output diagrams.md
```

### Interactive Dashboard
```bash
# Export data and open dashboard
./dashboard/export-data.sh
open dashboard/index.html
```

### Verification Debt Audit
```bash
# Audit test coverage and verification debt
./tools/audit-uat/audit-verification.sh /path/to/project

# Save report
./tools/audit-uat/audit-verification.sh . > VERIFICATION-DEBT.md
```

### Temp File Reaper
```bash
# Preview cleanup (dry run)
./tools/temp-reaper/reap.sh . --dry-run

# Clean up temp/debug files before shipping
./tools/temp-reaper/reap.sh .
```

---

## 🗺️ Roadmap

- [x] Core workflow (Spec → Research → Plan → Execute → QA)
- [x] Wave-based parallel execution
- [x] Session Handoff Protocol (`HANDOFF.json`)
- [x] Cross-Phase Regression Gate
- [x] Requirements Coverage Gate
- [x] Stub Detection
- [x] 3-Tier Task Sizing (Fast/Quick/Full)
- [x] Workstream Namespacing
- [x] Post-Mortem Forensics
- [x] Upstream GSD Tracking (automated weekly)
- [x] Comprehensive documentation (10 guides)
- [x] Credential security with git-leaks integration
- [x] Secure coding standards (OWASP Top 10)
- [x] Permission registration pattern
- [x] Agent delegation & orchestration guide
- [x] Context management for long-running teams
- [x] Wave execution guide with orchestration patterns
- [x] Agent skill injection for sub-agents
- [x] UI-Phase and UI-Review workflow steps
- [x] Security scanning CI (prompt injection + secret scanning)
- [x] Advisor Mode for parallel analysis before decisions
- [x] Milestone Summary for post-build onboarding
- [x] Decision Waiting Signal (`WAITING.json`)
- [x] Plant Seed / Persistent Threads for backlog management
- [x] Enhanced templates (CONTEXT, MILESTONE-SUMMARY, WAITING)
- [x] Pre-built CI/CD pipeline templates (GitHub Actions + GitLab CI)
- [x] Integration with GitLab/GitHub Issues (auto-create, link, close)
- [x] Auto-plan generation from requirements
- [x] Agent performance analytics per workflow
- [x] Workflow visualization tools (Mermaid + terminal dashboard)
- [x] Interactive workflow dashboard (single-file HTML)
- [x] OpenClaw Skill package (auto-install via ClawHub)

- [x] Agent Performance Profiling for smarter delegation
- [x] Ship Workflow (`/gsd:ship`) for standardized PR creation
- [x] Auto Advance (`/gsd:next`) for automatic stage progression
- [x] Interactive Executor Mode for pair-programming
- [x] MCP Tool Awareness for tool discovery in workflows
- [x] Execution Hardening with pre-wave checks and data contracts
- [x] Multi-Repo Workspace for cross-project coordination
- [x] Fast Inline Mode (`/gsd:fast`) for trivial changes
- [x] Cross-AI Peer Review (`/gsd:review`) with different models
- [x] Clean PR Branch Creation (`/gsd:pr-branch`)
- [x] Verification Debt Tracking (`/gsd:audit-uat`)
- [x] Discussion Audit Trail (DISCUSSION-LOG.md)
- [x] Context Window Optimization strategies
- [x] Security Hardening (prompt injection, path traversal, exfiltration)
- [x] Workflow Configuration Settings (config.json)
- [x] UI-Phase Auto-Recommendation
- [x] Data-Flow Tracing and Environment Audit
- [x] Temp File Reaper tool
- [x] GSD SDK for headless autonomous execution with blueprints
- [x] Verified Documentation Generation (`/gsd:docs-update`)
- [x] Project Code Prefixing (`project_code`)
- [x] Security-First Enforcement Layer
- [x] Chain Mode (`--chain` flag)
- [x] Legacy Code Migration Recipe

### 🔮 Future
- [ ] Real-time agent monitoring via WebSocket
- [ ] Multi-project portfolio dashboard
- [ ] AI-powered plan quality scoring
- [ ] Slack/Discord notifications for workflow events
- [ ] Historical analytics and trend tracking
- [ ] Custom workflow stage plugins
- [ ] Blueprint marketplace for SDK templates
- [ ] Cross-project dependency visualization

---

## 🙏 Credits & Acknowledgments

> **This project would not exist without [Get Shit Done (GSD)](https://github.com/gsd-build/get-shit-done) by [TÂCHES](https://github.com/gsd-build).**

GSD is the original spec-driven development system that pioneered structured AI coding workflows. GSD-OpenClaw takes its core methodology — the discipline of planning before coding, verification gates, and structured documentation — and adapts it for **multi-agent orchestration** on OpenClaw.

**If you're using a single AI coding agent** (Claude Code, Cursor, Copilot, etc.), we highly recommend using **[the original GSD](https://github.com/gsd-build/get-shit-done)** directly — it's purpose-built for that use case and actively maintained with frequent updates.

**GSD-OpenClaw is for teams** that orchestrate multiple AI agents in parallel and need handoff protocols, wave-based execution, and role-based ownership on top of the GSD methodology.

- ⭐ **[GSD by TÂCHES](https://github.com/gsd-build/get-shit-done)** — The source of concept. Star the original!
- 🦞 **[OpenClaw](https://openclaw.ai)** — The AI agent platform that makes multi-agent workflows possible.

---

## 📄 License

MIT License — see [LICENSE](LICENSE) for details.

---

<p align="center">
  <strong>Stop winging it. Start shipping it.</strong><br/>
  Built with 💜 by <a href="https://github.com/Chaturaphut">Chaturaphut</a> for the OpenClaw community.
</p>
