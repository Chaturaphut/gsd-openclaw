#!/bin/bash
# ─────────────────────────────────────────────────────────────
# GSD Agent Performance Metrics Collector
# Reads .planning/ artifacts and generates analytics report
# ─────────────────────────────────────────────────────────────

set -euo pipefail

VERSION="1.0.0"
PLANNING_DIR=".planning"
OUTPUT_FORMAT="text"
OUTPUT_FILE=""

# ─── Colors ──────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# ─── Help ────────────────────────────────────────────────────
show_help() {
  cat << EOF
📊 GSD Agent Performance Metrics Collector v${VERSION}

Analyzes .planning/ artifacts and generates performance reports.

USAGE:
  $(basename "$0") [OPTIONS]

OPTIONS:
  -d, --dir DIR       Planning directory (default: .planning)
  -f, --format FMT    Output format: text, markdown, json (default: text)
  -o, --output FILE   Write report to file (default: stdout)
  -h, --help          Show this help message

EXAMPLES:
  # Terminal-friendly report
  $(basename "$0")

  # Markdown report
  $(basename "$0") --format markdown --output report.md

  # JSON for dashboard
  $(basename "$0") --format json --output metrics.json

  # Custom planning dir
  $(basename "$0") --dir my-project/.planning
EOF
}

# ─── Counters ────────────────────────────────────────────────
TOTAL_PHASES=0
COMPLETED_PHASES=0
TOTAL_TASKS=0
COMPLETED_TASKS=0
TOTAL_WAVES=0
QA_PASS=0
QA_FAIL=0
QA_TOTAL=0
STUB_COUNT=0
REGRESSION_COUNT=0
REWORK_CYCLES=0
BLOCKER_COUNT=0
HANDOFF_COUNT=0
HANDOFF_COMPLETE=0
DECISION_COUNT=0

