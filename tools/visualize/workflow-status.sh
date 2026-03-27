#!/bin/bash
# ─────────────────────────────────────────────────────────────
# GSD Workflow Status Dashboard (Terminal)
# Text-based dashboard from .planning/STATE.md and artifacts
# ─────────────────────────────────────────────────────────────

set -euo pipefail

VERSION="1.0.0"
PLANNING_DIR=".planning"

# ─── Colors ──────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

# ─── Help ────────────────────────────────────────────────────
show_help() {
  cat << EOF
📊 GSD Workflow Status Dashboard v${VERSION}

Terminal-friendly dashboard showing workflow progress.

USAGE:
  $(basename "$0") [OPTIONS]

OPTIONS:
  -d, --dir DIR    Planning directory (default: .planning)
  -w, --watch      Refresh every 5 seconds
  -c, --compact    Compact view (less detail)
  -h, --help       Show this help message

EXAMPLES:
  $(basename "$0")
  $(basename "$0") --watch
  $(basename "$0") --dir my-project/.planning --compact
EOF
}

# ─── Progress Bar ────────────────────────────────────────────
progress_bar() {
  local current=$1
  local total=$2
  local width=${3:-30}
  
  if [ "$total" -eq 0 ]; then
    printf "[%-${width}s] %s" "" "N/A"
    return
  fi
  
  local pct=$((current * 100 / total))
  local filled=$((current * width / total))
  local empty=$((width - filled))
  
  local bar=""
  for ((i=0; i<filled; i++)); do bar="${bar}█"; done
  for ((i=0; i<empty; i++)); do bar="${bar}░"; done
  
  local color="$RED"
  [ "$pct" -ge 30 ] && color="$YELLOW"
  [ "$pct" -ge 70 ] && color="$GREEN"
  
  printf "${color}[%s]${NC} %d%%" "$bar" "$pct"
}

