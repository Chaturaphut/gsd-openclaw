# 🔗 GitHub Issues Integration

Sync your GSD workflow with GitHub Issues for traceability, auto-creation, and auto-close.

## Label Mapping: GSD Phases → GitHub Labels

| GSD Phase | GitHub Label | Color |
|-----------|-------------|-------|
| Requirements | `gsd:requirements` | `#0E8A16` |
| Research | `gsd:research` | `#1D76DB` |
| Planning | `gsd:planning` | `#5319E7` |
| Execution | `gsd:execution` | `#FBCA04` |
| QA | `gsd:qa` | `#D93F0B` |
| Done | `gsd:done` | `#0E8A16` |
| Blocked | `gsd:blocked` | `#B60205` |

### Create Labels (one-time setup)

```bash
# Using gh CLI
gh label create "gsd:requirements" --color "0E8A16" --description "GSD: Requirements phase"
gh label create "gsd:research" --color "1D76DB" --description "GSD: Research phase"
gh label create "gsd:planning" --color "5319E7" --description "GSD: Planning phase"
gh label create "gsd:execution" --color "FBCA04" --description "GSD: Execution phase"
gh label create "gsd:qa" --color "D93F0B" --description "GSD: QA phase"
gh label create "gsd:done" --color "0E8A16" --description "GSD: Completed"
gh label create "gsd:blocked" --color "B60205" --description "GSD: Blocked"
```

## Auto-Create Issues from REQUIREMENTS.md

Parse `REQUIREMENTS.md` and create a GitHub issue for each requirement:

```bash
#!/bin/bash
# Extract requirements and create issues
REPO="owner/repo"

# Parse v1 requirements (lines starting with - [ ] or - [x])
grep -E '^\s*-\s*\[[ x]\]' .planning/REQUIREMENTS.md | while IFS= read -r line; do
  # Extract requirement text (remove checkbox)
  REQ=$(echo "$line" | sed 's/^\s*-\s*\[[ x]\]\s*//')
  
  # Check if already completed
  if echo "$line" | grep -q '\[x\]'; then
    echo "⏭️ Skipping (done): $REQ"
    continue
  fi
  
  # Create issue
  gh issue create \
    --repo "$REPO" \
    --title "REQ: $REQ" \
    --label "gsd:requirements" \
    --body "**Source:** REQUIREMENTS.md
    
## Requirement
$REQ

## GSD Tracking
- Phase: Requirements
- Status: Open
- Created by: GSD sync script"
  
  echo "✅ Created issue: $REQ"
done
```

## Link Issues ↔ PLAN.md Tasks

Reference GitHub issues in your PLAN.md:

```markdown
## Task 1: Implement user auth (#12)
- **Files:** src/auth/login.ts
- **Issue:** #12
- **Wave:** 1
- **Action:** Implement JWT-based authentication
- **Verify:** Login returns valid token
- **Done When:** #12 acceptance criteria met
```

### Auto-link script

```bash
#!/bin/bash
# Parse PLAN.md tasks and link to issues
PLAN_FILE=".planning/phases/phase-1/PLAN-01.md"

# Find task headers with issue references
grep -E '^##.*#[0-9]+' "$PLAN_FILE" | while IFS= read -r line; do
  ISSUE_NUM=$(echo "$line" | grep -oE '#[0-9]+' | head -1 | tr -d '#')
  TASK_NAME=$(echo "$line" | sed 's/^##\s*//' | sed 's/(#[0-9]*)//')
  
  # Add comment to the issue
  gh issue comment "$ISSUE_NUM" \
    --body "🔗 **GSD Task Linked:** $TASK_NAME
    
This requirement is being addressed in the current execution phase.
Plan: \`$PLAN_FILE\`"
done
```

## Auto-Close Issues on QA Pass

When QA.md marks a task as passed, close the linked issue:

```bash
#!/bin/bash
# Parse QA.md for passed items and close linked issues
QA_FILE=".planning/phases/phase-1/QA.md"

# Find passed items with issue refs
grep -E '✅.*#[0-9]+' "$QA_FILE" | while IFS= read -r line; do
  ISSUE_NUM=$(echo "$line" | grep -oE '#[0-9]+' | head -1 | tr -d '#')
  
  # Close issue with QA reference
  gh issue close "$ISSUE_NUM" \
    --comment "✅ **QA Passed** — Closed by GSD workflow
    
QA Report: \`$QA_FILE\`
Closed automatically by GSD sync."
  
  # Add done label
  gh issue edit "$ISSUE_NUM" --add-label "gsd:done" --remove-label "gsd:execution"
  
  echo "✅ Closed #$ISSUE_NUM"
done
```

## Phase Transition Updates

When STATE.md changes phase, update all open issues:

```bash
#!/bin/bash
# Read current phase from STATE.md
CURRENT_PHASE=$(grep -E '^## Current Phase' .planning/STATE.md | sed 's/.*: //')

# Map to label
case "$CURRENT_PHASE" in
  *[Rr]equirement*) LABEL="gsd:requirements" ;;
  *[Rr]esearch*)    LABEL="gsd:research" ;;
  *[Pp]lan*)        LABEL="gsd:planning" ;;
  *[Ee]xecut*)      LABEL="gsd:execution" ;;
  *[Qq][Aa]*)       LABEL="gsd:qa" ;;
  *)                LABEL="" ;;
esac

if [ -n "$LABEL" ]; then
  echo "📋 Current phase: $CURRENT_PHASE → Label: $LABEL"
fi
```

## Full Workflow Example

```
1. Define REQUIREMENTS.md
   └── sync-script.sh --create-issues
       └── Creates GitHub issues with gsd:requirements label

2. Complete PLAN.md with issue refs (#12, #13, #14)
   └── sync-script.sh --link-tasks
       └── Comments on issues with plan details

3. Execute tasks (wave by wave)
   └── Issues labeled gsd:execution

4. QA passes tasks
   └── sync-script.sh --close-passed
       └── Closes issues, adds gsd:done label

5. All issues closed = Phase complete ✅
```
