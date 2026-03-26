# Wave Execution Guide — Parallel Agent Orchestration

## Introduction
Wave-based execution is the core of GSD-OpenClaw's ability to scale. Instead of running tasks one by one, we group independent tasks into "Waves" and run them in parallel.

## Wave Structure

### Wave 1: Foundation (Independent)
Tasks that don't depend on any other tasks in the current phase.
- **Examples:** DB Schema, API Route definitions, Utility functions, UI Components (stateless).
- **Orchestration:** Spawn 3-5 agents simultaneously.

### Wave 2: Implementation (Dependent on Wave 1)
Tasks that require the foundation built in Wave 1.
- **Examples:** Business logic (using DB/API), UI Integration (using components), Authentication middleware.
- **Orchestration:** Wait for ALL Wave 1 tasks to pass verification before spawning.

### Wave 3: Integration & Final Polish
Tasks that tie everything together.
- **Examples:** End-to-end flow, Dashboard assembly, Multi-module wiring.
- **Orchestration:** Usually a single lead agent or a smaller group.

## Best Practices

1. **Clean Dependencies:** If Task B needs Task A, they MUST be in different waves or Task B must explicitly wait.
2. **Atomic Verification:** Each task must be verifiable independently.
3. **STATE.md Updates:** The Coordinator (MumuX) must update the `STATE.md` after each wave completes.
4. **Handoff Files:** Use `HANDOFF.json` between waves if context transition is complex.

## Troubleshooting Parallel Waves

- **Circular Dependencies:** Detected during the Plan Verification stage. Must be resolved by splitting tasks.
- **Environment Conflicts:** Use different directories or branch-based worktrees for each agent to prevent file locking issues.
- **API Mismatch:** Strictly follow the `PLAN.md` schema to ensure parallel-built pieces fit together.

---
*Version: 1.0 | Added: 2026-03-26*
