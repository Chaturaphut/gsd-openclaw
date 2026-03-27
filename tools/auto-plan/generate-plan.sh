#!/bin/bash
# ─────────────────────────────────────────────────────────────
# GSD Auto-Plan Generator
# Reads REQUIREMENTS.md + RESEARCH.md and generates a draft PLAN.md
# ─────────────────────────────────────────────────────────────

set -euo pipefail

VERSION="1.0.0"
PLANNING_DIR=".planning"
OUTPUT_FILE=""
PHASE_DIR=""
PROJECT_NAME=""

# ─── Colors ──────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# ─── Help ────────────────────────────────────────────────────
show_help() {
  cat << EOF
📐 GSD Auto-Plan Generator v${VERSION}

Generates a draft PLAN.md from REQUIREMENTS.md and RESEARCH.md.

USAGE:
  $(basename "$0") [OPTIONS]

OPTIONS:
  -d, --dir DIR         Planning directory (default: .planning)
  -p, --phase DIR       Phase directory (e.g., phases/phase-1)
  -o, --output FILE     Output file path (default: auto-detected)
  -n, --name NAME       Project name (default: from PROJECT.md)
  --prompt-only         Output the AI prompt instead of generating plan
  -h, --help            Show this help message

EXAMPLES:
  # Generate plan from .planning/
  $(basename "$0")

  # Generate for specific phase
  $(basename "$0") --phase phases/phase-2-frontend

  # Output prompt for manual use with AI
  $(basename "$0") --prompt-only

  # Custom planning directory
  $(basename "$0") --dir my-project/.planning
EOF
}

# ─── Read Source Files ───────────────────────────────────────
read_requirements() {
  local req_file="$PLANNING_DIR/REQUIREMENTS.md"
  if [ -f "$req_file" ]; then
    cat "$req_file"
  else
    echo -e "${RED}❌ REQUIREMENTS.md not found at $req_file${NC}" >&2
    exit 1
  fi
}

read_research() {
  local research_file="$PLANNING_DIR/RESEARCH.md"
  
  # Check phase-level research first
  if [ -n "$PHASE_DIR" ] && [ -f "$PLANNING_DIR/$PHASE_DIR/RESEARCH.md" ]; then
    cat "$PLANNING_DIR/$PHASE_DIR/RESEARCH.md"
    return
  fi
  
  # Check for any research files
  if [ -f "$research_file" ]; then
    cat "$research_file"
    return
  fi
  
  # Search in phases
  local found=$(find "$PLANNING_DIR" -name "RESEARCH.md" -type f 2>/dev/null | head -1)
  if [ -n "$found" ]; then
    cat "$found"
    return
  fi
  
  echo "(No RESEARCH.md found — plan will be generated from requirements only)"
}

read_project_name() {
  if [ -n "$PROJECT_NAME" ]; then
    echo "$PROJECT_NAME"
    return
  fi
  
  local proj_file="$PLANNING_DIR/PROJECT.md"
  if [ -f "$proj_file" ]; then
    # Extract project name from heading or "Project:" line
    local name=$(grep -E '^#|^## Project' "$proj_file" | head -1 | sed 's/^#*\s*//' | sed 's/^Project:\s*//')
    if [ -n "$name" ]; then
      echo "$name"
      return
    fi
  fi
  
  # Fallback to directory name
  basename "$(pwd)"
}

# ─── Extract Requirements List ───────────────────────────────
extract_requirements_list() {
  local req_content="$1"
  echo "$req_content" | grep -E '^\s*-\s*\[[ x]\]' | sed 's/^\s*-\s*\[[ x]\]\s*//' || true
}

