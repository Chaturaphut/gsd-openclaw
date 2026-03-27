# 🤖 GSD SDK — Headless Autonomous Execution

> **Adapted from:** GSD v1.30 GSD SDK Concept
> **Purpose:** Run GSD workflows headlessly — fully autonomous project execution without human interaction.

---

## Overview

The GSD SDK pattern enables **headless execution** of entire GSD workflows. Instead of a human guiding the coordinator through each stage, the SDK pattern pre-configures the full workflow and lets it run autonomously from requirements to shipped PR.

This is the evolution from:
1. **Manual** — Human guides each stage
2. **Interactive** — Agent proposes, human approves
3. **Autonomous** — Agent runs, pauses at configured points
4. **SDK/Headless** — Pre-configured end-to-end execution

---

## When to Use

| Scenario | Pattern |
|----------|---------|
| New project, unknown scope | Manual or Interactive |
| Well-understood feature | Autonomous |
| Repeatable project type (e.g., "add CRUD for entity X") | **SDK/Headless** |
| CI/CD triggered builds | **SDK/Headless** |
| Batch project generation | **SDK/Headless** |

---

## SDK Configuration

### Project Blueprint

A blueprint defines everything the SDK needs to execute:

```json
{
  "blueprint": "crud-entity",
  "version": "1.0",
  "project": {
    "name": "Add Product Management",
    "description": "Full CRUD for products with search and pagination",
    "techStack": ["TypeScript", "Express", "PostgreSQL", "React"]
  },
  "requirements": {
    "v1": [
      "CRUD operations for products (name, description, price, category)",
      "Search by name with full-text search",
      "Pagination (20 items per page)",
      "Admin-only access for create/update/delete"
    ],
    "outOfScope": [
      "Image upload",
      "Bulk import/export",
      "Product variants"
    ]
  },
  "workflow": {
    "skipDiscuss": true,
    "skipResearch": false,
    "autoAdvance": true,
    "executionMode": "autonomous",
    "peerReview": { "enabled": true },
    "pauseAt": []
  },
  "shipping": {
    "createPR": true,
    "baseBranch": "main",
    "branchPrefix": "feat",
    "squash": true,
    "labels": ["gsd-sdk", "auto-generated"]
  }
}
```

### Execution Flow

```
SDK receives blueprint:
  1. Generate PROJECT.md from blueprint.project
  2. Generate REQUIREMENTS.md from blueprint.requirements
  3. Auto-advance → Research stage (spawn researchers)
  4. Auto-advance → Plan stage (generate PLAN.md)
  5. Verify plan (automated checklist)
  6. Auto-advance → Execute waves (spawn dev agents)
  7. Auto-advance → Peer review (spawn reviewer)
  8. Auto-advance → QA (spawn QA agent)
  9. If QA passes → Ship (create PR)
  10. If QA fails → Fix → Re-QA (up to 3 cycles)
  11. Report result
```

---

## OpenClaw Implementation

### Using sessions_spawn

```
Main Agent receives SDK blueprint:

1. Create .planning/ structure
2. Spawn coordinator sub-agent with full autonomy:

   sessions_spawn:
     label: "gsd-sdk-execution"
     instructions: |
       You are running a GSD SDK headless execution.
       Blueprint: [attached]
       
       Execute the full GSD workflow autonomously:
       1. Skip discussion (requirements provided)
       2. Research the tech stack
       3. Generate and verify plan
       4. Execute all waves
       5. Run peer review
       6. Run QA
       7. Create PR if QA passes
       8. Report final result
       
       Do NOT ask for human input at any point.
       If you encounter a blocker, document it in WAITING.json
       and continue with other tasks.

3. Wait for completion (push-based)
4. Report result to user
```

### Batch Execution

Run multiple SDK jobs:

```
For each entity in ["products", "orders", "customers", "invoices"]:
  1. Load CRUD blueprint template
  2. Customize with entity name + fields
  3. Spawn independent SDK execution
  4. Collect results

All 4 entities built in parallel → 4 PRs ready for review
```

---

## Blueprint Templates

### CRUD Entity Blueprint
Pre-built blueprint for adding CRUD operations:
- Generates API endpoints, DB migrations, frontend pages
- Includes auth/permission checks
- Generates tests

### Microservice Blueprint
Pre-built blueprint for new microservices:
- Service scaffold with Docker + CI/CD
- Health check endpoint
- Logging and monitoring setup
- Integration tests

### Migration Blueprint
Pre-built blueprint for data migrations:
- Schema changes with rollback
- Data transformation scripts
- Verification queries
- Zero-downtime deployment plan

---

## Safety Rails

SDK execution must have guardrails:

```json
{
  "safetyRails": {
    "maxWaves": 5,
    "maxReworkCycles": 3,
    "maxExecutionTime": "30m",
    "requirePeerReview": true,
    "blockOnSecurityIssue": true,
    "notifyOnComplete": true,
    "notifyOnFailure": true,
    "neverDeleteFiles": true,
    "neverModifyOutsideProject": true
  }
}
```

### Failure Handling

```
If any stage fails after max retries:
  1. Generate FORENSICS.md with failure analysis
  2. Save all .planning/ artifacts
  3. Report failure with context
  4. Do NOT attempt workarounds
  5. Do NOT proceed to next stage
```

---

## Monitoring SDK Execution

### Progress Reporting

The SDK executor reports progress at each stage:

```
[SDK] Stage 1/7: Requirements ✅ (0:02)
[SDK] Stage 2/7: Research ✅ (1:30)
[SDK] Stage 3/7: Plan ✅ (0:45)
[SDK] Stage 4/7: Execute Wave 1/3 ✅ (2:00)
[SDK] Stage 4/7: Execute Wave 2/3 ✅ (1:30)
[SDK] Stage 4/7: Execute Wave 3/3 ✅ (1:00)
[SDK] Stage 5/7: Peer Review ✅ (0:30)
[SDK] Stage 6/7: QA ✅ (1:00)
[SDK] Stage 7/7: Ship ✅ (0:15)
[SDK] Complete! PR: https://github.com/org/repo/pull/42
[SDK] Total time: 8:32
```

### Result Summary

```json
{
  "status": "success",
  "pr": "https://github.com/org/repo/pull/42",
  "stats": {
    "filesCreated": 12,
    "filesModified": 3,
    "testsWritten": 24,
    "testsPassing": 24,
    "qaPassed": true,
    "reviewPassed": true,
    "totalTime": "8m 32s"
  },
  "artifacts": ".planning/phases/phase-1/"
}
```

---

## Anti-Patterns

- ❌ **Don't use SDK for novel/complex projects** — Use manual or interactive mode
- ❌ **Don't skip peer review in SDK** — Autonomous code needs extra scrutiny
- ❌ **Don't run SDK without safety rails** — Always set max retries and time limits
- ❌ **Don't ignore SDK failures** — Investigate FORENSICS.md, don't just re-run

---

## Related

- [Auto Advance](auto-advance.md) — The foundation SDK builds on
- [Interactive Executor](interactive-executor.md) — The opposite pattern (human-in-loop)
- [Workflow Settings](workflow-settings.md) — Configuration that SDK uses
- [Agent Profiling](agent-profiling.md) — Choose best agents for SDK execution
