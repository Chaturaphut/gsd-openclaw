#!/bin/bash
# ─────────────────────────────────────────────────────────────
# GSD Issue Sync Script
# Syncs .planning/ state with GitHub or GitLab issues
# ─────────────────────────────────────────────────────────────

set -euo pipefail

VERSION="1.0.0"
PLANNING_DIR=".planning"
PLATFORM=""
ACTION=""

# ─── Colors ──────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# ─── Help ────────────────────────────────────────────────────
show_help() {
  cat << EOF
🔗 GSD Issue Sync Script v${VERSION}

Syncs GSD .planning/ state with GitHub or GitLab issues.

USAGE:
  $(basename "$0") [OPTIONS] <action>

ACTIONS:
  create-issues     Create issues from REQUIREMENTS.md
  link-tasks        Link PLAN.md tasks to issues
  close-passed      Close issues that passed QA
  sync-labels       Create GSD labels on the platform
  status            Show sync status

OPTIONS:
  -p, --platform    Platform: github or gitlab (auto-detected if not set)
  -d, --dir         Planning directory (default: .planning)
  -n, --dry-run     Show what would be done without executing
  -h, --help        Show this help message

ENVIRONMENT:
  GitHub:   GH_TOKEN or GITHUB_TOKEN must be set, uses gh CLI
  GitLab:   GITLAB_TOKEN, GITLAB_PROJECT_ID, GITLAB_URL must be set

EXAMPLES:
  # Create GitHub issues from requirements
  $(basename "$0") --platform github create-issues

  # Close GitLab issues that passed QA
  $(basename "$0") --platform gitlab close-passed

  # Dry run — see what would happen
  $(basename "$0") --dry-run create-issues

  # Check sync status
  $(basename "$0") status
EOF
}

# ─── Detect Platform ─────────────────────────────────────────
detect_platform() {
  if [ -n "$PLATFORM" ]; then
    return
  fi
  
  # Check for GitHub
  if command -v gh &>/dev/null && gh auth status &>/dev/null 2>&1; then
    PLATFORM="github"
    return
  fi
  
  # Check for GitLab env
  if [ -n "${GITLAB_TOKEN:-}" ] && [ -n "${GITLAB_PROJECT_ID:-}" ]; then
    PLATFORM="gitlab"
    return
  fi
  
  # Check git remote
  REMOTE=$(git remote get-url origin 2>/dev/null || echo "")
  if echo "$REMOTE" | grep -q "github.com"; then
    PLATFORM="github"
  elif echo "$REMOTE" | grep -q "gitlab"; then
    PLATFORM="gitlab"
  else
    echo -e "${RED}❌ Cannot detect platform. Use --platform github|gitlab${NC}"
    exit 1
  fi
}

# ─── Validate ────────────────────────────────────────────────
validate() {
  if [ ! -d "$PLANNING_DIR" ]; then
    echo -e "${RED}❌ Planning directory not found: $PLANNING_DIR${NC}"
    exit 1
  fi
  
  detect_platform
  echo -e "${BLUE}📡 Platform: $PLATFORM${NC}"
  
  if [ "$PLATFORM" = "github" ]; then
    if ! command -v gh &>/dev/null; then
      echo -e "${RED}❌ gh CLI not found. Install: https://cli.github.com${NC}"
      exit 1
    fi
  elif [ "$PLATFORM" = "gitlab" ]; then
    if [ -z "${GITLAB_TOKEN:-}" ] || [ -z "${GITLAB_PROJECT_ID:-}" ]; then
      echo -e "${RED}❌ Set GITLAB_TOKEN and GITLAB_PROJECT_ID${NC}"
      exit 1
    fi
  fi
}

