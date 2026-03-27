# 🌿 Clean PR Branch Creation (`/gsd:pr-branch`)

> **Adapted from:** GSD v1.27 `/gsd:pr-branch` command
> **Purpose:** Create clean, well-structured branches for pull requests.

---

## Overview

After executing a phase, your working directory may have messy commit history, temp files, or debug artifacts. `/gsd:pr-branch` creates a clean branch specifically for the PR/MR — squashed commits, no artifacts, clean diff.

---

## Workflow

```
1. Complete execution on working branch (feat/phase-1-wip)
2. Run PR branch preparation
3. Create clean branch (feat/phase-1-auth)
4. Cherry-pick or squash commits
5. Remove .planning/ artifacts from branch
6. Clean up temp/debug files
7. Push clean branch
8. Create PR (via /gsd:ship)
```

---

## Branch Preparation Checklist

```markdown
## PR Branch Prep

### Clean Up
- [ ] Remove all `console.log` debug statements
- [ ] Remove all `// DEBUG` comments
- [ ] Remove temp files (*.tmp, *.bak, *.orig)
- [ ] Remove .planning/ from tracked files (should be in .gitignore)
- [ ] Verify .env.example is updated (not .env itself)

### Verify
- [ ] All tests pass
- [ ] Build succeeds with no warnings
- [ ] Linter passes
- [ ] No secrets in committed files

### Commit History
- [ ] Squash WIP commits into logical units
- [ ] Each commit has a conventional commit message
- [ ] Commit order tells a logical story
```

---

## Implementation

### Automated PR Branch Script

```bash
#!/bin/bash
# Create clean PR branch from working branch

WORKING_BRANCH=$(git branch --show-current)
PR_BRANCH="${WORKING_BRANCH/-wip/}"

echo "Creating clean PR branch: $PR_BRANCH"

# Ensure working directory is clean
git stash --include-untracked

# Create PR branch from main
git checkout main
git pull
git checkout -b "$PR_BRANCH"

# Squash merge from working branch
git merge --squash "$WORKING_BRANCH"

# Remove artifacts
git reset HEAD .planning/ 2>/dev/null
echo ".planning/" >> .gitignore

# Remove debug artifacts
find . -name "*.tmp" -delete
find . -name "*.bak" -delete
grep -rl "console.log.*DEBUG" src/ | xargs sed -i '/console.log.*DEBUG/d' 2>/dev/null

# Commit
git add -A
git commit -m "feat: $(head -1 .planning/phases/*/SUMMARY.md 2>/dev/null || echo 'implement feature')"

echo "Clean PR branch ready: $PR_BRANCH"
echo "Review with: git diff main...$PR_BRANCH"
```

---

## Coordinator Pattern

```markdown
When preparing a PR branch:

1. Verify all tasks complete (read HANDOFF.json)
2. Verify QA passed (read QA-REPORT.md)
3. Create clean branch from main
4. Apply changes via squash merge
5. Remove .planning/ artifacts
6. Clean up debug/temp files
7. Run final build + test
8. Push and create PR via /gsd:ship
```

---

## Related

- [Ship Workflow](ship-workflow.md) — PR creation after branch prep
- [Git Branch Flow](git-branch-flow.md) — Branch naming and conventions
- [Auto Advance](auto-advance.md) — Auto-triggers PR branch creation
