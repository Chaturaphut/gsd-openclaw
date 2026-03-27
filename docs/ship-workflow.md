# 🚀 Ship Workflow (`/gsd:ship`)

> **Adapted from:** GSD v1.26 `/gsd:ship` command
> **Purpose:** Standardized PR/MR creation workflow after QA passes.

---

## Overview

The Ship workflow is the final step in GSD — once QA passes, create a clean PR/MR that tells the story of what was built. This ensures every merge into `main` is well-documented and reviewable.

---

## When to Ship

Ship is triggered when:
1. ✅ All tasks in PLAN.md marked complete
2. ✅ QA report passes (no blockers)
3. ✅ Regression gate passes (previous phases still work)
4. ✅ Stub detection clean (no TODO/FIXME in production code)

---

## Ship Checklist

Before creating the PR/MR:

```markdown
## Pre-Ship Checklist
- [ ] All PLAN.md tasks have "Done When" criteria met
- [ ] QA-REPORT.md exists with PASS verdict
- [ ] No stubs in production code (`grep -rn "TODO\|FIXME" src/`)
- [ ] HANDOFF.json is current and complete
- [ ] SUMMARY.md documents what was built
- [ ] Branch is rebased on latest main
- [ ] No merge conflicts
- [ ] CI pipeline passes (if configured)
```

---

## PR/MR Description Template

The ship workflow auto-generates a PR description from `.planning/` artifacts:

```markdown
## What

[Auto-extracted from SUMMARY.md — what was built]

## Why

[Auto-extracted from REQUIREMENTS.md — the original requirement]

## How

[Auto-extracted from PLAN.md — high-level approach]

### Changes
[Auto-extracted from HANDOFF.json modifiedFiles]

- `src/api/routes.ts` — New authentication endpoints
- `src/services/auth.ts` — JWT token management
- `src/middleware/session.ts` — Session middleware

## Testing

[Auto-extracted from QA-REPORT.md]

- ✅ Unit tests: 47 pass, 0 fail
- ✅ Integration tests: 12 pass, 0 fail
- ✅ Regression gate: All previous phases pass
- ✅ Stub detection: Clean

## Decisions Made

[Auto-extracted from HANDOFF.json decisions]

| ID | Decision | Rationale |
|----|----------|-----------|
| D001 | Used Redis for sessions | 10x faster than DB-backed |
| D002 | JWT with 15min expiry | Balance security vs UX |
```

---

## Implementation for OpenClaw

### Using GitHub API

```bash
# Create PR via GitHub CLI (gh)
gh pr create \
  --title "feat: implement user authentication (Phase 1)" \
  --body-file .planning/phases/phase-1/PR-DESCRIPTION.md \
  --base main \
  --head feat/phase-1-auth \
  --label "gsd-shipped"
```

### Using GitLab API

```bash
# Create MR via GitLab API
curl -X POST "https://gitlab.com/api/v4/projects/$PROJECT_ID/merge_requests" \
  -H "PRIVATE-TOKEN: $GITLAB_PAT" \
  -d "source_branch=feat/phase-1-auth" \
  -d "target_branch=main" \
  -d "title=feat: implement user authentication (Phase 1)" \
  -d "description=$(cat .planning/phases/phase-1/PR-DESCRIPTION.md)" \
  -d "squash=true" \
  -d "remove_source_branch=true"
```

### Coordinator Pattern

The coordinator agent orchestrates the ship:

```
1. Verify QA passed → read QA-REPORT.md
2. Generate PR description → compile from .planning/ artifacts
3. Create branch if not exists → git checkout -b feat/phase-N
4. Push changes → git push origin feat/phase-N
5. Create PR/MR → via platform API
6. Update STATE.md → mark phase as "shipped"
7. Notify → report PR URL to user
```

---

## Ship Conventions

### Branch Naming
```
feat/phase-1-api-setup
feat/phase-2-frontend
fix/phase-1-auth-regression
```

### Commit Message
Use Conventional Commits for the squash commit:
```
feat(auth): implement JWT authentication with Redis sessions

- Add login/register/refresh endpoints
- Add session middleware with Redis backing
- Add rate limiting on auth endpoints

Closes #12, #13, #14
Refs: .planning/phases/phase-1/PLAN-01.md
```

### Labels
Add GSD-specific labels to PRs:
- `gsd-shipped` — Created via GSD ship workflow
- `phase-N` — Which phase this PR covers
- `wave-N` — Which execution wave

---

## Post-Ship

After PR is merged:
1. Update `STATE.md` — Phase marked as "merged"
2. Archive `.planning/phases/phase-N/` artifacts
3. Run regression gate on main branch
4. Begin next phase (if any)

---

## Related

- [Git Branch Flow](git-branch-flow.md) — Branch and commit conventions
- [QA Standards](qa-standards.md) — QA report that gates shipping
- [PR Branch Creation](pr-branch-workflow.md) — Clean branch preparation
