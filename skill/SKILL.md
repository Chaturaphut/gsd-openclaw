# GSD-OpenClaw Skill

## Metadata
- **name:** gsd-openclaw
- **version:** 1.5.0
- **description:** Spec-driven development workflow for multi-agent teams. Brings GSD methodology to OpenClaw with wave-based execution, handoff protocols, and quality gates.
- **author:** Chaturaphut
- **tags:** workflow, development, gsd, multi-agent, planning, qa, ci-cd

## When to Use
Use this skill when:
- Starting a new development project or feature
- Planning multi-phase development work
- Coordinating multiple agents on the same codebase
- Following spec-driven development methodology
- Need structured planning → research → execute → QA workflow

Trigger phrases: "GSD workflow", "spec-driven", "create a plan", "start a project", "multi-agent development", "wave execution"

## Instructions

### Setup
Before starting any development task, read the GSD workflow document:

```
Read: config/gsd-openclaw/workflow/gsd-workflow.md
```

This is the **complete workflow specification**. Follow it for every task.

### Task Sizing
Determine the right workflow level:

1. **🏎️ Fast Mode** — 1 file, ≤20 lines change
   - Skip planning and research
   - Make the change, spot-check, done

2. **🚗 Quick Mode** — ≤3 files, no new API
   - Brief plan (mental or 1-paragraph)
   - Full QA after execution

3. **🚀 Full GSD** — >3 files OR new API
   - Full workflow: Requirements → Research → Plan → Execute (Waves) → QA
   - Mandatory for complex work

### Workflow Stages

#### Stage 1: Requirements
Create `.planning/REQUIREMENTS.md`:
- Clear WHAT, not HOW
- v1 (must-have) / v2 (nice-to-have) / out-of-scope
- Measurable success criteria

#### Stage 2: Research (Parallel)
Spawn research agents for:
- Stack/library options
- Architecture patterns
- Known pitfalls and edge cases
- Domain/business logic

Output: `.planning/RESEARCH.md` (≤3,000 words)

#### Stage 3: Plan
Create `PLAN.md` with wave-based tasks:
- Each task: Files, Dependencies, Action steps, Verify, Done When
- Group independent tasks in same wave
- **Verify plan before executing** — check requirements coverage

#### Stage 4: Execute (Waves)
Run tasks in parallel waves:
- Wave 1: Independent foundation tasks
- Wave 2: Integration (depends on Wave 1)
- Wave 3: Polish and end-to-end

Each agent creates `HANDOFF.json` when done.

#### Stage 5: QA & Verify
- Verify against plan acceptance criteria
- Run regression gate (test previous phases)
- Stub detection (grep for TODO/FIXME/PLACEHOLDER)
- Cross-check API schemas between frontend/backend

### Quality Gates
1. **Requirements Coverage** — Every requirement maps to a task
2. **Stub Detection** — No TODO/FIXME in production code
3. **Regression Gate** — Previous phase tests still pass
4. **Handoff Protocol** — HANDOFF.json with completedTasks, decisions, blockers

### Tools Available
The skill includes these tools:

- **Auto-Plan Generator:** `tools/auto-plan/generate-plan.sh`
- **Issue Sync:** `integrations/sync-script.sh`
- **Analytics:** `tools/analytics/collect-metrics.sh`
- **Visualization:** `tools/visualize/generate-mermaid.sh`
- **Status Dashboard:** `tools/visualize/workflow-status.sh`
- **Web Dashboard:** `dashboard/index.html`
- **CI Templates:** `ci-templates/`

### Key Principles
1. **Plan before code** — No execution without a verified plan (Full GSD)
2. **Wave parallelism** — Maximize throughput with dependency-aware waves
3. **Clean handoffs** — Every session ends with HANDOFF.json
4. **Regression prevention** — QA tests all phases, not just current
5. **No stubs in production** — TODO/FIXME = bug
6. **Right-sized workflow** — Don't over-plan simple changes

## References
- Full workflow: `workflow/gsd-workflow.md`
- Documentation: `docs/`
- Templates: `templates/`
- Examples: `examples/`
