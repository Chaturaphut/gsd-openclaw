# 🦊 GitLab Issues Integration

Sync your GSD workflow with GitLab Issues for traceability, auto-creation, and auto-close.

## Prerequisites

```bash
# Set your GitLab token and project
export GITLAB_TOKEN="glpat-xxxxxxxxxxxx"
export GITLAB_PROJECT_ID="12345678"
export GITLAB_URL="https://gitlab.com"  # or your self-hosted URL
```

## Label Mapping: GSD Phases → GitLab Labels

| GSD Phase | GitLab Label | Color |
|-----------|-------------|-------|
| Requirements | `GSD::Requirements` | `#0E8A16` |
| Research | `GSD::Research` | `#1D76DB` |
| Planning | `GSD::Planning` | `#5319E7` |
| Execution | `GSD::Execution` | `#FBCA04` |
| QA | `GSD::QA` | `#D93F0B` |
| Done | `GSD::Done` | `#0E8A16` |
| Blocked | `GSD::Blocked` | `#B60205` |

### Create Labels (one-time setup)

```bash
API="$GITLAB_URL/api/v4/projects/$GITLAB_PROJECT_ID/labels"

for label_data in \
  "GSD::Requirements,#0E8A16,Requirements phase" \
  "GSD::Research,#1D76DB,Research phase" \
  "GSD::Planning,#5319E7,Planning phase" \
  "GSD::Execution,#FBCA04,Execution phase" \
  "GSD::QA,#D93F0B,QA phase" \
  "GSD::Done,#0E8A16,Completed" \
  "GSD::Blocked,#B60205,Blocked"; do
  
  NAME=$(echo "$label_data" | cut -d, -f1)
  COLOR=$(echo "$label_data" | cut -d, -f2)
  DESC=$(echo "$label_data" | cut -d, -f3)
  
  curl -s --request POST "$API" \
    --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
    --data-urlencode "name=$NAME" \
    --data-urlencode "color=$COLOR" \
    --data-urlencode "description=GSD: $DESC"
  
  echo "✅ Created label: $NAME"
done
```

## Auto-Create Issues from REQUIREMENTS.md

```bash
#!/bin/bash
API="$GITLAB_URL/api/v4/projects/$GITLAB_PROJECT_ID/issues"

grep -E '^\s*-\s*\[[ x]\]' .planning/REQUIREMENTS.md | while IFS= read -r line; do
  REQ=$(echo "$line" | sed 's/^\s*-\s*\[[ x]\]\s*//')
  
  # Skip completed
  if echo "$line" | grep -q '\[x\]'; then
    echo "⏭️ Skipping (done): $REQ"
    continue
  fi
  
  # Create issue via API
  curl -s --request POST "$API" \
    --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
    --header "Content-Type: application/json" \
    --data "{
      \"title\": \"REQ: $REQ\",
      \"labels\": \"GSD::Requirements\",
      \"description\": \"**Source:** REQUIREMENTS.md\\n\\n## Requirement\\n$REQ\\n\\n## GSD Tracking\\n- Phase: Requirements\\n- Status: Open\"
    }"
  
  echo "✅ Created issue: $REQ"
done
```

## Link Issues ↔ PLAN.md Tasks

Reference GitLab issues in your PLAN.md using `#IID` format:

```markdown
## Task 1: Implement user auth (#12)
- **Files:** src/auth/login.ts
- **Issue:** #12
- **Wave:** 1
```

### Auto-link script

```bash
#!/bin/bash
API="$GITLAB_URL/api/v4/projects/$GITLAB_PROJECT_ID/issues"
PLAN_FILE=".planning/phases/phase-1/PLAN-01.md"

grep -E '^##.*#[0-9]+' "$PLAN_FILE" | while IFS= read -r line; do
  ISSUE_IID=$(echo "$line" | grep -oE '#[0-9]+' | head -1 | tr -d '#')
  TASK_NAME=$(echo "$line" | sed 's/^##\s*//' | sed 's/(#[0-9]*)//')
  
  curl -s --request POST "$API/$ISSUE_IID/notes" \
    --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
    --header "Content-Type: application/json" \
    --data "{\"body\": \"🔗 **GSD Task Linked:** $TASK_NAME\\n\\nPlan: \`$PLAN_FILE\`\"}"
done
```

## Auto-Close Issues on QA Pass

```bash
#!/bin/bash
API="$GITLAB_URL/api/v4/projects/$GITLAB_PROJECT_ID/issues"
QA_FILE=".planning/phases/phase-1/QA.md"

grep -E '✅.*#[0-9]+' "$QA_FILE" | while IFS= read -r line; do
  ISSUE_IID=$(echo "$line" | grep -oE '#[0-9]+' | head -1 | tr -d '#')
  
  # Add close note
  curl -s --request POST "$API/$ISSUE_IID/notes" \
    --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
    --header "Content-Type: application/json" \
    --data "{\"body\": \"✅ **QA Passed** — Closed by GSD workflow\\n\\nQA Report: \`$QA_FILE\`\"}"
  
  # Close issue and update labels
  curl -s --request PUT "$API/$ISSUE_IID" \
    --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
    --header "Content-Type: application/json" \
    --data "{\"state_event\": \"close\", \"labels\": \"GSD::Done\"}"
  
  echo "✅ Closed #$ISSUE_IID"
done
```

## Milestone Integration

Map GSD phases to GitLab milestones:

```bash
# Create milestone for each phase
API="$GITLAB_URL/api/v4/projects/$GITLAB_PROJECT_ID/milestones"

curl -s --request POST "$API" \
  --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
  --header "Content-Type: application/json" \
  --data "{
    \"title\": \"Phase 1: API Setup\",
    \"description\": \"GSD Phase 1 — API endpoints and database schema\"
  }"
```

## MR Auto-Link

GitLab auto-links issues in MR descriptions. Include issue references:

```markdown
## Merge Request

Resolves #12, #13, #14

### GSD Context
- Phase: phase-1-api-setup
- Wave: 1
- Plan: .planning/phases/phase-1/PLAN-01.md
```

When the MR is merged, referenced issues are automatically closed.