# ─── Analyze Phases ─────────────────────────────────────────
analyze_phases() {
  local phases_dir="$PLANNING_DIR/phases"
  
  if [ ! -d "$phases_dir" ]; then
    return
  fi
  
  for phase_dir in "$phases_dir"/*/; do
    [ -d "$phase_dir" ] || continue
    TOTAL_PHASES=$((TOTAL_PHASES + 1))
    local phase_name=$(basename "$phase_dir")
    
    # Check if phase is complete (has QA.md with pass)
    if [ -f "${phase_dir}QA.md" ]; then
      if grep -qiE '(pass|✅.*all|verdict.*pass)' "${phase_dir}QA.md" 2>/dev/null; then
        COMPLETED_PHASES=$((COMPLETED_PHASES + 1))
      fi
    fi
    
    # Count tasks from PLAN files
    for plan_file in "${phase_dir}"PLAN*.md; do
      [ -f "$plan_file" ] || continue
      local tasks=$(grep -cE '^###\s+Task' "$plan_file" 2>/dev/null || echo "0")
      TOTAL_TASKS=$((TOTAL_TASKS + tasks))
      
      # Count waves
      local waves=$(grep -cE '^##\s+Wave' "$plan_file" 2>/dev/null || echo "0")
      TOTAL_WAVES=$((TOTAL_WAVES + waves))
    done
    
    # Analyze QA results
    if [ -f "${phase_dir}QA.md" ]; then
      QA_TOTAL=$((QA_TOTAL + 1))
      local passes=$(grep -cE '✅' "${phase_dir}QA.md" 2>/dev/null || echo "0")
      local fails=$(grep -cE '❌' "${phase_dir}QA.md" 2>/dev/null || echo "0")
      QA_PASS=$((QA_PASS + passes))
      QA_FAIL=$((QA_FAIL + fails))
    fi
    
    # Analyze HANDOFF.json
    if [ -f "${phase_dir}HANDOFF.json" ]; then
      HANDOFF_COUNT=$((HANDOFF_COUNT + 1))
      
      # Count completed tasks from handoff
      local completed=$(python3 -c "
import json, sys
try:
    with open('${phase_dir}HANDOFF.json') as f:
        data = json.load(f)
    print(len(data.get('completedTasks', [])))
except: print(0)" 2>/dev/null || echo "0")
      COMPLETED_TASKS=$((COMPLETED_TASKS + completed))
      
      # Count decisions
      local decisions=$(python3 -c "
import json, sys
try:
    with open('${phase_dir}HANDOFF.json') as f:
        data = json.load(f)
    print(len(data.get('decisions', [])))
except: print(0)" 2>/dev/null || echo "0")
      DECISION_COUNT=$((DECISION_COUNT + decisions))
      
      # Count blockers
      local blockers=$(python3 -c "
import json, sys
try:
    with open('${phase_dir}HANDOFF.json') as f:
        data = json.load(f)
    print(len(data.get('blockers', [])))
except: print(0)" 2>/dev/null || echo "0")
      BLOCKER_COUNT=$((BLOCKER_COUNT + blockers))
      
      # Check handoff completeness
      local is_complete=$(python3 -c "
import json, sys
try:
    with open('${phase_dir}HANDOFF.json') as f:
        data = json.load(f)
    required = ['phase', 'status', 'completedTasks', 'modifiedFiles']
    print(1 if all(k in data for k in required) else 0)
except: print(0)" 2>/dev/null || echo "0")
      HANDOFF_COMPLETE=$((HANDOFF_COMPLETE + is_complete))
    fi
    
    # Check for rework (multiple QA files or mentions of rework)
    local rework=$(grep -ciE 'rework|sent back|redo|fix and re-test' "${phase_dir}"*.md 2>/dev/null || echo "0")
    REWORK_CYCLES=$((REWORK_CYCLES + rework))
  done
}

# ─── Analyze Stubs ───────────────────────────────────────────
analyze_stubs() {
  # Scan source directories for stubs
  for dir in src/ lib/ app/ components/ pages/ api/ services/; do
    if [ -d "$dir" ]; then
      local stubs=$(grep -rnE 'TODO|FIXME|HACK|PLACEHOLDER|Not implemented|// stub|# stub' "$dir" 2>/dev/null | wc -l || echo "0")
      STUB_COUNT=$((STUB_COUNT + stubs))
    fi
  done
}

# ─── Analyze STATE.md ────────────────────────────────────────
analyze_state() {
  if [ -f "$PLANNING_DIR/STATE.md" ]; then
    # Check for regression mentions
    REGRESSION_COUNT=$(grep -ciE 'regression' "$PLANNING_DIR/STATE.md" 2>/dev/null || echo "0")
  fi
}

# ─── Calculate Metrics ───────────────────────────────────────
calc_qa_pass_rate() {
  local total=$((QA_PASS + QA_FAIL))
  if [ "$total" -gt 0 ]; then
    echo "scale=1; $QA_PASS * 100 / $total" | bc 2>/dev/null || echo "0"
  else
    echo "N/A"
  fi
}

calc_handoff_quality() {
  if [ "$HANDOFF_COUNT" -gt 0 ]; then
    echo "scale=1; $HANDOFF_COMPLETE * 100 / $HANDOFF_COUNT" | bc 2>/dev/null || echo "0"
  else
    echo "N/A"
  fi
}

# ─── Output: Text ────────────────────────────────────────────
output_text() {
  local qa_rate=$(calc_qa_pass_rate)
  local handoff_q=$(calc_handoff_quality)
  
  cat << EOF

${BOLD}📊 GSD Agent Performance Report${NC}
$(printf '═%.0s' {1..50})

${BOLD}📋 Project Overview${NC}
$(printf '─%.0s' {1..50})
  Phases:           $COMPLETED_PHASES / $TOTAL_PHASES complete
  Tasks:            $COMPLETED_TASKS / $TOTAL_TASKS complete
  Waves:            $TOTAL_WAVES total
  Decisions made:   $DECISION_COUNT

${BOLD}🧪 Quality Metrics${NC}
$(printf '─%.0s' {1..50})
  QA Pass Rate:     ${qa_rate}%  ($QA_PASS pass / $QA_FAIL fail)
  Rework Cycles:    $REWORK_CYCLES
  Regressions:      $REGRESSION_COUNT
  Stubs in code:    $STUB_COUNT

${BOLD}📦 Handoff Health${NC}
$(printf '─%.0s' {1..50})
  Handoffs:         $HANDOFF_COUNT created
  Completeness:     ${handoff_q}%
  Blockers:         $BLOCKER_COUNT encountered

${BOLD}🏥 Workflow Health${NC}
$(printf '─%.0s' {1..50})
EOF

  # Health indicators
  if [ "$STUB_COUNT" -eq 0 ]; then
    echo -e "  ${GREEN}✅ No stubs in production code${NC}"
  else
    echo -e "  ${RED}❌ $STUB_COUNT stubs found — clean up before shipping${NC}"
  fi
  
  if [ "$BLOCKER_COUNT" -eq 0 ]; then
    echo -e "  ${GREEN}✅ No active blockers${NC}"
  else
    echo -e "  ${YELLOW}⚠️  $BLOCKER_COUNT blocker(s) — check STATE.md${NC}"
  fi
  
  if [ "$REGRESSION_COUNT" -eq 0 ]; then
    echo -e "  ${GREEN}✅ No regressions detected${NC}"
  else
    echo -e "  ${RED}❌ $REGRESSION_COUNT regression(s) — run full test suite${NC}"
  fi
  
  echo ""
}

# ─── Output: Markdown ────────────────────────────────────────
output_markdown() {
  local qa_rate=$(calc_qa_pass_rate)
  local handoff_q=$(calc_handoff_quality)
  local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  
  cat << EOF
# 📊 GSD Agent Performance Report

> Generated: $timestamp

## Project Overview

| Metric | Value |
|--------|-------|
| Phases | $COMPLETED_PHASES / $TOTAL_PHASES complete |
| Tasks | $COMPLETED_TASKS / $TOTAL_TASKS complete |
| Waves | $TOTAL_WAVES total |
| Decisions | $DECISION_COUNT |

## Quality Metrics

| Metric | Value |
|--------|-------|
| QA Pass Rate | ${qa_rate}% ($QA_PASS/$((QA_PASS + QA_FAIL))) |
| Rework Cycles | $REWORK_CYCLES |
| Regressions | $REGRESSION_COUNT |
| Stubs in Code | $STUB_COUNT |

## Handoff Health

| Metric | Value |
|--------|-------|
| Handoffs Created | $HANDOFF_COUNT |
| Completeness | ${handoff_q}% |
| Blockers | $BLOCKER_COUNT |

## Health Indicators

$([ "$STUB_COUNT" -eq 0 ] && echo "- ✅ No stubs in production code" || echo "- ❌ $STUB_COUNT stubs found")
$([ "$BLOCKER_COUNT" -eq 0 ] && echo "- ✅ No active blockers" || echo "- ⚠️ $BLOCKER_COUNT blocker(s)")
$([ "$REGRESSION_COUNT" -eq 0 ] && echo "- ✅ No regressions" || echo "- ❌ $REGRESSION_COUNT regression(s)")
EOF
}

# ─── Output: JSON ────────────────────────────────────────────
output_json() {
  local qa_rate=$(calc_qa_pass_rate)
  local handoff_q=$(calc_handoff_quality)
  local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  
  python3 -c "
import json
data = {
    'generated': '$timestamp',
    'summary': {
        'total_phases': $TOTAL_PHASES,
        'completed_phases': $COMPLETED_PHASES,
        'total_tasks': $TOTAL_TASKS,
        'completed_tasks': $COMPLETED_TASKS,
        'total_waves': $TOTAL_WAVES,
        'qa_pass_rate': '$qa_rate',
        'rework_cycles': $REWORK_CYCLES,
        'total_regressions': $REGRESSION_COUNT,
        'blockers_encountered': $BLOCKER_COUNT,
        'decisions_made': $DECISION_COUNT,
        'stub_count': $STUB_COUNT,
        'handoff_count': $HANDOFF_COUNT,
        'handoff_completeness': '$handoff_q'
    }
}
print(json.dumps(data, indent=2))
"
}

# ─── Parse Args ──────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case $1 in
    -d|--dir) PLANNING_DIR="$2"; shift 2 ;;
    -f|--format) OUTPUT_FORMAT="$2"; shift 2 ;;
    -o|--output) OUTPUT_FILE="$2"; shift 2 ;;
    -h|--help) show_help; exit 0 ;;
    *) echo -e "${RED}Unknown option: $1${NC}"; show_help; exit 1 ;;
  esac
done

# ─── Execute ─────────────────────────────────────────────────
echo -e "${BLUE}📊 Collecting metrics from $PLANNING_DIR${NC}" >&2

analyze_phases
analyze_stubs
analyze_state

# Output
if [ -n "$OUTPUT_FILE" ]; then
  case "$OUTPUT_FORMAT" in
    text) output_text > "$OUTPUT_FILE" 2>/dev/null ;;
    markdown|md) output_markdown > "$OUTPUT_FILE" ;;
    json) output_json > "$OUTPUT_FILE" ;;
    *) echo -e "${RED}Unknown format: $OUTPUT_FORMAT${NC}"; exit 1 ;;
  esac
  echo -e "${GREEN}✅ Report written to $OUTPUT_FILE${NC}" >&2
else
  case "$OUTPUT_FORMAT" in
    text) output_text ;;
    markdown|md) output_markdown ;;
    json) output_json ;;
    *) echo -e "${RED}Unknown format: $OUTPUT_FORMAT${NC}"; exit 1 ;;
  esac
fi
