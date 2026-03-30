# Workstream Namespacing — Parallel Milestone Execution

> **Cherry-picked from GSD v1.28.0** | Adapted for OpenClaw multi-agent teams

---

## What Is Workstream Namespacing?

Workstream namespacing lets you run **parallel milestone work** without agents stepping on each other. Each workstream gets its own isolated planning context, branch, and agent scope — while all workstreams share the same repo root.

This is the GSD-OpenClaw equivalent of `/gsd:workstreams` from upstream GSD.

---

## When to Use It

Use workstream namespacing when:

- Two features need to ship simultaneously to meet a deadline
- One team is working on UI while another works on backend
- You have a hotfix in-flight while a feature sprint is also running
- A data migration must happen in parallel with application development

**Don't use it for:** sequential phases (just use the normal GSD workflow). Namespacing adds coordination overhead — only worthwhile for truly parallel work.

---

## Workstream Setup

### 1. Define Workstreams in PROJECT.md

```markdown
## Active Workstreams

| ID | Name | Owner Agent | Branch | Status |
|----|------|-------------|--------|--------|
| ws-01 | payment-redesign | David (Frontend) | feat/payment-redesign | active |
| ws-02 | api-v2-migration | Moses (Backend) | feat/api-v2 | active |
| ws-03 | security-hardening | Michael (Security) | security/auth-overhaul | planning |
```

### 2. Isolate Planning Directories

Each workstream gets its own `.planning/` namespace:

```
.planning/
  ws-01-payment-redesign/
    STATE.md
    PLAN.md
    REQUIREMENTS.md
  ws-02-api-v2/
    STATE.md
    PLAN.md
    REQUIREMENTS.md
```

### 3. Name Workstream Branches

Follow the branch convention with workstream ID prefix:

```bash
# Create workstream branch from main
git checkout main && git pull
git checkout -b feat/ws-01-payment-redesign
git checkout -b feat/ws-02-api-v2
```

---

## Coordination Rules

### No Cross-Workstream File Writes

Each agent MUST only write to their workstream's:
- `.planning/ws-XX-*/` — planning files
- Their feature branch — code files

**Exception:** Shared config files (e.g., `settings.json`, `docker-compose.yml`) require explicit coordination via HANDOFF.json before touching.

### Merge Order Matters

When workstreams are ready to merge:

1. **Identify conflicts early** — run `git merge --no-commit --no-ff` before the actual merge
2. **Merge lower-risk workstream first** — usually backend before frontend
3. **Integration wave** — after both merge to main, spawn Elijah (QA) for cross-feature integration test
4. **Never merge two workstreams simultaneously** — creates unmergeable conflicts

### HANDOFF.json for Cross-Workstream Dependencies

If ws-02 (API) has work that ws-01 (Frontend) depends on:

```json
{
  "from_workstream": "ws-02-api-v2",
  "to_workstream": "ws-01-payment-redesign",
  "dependency_type": "api_contract",
  "artifact": "docs/api-v2-contracts.md",
  "status": "ready",
  "timestamp": "2026-03-31T03:00:00Z",
  "notes": "Payment endpoint schema finalized. Frontend can proceed."
}
```

Place this in `.planning/ws-01-payment-redesign/HANDOFF.json`.

---

## Multi-Project Workspace

For repos with multiple GSD projects (monorepo), extend workstreams to project roots:

```
/workspace/
  project-alpha/         ← GSD project root (has .planning/)
    .planning/
  project-beta/          ← separate GSD project root
    .planning/
  shared-libs/           ← not a GSD project, shared dependency
```

Agent spawning rule: always pass the correct project root as `cwd` when spawning. Never assume the workspace root is the project root.

---

## OpenClaw Implementation

When MumuX spawns agents for parallel workstreams:

```
1. Spawn ws-01 agent (David) with:
   - task: "Work in feat/ws-01-payment-redesign branch"
   - cwd: /root/project
   - planning_dir: .planning/ws-01-payment-redesign/

2. Spawn ws-02 agent (Moses) with:
   - task: "Work in feat/ws-02-api-v2 branch"
   - cwd: /root/project
   - planning_dir: .planning/ws-02-api-v2/

3. MumuX tracks both in memory/active-jobs.md:
   | Agent | Workstream | Branch | Started | ETA |
   |-------|-----------|--------|---------|-----|
   | David | ws-01-payment | feat/ws-01-... | 09:00 | 11:00 |
   | Moses | ws-02-api-v2 | feat/ws-02-... | 09:00 | 10:30 |

4. When ws-02 completes first: notify David via HANDOFF.json
5. Both complete → spawn Titus (QA Lead) for integration test
6. Integration passes → merge in order: ws-02 first, then ws-01
```

---

## Workstream Status Dashboard

Update `PROJECT.md` workstream table at each milestone:

| Status | Meaning |
|--------|---------|
| `planning` | Discuss/Research phase in progress |
| `active` | Execute phase running |
| `blocked` | Waiting on another workstream or decision |
| `review` | Code complete, in QA/review |
| `merging` | MR open, pending merge |
| `done` | Merged to main, branch deleted |

---

## Anti-Patterns

❌ **Don't share a branch between workstreams** — creates merge chaos  
❌ **Don't skip HANDOFF.json for cross-workstream deps** — silent breakage  
❌ **Don't merge workstreams without integration test** — features may conflict at runtime  
❌ **Don't run more than 3-4 workstreams simultaneously** — coordination overhead exceeds benefit  
❌ **Don't forget to delete workstream branches after merge** — keeps repo clean  

---

## Related Docs

- [`wave-execution-guide.md`](wave-execution-guide.md) — Parallel agent execution within a single workstream
- [`handoff-best-practices.md`](handoff-best-practices.md) — Cross-agent handoff patterns (if exists)
- [`multi-repo-workspace.md`](multi-repo-workspace.md) — Monorepo and multi-project setup

---

*Part of GSD-OpenClaw documentation — github.com/Chaturaphut/gsd-openclaw*