# ─── Generate Plan ───────────────────────────────────────────
generate_plan() {
  local req_content=$(read_requirements)
  local research_content=$(read_research)
  local project_name=$(read_project_name)
  local requirements_list=$(extract_requirements_list "$req_content")
  
  echo -e "${BLUE}📐 Generating plan for: $project_name${NC}" >&2
  echo -e "${BLUE}📋 Requirements found: $(echo "$requirements_list" | wc -l | tr -d ' ')${NC}" >&2
  
  # Count open requirements
  local open_reqs=$(echo "$req_content" | grep -cE '^\s*-\s*\[ \]' || echo "0")
  local done_reqs=$(echo "$req_content" | grep -cE '^\s*-\s*\[x\]' || echo "0")
  echo -e "${BLUE}📊 Open: $open_reqs | Done: $done_reqs${NC}" >&2
  
  # Generate draft plan structure
  cat << PLAN
# Execution Plan: $project_name

> ⚠️ **DRAFT** — Generated automatically. Review and adjust before executing.

## Read First
- **Requirements:** $PLANNING_DIR/REQUIREMENTS.md
- **Research:** $PLANNING_DIR/RESEARCH.md
- **Project:** $PLANNING_DIR/PROJECT.md

## Summary
This plan addresses $open_reqs open requirement(s) for $project_name.

---

## Wave 1: Foundation (Independent Tasks)

PLAN

  # Generate task stubs from open requirements
  local wave=1
  local task=1
  local total_tasks=0
  
  echo "$req_content" | grep -E '^\s*-\s*\[ \]' | sed 's/^\s*-\s*\[ \]\s*//' | while IFS= read -r req; do
    total_tasks=$((total_tasks + 1))
    
    # Simple wave assignment: first 3 in wave 1, next 3 in wave 2, rest in wave 3
    if [ $total_tasks -eq 4 ]; then
      echo ""
      echo "## Wave 2: Integration (Depends on Wave 1)"
      echo ""
    elif [ $total_tasks -eq 7 ]; then
      echo ""
      echo "## Wave 3: Polish & Integration (Depends on Wave 2)"
      echo ""
    fi
    
    cat << TASK
### Task $total_tasks: $req
- **Files:** \`[specify exact file paths]\`
- **Dependencies:** ${total_tasks:+$([ $total_tasks -le 3 ] && echo "None" || echo "Task(s) from previous wave")}
- **Action:**
  1. [Define implementation steps]
  2. [Be specific about what to implement]
  3. [Reference research findings]
- **Verify:** [How to test this task]
- **Done When:** [Measurable acceptance criteria]

TASK
  done
  
  # Requirements coverage table
  cat << COVERAGE

---

## Acceptance Criteria
$(echo "$req_content" | grep -E '^\s*-\s*\[ \]' | sed 's/^\s*-\s*\[ \]/- [ ]/')

## Requirements Coverage

| Requirement | Task(s) | Status |
|-------------|---------|--------|
$(echo "$req_content" | grep -E '^\s*-\s*\[ \]' | sed 's/^\s*-\s*\[ \]\s*//' | awk '{print "| " $0 " | [assign task] | ⬜ Unmapped |"}')

---

> **Next Steps:**
> 1. Review each task — fill in file paths, implementation steps, and verification
> 2. Validate wave assignments — ensure no dependencies within the same wave
> 3. Check requirements coverage — every requirement must map to a task
> 4. Run: \`tools/auto-plan/validation-checklist.md\` to verify plan quality
COVERAGE
}

# ─── Output Prompt ───────────────────────────────────────────
output_prompt() {
  local req_content=$(read_requirements)
  local research_content=$(read_research)
  local project_name=$(read_project_name)
  
  # Read the prompt template and substitute variables
  local template_dir="$(cd "$(dirname "$0")" && pwd)"
  
  cat << PROMPT
You are a GSD (Get Shit Done) Solution Architect. Generate a structured execution plan.

## Project: $project_name

## REQUIREMENTS.md
$req_content

## RESEARCH.md
$research_content

## Instructions
Generate a PLAN.md with:
1. Wave-based task grouping (independent tasks in same wave)
2. Every requirement mapped to at least one task
3. Exact file paths for each task
4. Measurable acceptance criteria
5. Verification steps including edge cases from research
6. Requirements coverage table at the end

Format each task as:
### Task N.N: [Name]
- **Files:** [exact paths]
- **Dependencies:** [task refs or None]
- **Action:** [numbered steps]
- **Verify:** [how to test]
- **Done When:** [acceptance criteria]
PROMPT
}

# ─── Parse Args ──────────────────────────────────────────────
PROMPT_ONLY=false

while [[ $# -gt 0 ]]; do
  case $1 in
    -d|--dir) PLANNING_DIR="$2"; shift 2 ;;
    -p|--phase) PHASE_DIR="$2"; shift 2 ;;
    -o|--output) OUTPUT_FILE="$2"; shift 2 ;;
    -n|--name) PROJECT_NAME="$2"; shift 2 ;;
    --prompt-only) PROMPT_ONLY=true; shift ;;
    -h|--help) show_help; exit 0 ;;
    *) echo -e "${RED}Unknown option: $1${NC}"; show_help; exit 1 ;;
  esac
done

# ─── Execute ─────────────────────────────────────────────────
if [ "$PROMPT_ONLY" = "true" ]; then
  output_prompt
  exit 0
fi

# Determine output file
if [ -z "$OUTPUT_FILE" ]; then
  if [ -n "$PHASE_DIR" ]; then
    OUTPUT_FILE="$PLANNING_DIR/$PHASE_DIR/PLAN-01.md"
  else
    OUTPUT_FILE="$PLANNING_DIR/PLAN-draft.md"
  fi
fi

# Generate
echo -e "${BLUE}📐 GSD Auto-Plan Generator v${VERSION}${NC}"
echo -e "${BLUE}📁 Planning dir: $PLANNING_DIR${NC}"
echo -e "${BLUE}📄 Output: $OUTPUT_FILE${NC}"
echo ""

PLAN_CONTENT=$(generate_plan)

# Ensure output directory exists
mkdir -p "$(dirname "$OUTPUT_FILE")"

echo "$PLAN_CONTENT" > "$OUTPUT_FILE"

echo ""
echo -e "${GREEN}✅ Draft plan generated: $OUTPUT_FILE${NC}"
echo -e "${YELLOW}⚠️  This is a DRAFT — review and fill in implementation details before executing${NC}"
echo ""
echo -e "Next steps:"
echo -e "  1. Edit $OUTPUT_FILE — fill in file paths, steps, verification"
echo -e "  2. Validate: review tools/auto-plan/validation-checklist.md"
echo -e "  3. Verify requirements coverage table is complete"
