# 🔀 Git Branch Flow for AI Agent Teams

> **Rule:** Agents NEVER push directly to `main`. Every change goes through a branch → merge request → squash merge.

When AI agents have direct push access to `main`, disasters happen fast. One agent's broken code blocks every other agent. This guide enforces the discipline that keeps your main branch deployable at all times.

---

## Why This Matters for AI Agents

Human developers have PR review muscle memory. AI agents don't — they'll happily push to whatever branch they're on. Without explicit rules:

- 🔥 **Agent pushes broken code to main** → All other agents pull broken code → Cascade failure
- 🔀 **Two agents push to main simultaneously** → Merge conflicts → Manual resolution needed
- 📜 **No audit trail** → "Who changed this?" becomes unanswerable
- 🔄 **No rollback point** → Squash merge gives you clean revert targets

## The Flow

```
main (protected)
  │
  ├── feat/user-auth          ← Agent A works here
  │     └── commit: feat: add login endpoint
  │     └── commit: feat: add JWT middleware
  │     └── MR → squash merge → main
  │
  ├── fix/date-formatting     ← Agent B works here (parallel)
  │     └── commit: fix: locale-aware date display
  │     └── MR → squash merge → main
  │
  └── hotfix/null-crash       ← Agent C (urgent fix)
        └── commit: hotfix: handle null user in middleware
        └── MR → squash merge → main
```

## Branch Naming Convention

| Prefix | When to Use | Example |
|--------|------------|---------|
| `feat/` | New feature | `feat/user-dashboard` |
| `fix/` | Bug fix | `fix/pagination-offset` |
| `hotfix/` | Urgent production fix | `hotfix/api-500-on-login` |
| `security/` | Security patch | `security/xss-sanitize` |
| `refactor/` | Code restructure | `refactor/extract-service` |
| `docs/` | Documentation | `docs/api-endpoints` |

## Workflow Steps

### 1. Start from Fresh Main
```bash
git checkout main && git pull origin main
```

### 2. Create Feature Branch
```bash
git checkout -b feat/your-feature-name
```

### 3. Work & Commit (Conventional Commits)
```bash
# Commit types: feat, fix, docs, refactor, security, test, chore
git add -A
git commit -m "feat: add user authentication endpoint"
```

### 4. Push Branch
```bash
git push origin feat/your-feature-name
```

### 5. Create Merge Request

**GitLab API:**
```bash
curl -X POST "https://gitlab.com/api/v4/projects/$PROJECT_ID/merge_requests" \
  -H "PRIVATE-TOKEN: $PAT" \
  -d "source_branch=feat/your-feature-name" \
  -d "target_branch=main" \
  -d "title=feat: add user authentication endpoint" \
  -d "squash_on_merge=true" \
  -d "remove_source_branch_after_merge=true"
```

**GitHub API:**
```bash
curl -X POST "https://api.github.com/repos/$OWNER/$REPO/pulls" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{"title":"feat: add user auth","head":"feat/your-feature-name","base":"main"}'
```

### 6. Merge (After QA Pass)
```bash
# GitLab
curl -X PUT "https://gitlab.com/api/v4/projects/$PROJECT_ID/merge_requests/$MR_IID/merge" \
  -H "PRIVATE-TOKEN: $PAT" \
  -d "squash=true" \
  -d "should_remove_source_branch=true"
```

### 7. Update Local Main
```bash
git checkout main && git pull origin main
```

## Conventional Commits

Every commit message follows this format:

```
<type>: <description>

[optional body]
```

| Type | When |
|------|------|
| `feat:` | New feature |
| `fix:` | Bug fix |
| `docs:` | Documentation only |
| `refactor:` | Code change that neither fixes a bug nor adds a feature |
| `security:` | Security-related change |
| `test:` | Adding or updating tests |
| `chore:` | Build process, tooling, dependencies |

**Examples:**
```
feat: add JWT authentication with refresh token rotation
fix: handle null user object in permission middleware
docs: add API endpoint documentation for /api/users
security: sanitize HTML input to prevent XSS
refactor: extract email service from user controller
```

## MR Checklist

Before merging any MR, verify:

- [ ] Code compiles and runs correctly
- [ ] No hardcoded credentials or secrets (see [Credential Security](credential-security.md))
- [ ] Commit messages follow Conventional Commits
- [ ] All tests pass (`npm test` / `pytest` / etc.)
- [ ] QA has verified the changes (see [QA Standards](qa-standards.md))
- [ ] API documentation updated (if endpoints changed)
- [ ] Permissions registered (if new endpoints added)

## Protected Branch Setup

### GitLab
```
Settings → Repository → Protected Branches
- Branch: main
- Allowed to merge: Maintainers
- Allowed to push: No one
- Allowed to force push: No
```

### GitHub
```
Settings → Branches → Branch protection rules
- Branch name pattern: main
- Require pull request before merging: ✅
- Require status checks: ✅
- Include administrators: ✅
```

## Agent Instructions Template

Include this in every dev agent's task:

```markdown
## Git Rules
1. NEVER push to main directly
2. Create branch: `git checkout -b <prefix>/<short-desc>`
3. Commit with Conventional Commits: `feat:`, `fix:`, etc.
4. Push branch: `git push origin <branch-name>`
5. Create MR with squash_on_merge=true
6. After merge: `git checkout main && git pull`
```

---

*Enforced across 59 agents, 5+ active repositories, zero main-branch incidents since adoption.*