# ─── Create Issues ───────────────────────────────────────────
create_issues() {
  REQ_FILE="$PLANNING_DIR/REQUIREMENTS.md"
  if [ ! -f "$REQ_FILE" ]; then
    echo -e "${RED}❌ REQUIREMENTS.md not found${NC}"
    exit 1
  fi
  
  echo -e "${BLUE}📋 Creating issues from $REQ_FILE${NC}"
  COUNT=0
  
  grep -E '^\s*-\s*\[[ x]\]' "$REQ_FILE" | while IFS= read -r line; do
    REQ=$(echo "$line" | sed 's/^\s*-\s*\[[ x]\]\s*//')
    
    # Skip completed
    if echo "$line" | grep -q '\[x\]'; then
      echo -e "${YELLOW}⏭️  Skip (done): $REQ${NC}"
      continue
    fi
    
    if [ "${DRY_RUN:-false}" = "true" ]; then
      echo -e "${GREEN}🔵 Would create: REQ: $REQ${NC}"
      continue
    fi
    
    if [ "$PLATFORM" = "github" ]; then
      gh issue create --title "REQ: $REQ" --label "gsd:requirements" \
        --body "**Source:** REQUIREMENTS.md

## Requirement
$REQ

---
*Created by GSD sync script*" 2>/dev/null
    elif [ "$PLATFORM" = "gitlab" ]; then
      GITLAB_API="${GITLAB_URL:-https://gitlab.com}/api/v4/projects/$GITLAB_PROJECT_ID/issues"
      curl -sf --request POST "$GITLAB_API" \
        --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
        --header "Content-Type: application/json" \
        --data "$(jq -n --arg t "REQ: $REQ" --arg d "**Source:** REQUIREMENTS.md\n\n## Requirement\n$REQ" \
          '{title: $t, labels: "GSD::Requirements", description: $d}')" >/dev/null
    fi
    
    echo -e "${GREEN}✅ Created: $REQ${NC}"
    COUNT=$((COUNT + 1))
  done
  
  echo -e "${GREEN}📊 Done. Created $COUNT issue(s)${NC}"
}

# ─── Link Tasks ──────────────────────────────────────────────
link_tasks() {
  echo -e "${BLUE}🔗 Linking PLAN.md tasks to issues${NC}"
  
  find "$PLANNING_DIR" -name "PLAN*.md" -type f | while IFS= read -r plan_file; do
    echo -e "${BLUE}  📄 Processing: $plan_file${NC}"
    
    grep -E '^##.*#[0-9]+' "$plan_file" 2>/dev/null | while IFS= read -r line; do
      ISSUE_NUM=$(echo "$line" | grep -oE '#[0-9]+' | head -1 | tr -d '#')
      TASK_NAME=$(echo "$line" | sed 's/^##\s*//')
      
      if [ "${DRY_RUN:-false}" = "true" ]; then
        echo -e "${GREEN}🔵 Would link: #$ISSUE_NUM ← $TASK_NAME${NC}"
        continue
      fi
      
      BODY="🔗 **GSD Task Linked:** $TASK_NAME\n\nPlan: \`$plan_file\`"
      
      if [ "$PLATFORM" = "github" ]; then
        gh issue comment "$ISSUE_NUM" --body "$(echo -e "$BODY")" 2>/dev/null || true
      elif [ "$PLATFORM" = "gitlab" ]; then
        GITLAB_API="${GITLAB_URL:-https://gitlab.com}/api/v4/projects/$GITLAB_PROJECT_ID/issues/$ISSUE_NUM/notes"
        curl -sf --request POST "$GITLAB_API" \
          --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
          --header "Content-Type: application/json" \
          --data "$(jq -n --arg b "$(echo -e "$BODY")" '{body: $b}')" >/dev/null || true
      fi
      
      echo -e "${GREEN}✅ Linked #$ISSUE_NUM${NC}"
    done
  done
}

# ─── Close Passed ────────────────────────────────────────────
close_passed() {
  echo -e "${BLUE}✅ Closing issues that passed QA${NC}"
  
  find "$PLANNING_DIR" -name "QA.md" -type f | while IFS= read -r qa_file; do
    echo -e "${BLUE}  📄 Processing: $qa_file${NC}"
    
    grep -E '✅.*#[0-9]+' "$qa_file" 2>/dev/null | while IFS= read -r line; do
      ISSUE_NUM=$(echo "$line" | grep -oE '#[0-9]+' | head -1 | tr -d '#')
      
      if [ "${DRY_RUN:-false}" = "true" ]; then
        echo -e "${GREEN}🔵 Would close: #$ISSUE_NUM${NC}"
        continue
      fi
      
      if [ "$PLATFORM" = "github" ]; then
        gh issue close "$ISSUE_NUM" \
          --comment "✅ QA Passed — Closed by GSD sync" 2>/dev/null || true
      elif [ "$PLATFORM" = "gitlab" ]; then
        GITLAB_API="${GITLAB_URL:-https://gitlab.com}/api/v4/projects/$GITLAB_PROJECT_ID/issues/$ISSUE_NUM"
        curl -sf --request PUT "$GITLAB_API" \
          --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
          --header "Content-Type: application/json" \
          --data '{"state_event": "close", "labels": "GSD::Done"}' >/dev/null || true
      fi
      
      echo -e "${GREEN}✅ Closed #$ISSUE_NUM${NC}"
    done
  done
}