# ─── Render Dashboard ────────────────────────────────────────
render() {
  local COMPACT=${1:-false}
  
  # Header
  echo ""
  echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════════════╗${NC}"
  echo -e "${BOLD}${CYAN}║       📊 GSD Workflow Status Dashboard          ║${NC}"
  echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════════╝${NC}"
  echo -e "${DIM}  $(date '+%Y-%m-%d %H:%M:%S')  |  $PLANNING_DIR${NC}"
  echo ""
  
  # Check if planning dir exists
  if [ ! -d "$PLANNING_DIR" ]; then
    echo -e "  ${RED}❌ No .planning/ directory found${NC}"
    echo -e "  ${DIM}Run 'mkdir .planning && touch .planning/REQUIREMENTS.md' to start${NC}"
    return
  fi
  
  # ─── Requirements ──────────────────────────────────────────
  echo -e "${BOLD}  📋 Requirements${NC}"
  if [ -f "$PLANNING_DIR/REQUIREMENTS.md" ]; then
    local total_req=$(grep -cE '^\s*-\s*\[[ x]\]' "$PLANNING_DIR/REQUIREMENTS.md" 2>/dev/null || echo "0")
    local done_req=$(grep -cE '^\s*-\s*\[x\]' "$PLANNING_DIR/REQUIREMENTS.md" 2>/dev/null || echo "0")
    echo -ne "     "
    progress_bar "$done_req" "$total_req" 25
    echo " ($done_req/$total_req)"
  else
    echo -e "     ${DIM}No REQUIREMENTS.md${NC}"
  fi
  echo ""
  
  # ─── Phases ────────────────────────────────────────────────
  echo -e "${BOLD}  🔄 Phases${NC}"
  local phases_dir="$PLANNING_DIR/phases"
  if [ -d "$phases_dir" ]; then
    for phase_dir in "$phases_dir"/*/; do
      [ -d "$phase_dir" ] || continue
      local phase_name=$(basename "$phase_dir")
      local display=$(echo "$phase_name" | sed 's/-/ /g')
      
      # Determine status
      local icon="⬜"
      local status_text="pending"
      local status_color="$DIM"
      
      if [ -f "${phase_dir}QA.md" ]; then
        if grep -qiE '(pass|✅.*all|verdict.*pass)' "${phase_dir}QA.md" 2>/dev/null; then
          icon="✅"; status_text="QA passed"; status_color="$GREEN"
        else
          icon="🧪"; status_text="in QA"; status_color="$YELLOW"
        fi
      elif [ -f "${phase_dir}HANDOFF.json" ]; then
        icon="📦"; status_text="handed off"; status_color="$BLUE"
      elif ls "${phase_dir}"PLAN*.md &>/dev/null 2>&1; then
        icon="⚡"; status_text="executing"; status_color="$CYAN"
      elif [ -f "${phase_dir}RESEARCH.md" ]; then
        icon="🔬"; status_text="researching"; status_color="$MAGENTA"
      fi
      
      echo -e "     ${icon} ${BOLD}${display}${NC} — ${status_color}${status_text}${NC}"
      
      # Show tasks if not compact
      if [ "$COMPACT" = "false" ]; then
        for plan_file in "${phase_dir}"PLAN*.md; do
          [ -f "$plan_file" ] || continue
          local tasks=$(grep -cE '^###\s+Task' "$plan_file" 2>/dev/null || echo "0")
          local waves=$(grep -cE '^##\s+Wave' "$plan_file" 2>/dev/null || echo "0")
          echo -e "        ${DIM}Tasks: $tasks | Waves: $waves${NC}"
        done
        
        # Show blockers from HANDOFF.json
        if [ -f "${phase_dir}HANDOFF.json" ]; then
          local blockers=$(python3 -c "
import json
try:
    with open('${phase_dir}HANDOFF.json') as f:
        data = json.load(f)
    for b in data.get('blockers', []):
        print('🚫 ' + str(b.get('description', b) if isinstance(b, dict) else b))
except: pass" 2>/dev/null || true)
          if [ -n "$blockers" ]; then
            echo -e "        ${RED}${blockers}${NC}"
          fi
        fi
      fi
    done
  else
    echo -e "     ${DIM}No phases directory${NC}"
  fi
  echo ""
  
  # ─── Active State ──────────────────────────────────────────
  if [ -f "$PLANNING_DIR/STATE.md" ]; then
    echo -e "${BOLD}  🎯 Current State${NC}"
    # Show first few meaningful lines
    grep -E '^##|^-|^>|^\*' "$PLANNING_DIR/STATE.md" 2>/dev/null | head -5 | while IFS= read -r line; do
      echo -e "     ${line}"
    done
    echo ""
  fi
  
  # ─── Quick Health ──────────────────────────────────────────
  echo -e "${BOLD}  🏥 Quick Health${NC}"
  
  # Stubs
  local stub_count=0
  for dir in src/ lib/ app/ components/ pages/ api/ services/; do
    if [ -d "$dir" ]; then
      local c=$(grep -rnE 'TODO|FIXME|HACK|PLACEHOLDER' "$dir" 2>/dev/null | wc -l || echo "0")
      stub_count=$((stub_count + c))
    fi
  done
  if [ "$stub_count" -eq 0 ]; then
    echo -e "     ${GREEN}✅ No stubs${NC}"
  else
    echo -e "     ${RED}❌ $stub_count stub(s) in code${NC}"
  fi
  
  # Handoffs
  local handoff_count=$(find "$PLANNING_DIR" -name "HANDOFF.json" -type f 2>/dev/null | wc -l || echo "0")
  echo -e "     ${BLUE}📦 $handoff_count handoff(s)${NC}"
  
  # Blockers
  if [ -f "$PLANNING_DIR/STATE.md" ] && grep -qiE 'block' "$PLANNING_DIR/STATE.md" 2>/dev/null; then
    echo -e "     ${RED}🚫 Blockers mentioned in STATE.md${NC}"
  else
    echo -e "     ${GREEN}✅ No blockers${NC}"
  fi
  
  # Seeds
  local seed_count=0
  [ -d "$PLANNING_DIR/seeds" ] && seed_count=$(ls "$PLANNING_DIR/seeds/" 2>/dev/null | wc -l || echo "0")
  if [ "$seed_count" -gt 0 ]; then
    echo -e "     ${YELLOW}🌱 $seed_count seed(s) in backlog${NC}"
  fi
  
  # Waiting
  if [ -f "$PLANNING_DIR/WAITING.json" ]; then
    echo -e "     ${YELLOW}⏳ Decision waiting (WAITING.json)${NC}"
  fi
  
  echo ""
  echo -e "${DIM}  ─────────────────────────────────────────────────${NC}"
  echo -e "${DIM}  Generated by GSD Workflow Status Dashboard v${VERSION}${NC}"
  echo ""
}

# ─── Parse Args ──────────────────────────────────────────────
WATCH=false
COMPACT=false

while [[ $# -gt 0 ]]; do
  case $1 in
    -d|--dir) PLANNING_DIR="$2"; shift 2 ;;
    -w|--watch) WATCH=true; shift ;;
    -c|--compact) COMPACT=true; shift ;;
    -h|--help) show_help; exit 0 ;;
    *) echo -e "${RED}Unknown option: $1${NC}"; show_help; exit 1 ;;
  esac
done

# ─── Execute ─────────────────────────────────────────────────
if [ "$WATCH" = "true" ]; then
  while true; do
    clear
    render "$COMPACT"
    sleep 5
  done
else
  render "$COMPACT"
fi