# ─── Sync Labels ─────────────────────────────────────────────
sync_labels() {
  echo -e "${BLUE}🏷️  Creating GSD labels${NC}"
  
  declare -A LABELS=(
    ["requirements"]="0E8A16"
    ["research"]="1D76DB"
    ["planning"]="5319E7"
    ["execution"]="FBCA04"
    ["qa"]="D93F0B"
    ["done"]="0E8A16"
    ["blocked"]="B60205"
  )
  
  for phase in "${!LABELS[@]}"; do
    COLOR="${LABELS[$phase]}"
    
    if [ "$PLATFORM" = "github" ]; then
      LABEL="gsd:$phase"
      if [ "${DRY_RUN:-false}" = "true" ]; then
        echo -e "${GREEN}🔵 Would create label: $LABEL (#$COLOR)${NC}"
      else
        gh label create "$LABEL" --color "$COLOR" --description "GSD: ${phase^} phase" --force 2>/dev/null || true
        echo -e "${GREEN}✅ $LABEL${NC}"
      fi
    elif [ "$PLATFORM" = "gitlab" ]; then
      LABEL="GSD::${phase^}"
      if [ "${DRY_RUN:-false}" = "true" ]; then
        echo -e "${GREEN}🔵 Would create label: $LABEL (#$COLOR)${NC}"
      else
        GITLAB_API="${GITLAB_URL:-https://gitlab.com}/api/v4/projects/$GITLAB_PROJECT_ID/labels"
        curl -sf --request POST "$GITLAB_API" \
          --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
          --data-urlencode "name=$LABEL" \
          --data-urlencode "color=#$COLOR" \
          --data-urlencode "description=GSD: ${phase^} phase" >/dev/null 2>&1 || true
        echo -e "${GREEN}✅ $LABEL${NC}"
      fi
    fi
  done
}

# ─── Status ──────────────────────────────────────────────────
show_status() {
  echo -e "${BLUE}📊 GSD Issue Sync Status${NC}"
  echo "========================"
  
  # Count requirements
  REQ_FILE="$PLANNING_DIR/REQUIREMENTS.md"
  if [ -f "$REQ_FILE" ]; then
    TOTAL=$(grep -cE '^\s*-\s*\[[ x]\]' "$REQ_FILE" 2>/dev/null || echo "0")
    DONE=$(grep -cE '^\s*-\s*\[x\]' "$REQ_FILE" 2>/dev/null || echo "0")
    echo -e "  Requirements: ${GREEN}$DONE${NC}/$TOTAL complete"
  fi
  
  # Count plans
  PLANS=$(find "$PLANNING_DIR" -name "PLAN*.md" -type f 2>/dev/null | wc -l)
  echo -e "  Plans: $PLANS file(s)"
  
  # Count QA reports
  QA_FILES=$(find "$PLANNING_DIR" -name "QA.md" -type f 2>/dev/null | wc -l)
  echo -e "  QA Reports: $QA_FILES file(s)"
  
  # Count issue refs in plans
  REFS=$(grep -roE '#[0-9]+' "$PLANNING_DIR" 2>/dev/null | sort -u | wc -l)
  echo -e "  Issue references: $REFS unique"
  
  # Current state
  if [ -f "$PLANNING_DIR/STATE.md" ]; then
    PHASE=$(grep -E '^## Current|^## Phase|^## Status' "$PLANNING_DIR/STATE.md" | head -1)
    echo -e "  Current state: ${YELLOW}$PHASE${NC}"
  fi
}

# ─── Parse Args ──────────────────────────────────────────────
DRY_RUN=false

while [[ $# -gt 0 ]]; do
  case $1 in
    -p|--platform) PLATFORM="$2"; shift 2 ;;
    -d|--dir) PLANNING_DIR="$2"; shift 2 ;;
    -n|--dry-run) DRY_RUN=true; shift ;;
    -h|--help) show_help; exit 0 ;;
    create-issues|link-tasks|close-passed|sync-labels|status) ACTION="$1"; shift ;;
    *) echo -e "${RED}Unknown option: $1${NC}"; show_help; exit 1 ;;
  esac
done

if [ -z "$ACTION" ]; then
  show_help
  exit 1
fi

# ─── Execute ─────────────────────────────────────────────────
validate

if [ "$DRY_RUN" = "true" ]; then
  echo -e "${YELLOW}🔵 DRY RUN — no changes will be made${NC}"
fi

case "$ACTION" in
  create-issues) create_issues ;;
  link-tasks) link_tasks ;;
  close-passed) close_passed ;;
  sync-labels) sync_labels ;;
  status) show_status ;;
esac
