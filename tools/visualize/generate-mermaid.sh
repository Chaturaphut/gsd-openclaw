#!/bin/bash
# ─────────────────────────────────────────────────────────────
# GSD Workflow Mermaid Diagram Generator
# Reads .planning/ and generates Mermaid diagrams
# ─────────────────────────────────────────────────────────────

set -euo pipefail

VERSION="1.0.0"
PLANNING_DIR=".planning"
DIAGRAM_TYPE="flowchart"
OUTPUT_FILE=""

# ─── Colors ──────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# ─── Help ────────────────────────────────────────────────────
show_help() {
  cat << EOF
🎨 GSD Mermaid Diagram Generator v${VERSION}

Generates Mermaid diagrams from .planning/ artifacts.

USAGE:
  $(basename "$0") [OPTIONS] [DIAGRAM_TYPE]

DIAGRAM TYPES:
  flowchart     Workflow stages flowchart (default)
  gantt         Phase timeline gantt chart
  state         Task state diagram
  wave          Wave execution dependency graph
  all           Generate all diagram types

OPTIONS:
  -d, --dir DIR       Planning directory (default: .planning)
  -o, --output FILE   Write to file (default: stdout)
  -h, --help          Show this help message

EXAMPLES:
  # Generate workflow flowchart
  $(basename "$0") flowchart

  # Generate gantt chart
  $(basename "$0") gantt --output gantt.md

  # Generate all diagrams
  $(basename "$0") all --output diagrams.md

  # Custom planning dir
  $(basename "$0") --dir my-project/.planning wave
EOF
}

# ─── Flowchart: Workflow Stages ──────────────────────────────
generate_flowchart() {
  echo '```mermaid'
  echo 'flowchart TD'
  echo '    Start([🚀 Start]) --> Req[📋 Requirements]'
  echo '    Req --> Research[🔬 Research]'
  echo '    Req --> |Quick/Fast Mode| Plan'
  echo '    Research --> Plan[📐 Plan]'
  echo '    Plan --> Verify{✅ Plan Verified?}'
  echo '    Verify --> |No| Plan'
  echo '    Verify --> |Yes| Execute'
  echo ''
  
  # Add phases as execution nodes
  local phases_dir="$PLANNING_DIR/phases"
  if [ -d "$phases_dir" ]; then
    local phase_count=0
    local prev_node="Execute"
    
    for phase_dir in "$phases_dir"/*/; do
      [ -d "$phase_dir" ] || continue
      phase_count=$((phase_count + 1))
      local phase_name=$(basename "$phase_dir")
      local node_id="Phase${phase_count}"
      local display_name=$(echo "$phase_name" | sed 's/-/ /g' | sed 's/phase /Phase /')
      
      # Check status
      local status="⬜"
      if [ -f "${phase_dir}QA.md" ]; then
        if grep -qiE '(pass|✅.*all)' "${phase_dir}QA.md" 2>/dev/null; then
          status="✅"
        else
          status="🔄"
        fi
      elif [ -f "${phase_dir}HANDOFF.json" ]; then
        status="🔄"
      fi
      
      echo "    Execute[⚡ Execute Waves] --> ${node_id}[${status} ${display_name}]"
      prev_node="$node_id"
    done
    
    if [ "$phase_count" -gt 0 ]; then
      echo "    ${prev_node} --> QA[🧪 QA & Verify]"
    else
      echo '    Execute[⚡ Execute Waves] --> QA[🧪 QA & Verify]'
    fi
  else
    echo '    Execute[⚡ Execute Waves] --> QA[🧪 QA & Verify]'
  fi
  
  echo '    QA --> RegGate{🔄 Regression Gate}'
  echo '    RegGate --> |Pass| StubCheck{🔍 Stub Detection}'
  echo '    RegGate --> |Fail| Execute'
  echo '    StubCheck --> |Clean| Ship([🚢 Ship It])'
  echo '    StubCheck --> |Stubs Found| Execute'
  echo ''
  echo '    style Start fill:#4CAF50,color:#fff'
  echo '    style Ship fill:#4CAF50,color:#fff'
  echo '    style Verify fill:#FF9800,color:#fff'
  echo '    style RegGate fill:#FF9800,color:#fff'
  echo '    style StubCheck fill:#FF9800,color:#fff'
  echo '```'
}

# ─── Gantt: Phase Timeline ───────────────────────────────────
generate_gantt() {
  echo '```mermaid'
  echo 'gantt'
  echo '    title GSD Project Timeline'
  echo '    dateFormat YYYY-MM-DD'
  echo ''
  
  local phases_dir="$PLANNING_DIR/phases"
  if [ -d "$phases_dir" ]; then
    echo '    section Phases'
    
    local phase_count=0
    for phase_dir in "$phases_dir"/*/; do
      [ -d "$phase_dir" ] || continue
      phase_count=$((phase_count + 1))
      local phase_name=$(basename "$phase_dir" | sed 's/-/ /g' | sed 's/phase /Phase /')
      
      # Try to get dates from HANDOFF.json
      local start_date=$(python3 -c "
import json, sys
try:
    with open('${phase_dir}HANDOFF.json') as f:
        data = json.load(f)
    ts = data.get('timestamp', '')
    if ts: print(ts[:10])
    else: print('')
except: print('')" 2>/dev/null || echo "")
      
      # Check status
      local status=""
      if [ -f "${phase_dir}QA.md" ] && grep -qiE '(pass|✅.*all)' "${phase_dir}QA.md" 2>/dev/null; then
        status="done,"
      elif [ -f "${phase_dir}HANDOFF.json" ]; then
        status="active,"
      fi
      
      if [ -n "$start_date" ]; then
        echo "    ${phase_name} :${status} p${phase_count}, ${start_date}, 7d"
      else
        if [ "$phase_count" -eq 1 ]; then
          echo "    ${phase_name} :${status} p${phase_count}, 2026-01-01, 7d"
        else
          local prev=$((phase_count - 1))
          echo "    ${phase_name} :${status} p${phase_count}, after p${prev}, 7d"
        fi
      fi
    done
    
    # Add QA section
    if [ "$phase_count" -gt 0 ]; then
      echo ''
      echo '    section QA'
      echo "    QA & Verification :qa1, after p${phase_count}, 3d"
      echo '    Regression Testing :reg1, after qa1, 2d'
    fi
  else
    echo '    section Workflow'
    echo '    Requirements :req, 2026-01-01, 2d'
    echo '    Research :res, after req, 3d'
    echo '    Planning :plan, after res, 2d'
    echo '    Execution :exec, after plan, 7d'
    echo '    QA :qa, after exec, 3d'
  fi
  
  echo '```'
}

# ─── State: Task States ─────────────────────────────────────
generate_state() {
  echo '```mermaid'
  echo 'stateDiagram-v2'
  echo '    [*] --> Planned'
  echo '    Planned --> InProgress: Agent picks up task'
  echo '    InProgress --> Review: Task complete'
  echo '    Review --> QA: Code review passed'
  echo '    Review --> InProgress: Changes requested'
  echo '    QA --> Done: QA passed ✅'
  echo '    QA --> InProgress: QA failed ❌'
  echo '    InProgress --> Blocked: Blocker found'
  echo '    Blocked --> InProgress: Blocker resolved'
  echo '    Done --> [*]'
  echo ''
  echo '    state InProgress {'
  echo '        [*] --> Coding'
  echo '        Coding --> Testing: Unit tests'
  echo '        Testing --> Coding: Tests fail'
  echo '        Testing --> [*]: Tests pass'
  echo '    }'
  echo ''
  echo '    state QA {'
  echo '        [*] --> Functional'
  echo '        Functional --> Regression: Pass'
  echo '        Regression --> StubCheck: Pass'
  echo '        StubCheck --> [*]: Clean'
  echo '        Functional --> [*]: Fail'
  echo '        Regression --> [*]: Regression found'
  echo '        StubCheck --> [*]: Stubs found'
  echo '    }'
  echo '```'
}

# ─── Wave: Dependency Graph ──────────────────────────────────
generate_wave() {
  echo '```mermaid'
  echo 'flowchart LR'
  echo ''
  
  local phases_dir="$PLANNING_DIR/phases"
  local found_plans=false
  
  if [ -d "$phases_dir" ]; then
    for plan_file in $(find "$phases_dir" -name "PLAN*.md" -type f 2>/dev/null | sort); do
      [ -f "$plan_file" ] || continue
      found_plans=true
      
      local current_wave=""
      local task_num=0
      
      while IFS= read -r line; do
        # Detect wave headers
        if echo "$line" | grep -qE '^##\s+Wave'; then
          current_wave=$(echo "$line" | grep -oE 'Wave [0-9]+' | tr ' ' '')
          echo "    subgraph ${current_wave}[🌊 $(echo "$line" | sed 's/^##\s*//' | sed 's/[^a-zA-Z0-9 :_-]//g')]"
        fi
        
        # Detect tasks
        if echo "$line" | grep -qE '^###\s+Task'; then
          task_num=$((task_num + 1))
          local task_name=$(echo "$line" | sed 's/^###\s*//' | sed 's/[^a-zA-Z0-9 :_-]//g' | head -c 40)
          echo "        T${task_num}[${task_name}]"
        fi
        
        # Close subgraph on next wave or end
        if echo "$line" | grep -qE '^##\s+(Wave|Acceptance)' && [ -n "$current_wave" ] && ! echo "$line" | grep -qE "^##\s+${current_wave}"; then
          echo "    end"
        fi
      done < "$plan_file"
      
      # Close last subgraph
      if [ -n "$current_wave" ]; then
        echo "    end"
      fi
    done
  fi
  
  if [ "$found_plans" = false ]; then
    # Default wave structure
    echo '    subgraph Wave1[🌊 Wave 1: Foundation]'
    echo '        T1[Task 1.1: Independent]'
    echo '        T2[Task 1.2: Independent]'
    echo '        T3[Task 1.3: Independent]'
    echo '    end'
    echo ''
    echo '    subgraph Wave2[🌊 Wave 2: Integration]'
    echo '        T4[Task 2.1: Depends on Wave 1]'
    echo '        T5[Task 2.2: Depends on Wave 1]'
    echo '    end'
    echo ''
    echo '    subgraph Wave3[🌊 Wave 3: Polish]'
    echo '        T6[Task 3.1: End-to-end]'
    echo '    end'
    echo ''
    echo '    T1 --> T4'
    echo '    T2 --> T4'
    echo '    T3 --> T5'
    echo '    T4 --> T6'
    echo '    T5 --> T6'
  fi
  
  echo '```'
}

# ─── Generate All ────────────────────────────────────────────
generate_all() {
  echo "# 🎨 GSD Workflow Diagrams"
  echo ""
  echo "> Generated: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  echo ""
  echo "## Workflow Flowchart"
  echo ""
  generate_flowchart
  echo ""
  echo "## Project Timeline"
  echo ""
  generate_gantt
  echo ""
  echo "## Task State Machine"
  echo ""
  generate_state
  echo ""
  echo "## Wave Execution Graph"
  echo ""
  generate_wave
}

# ─── Parse Args ──────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case $1 in
    -d|--dir) PLANNING_DIR="$2"; shift 2 ;;
    -o|--output) OUTPUT_FILE="$2"; shift 2 ;;
    -h|--help) show_help; exit 0 ;;
    flowchart|gantt|state|wave|all) DIAGRAM_TYPE="$1"; shift ;;
    *) echo -e "${RED}Unknown option: $1${NC}"; show_help; exit 1 ;;
  esac
done

# ─── Execute ─────────────────────────────────────────────────
generate() {
  case "$DIAGRAM_TYPE" in
    flowchart) generate_flowchart ;;
    gantt) generate_gantt ;;
    state) generate_state ;;
    wave) generate_wave ;;
    all) generate_all ;;
    *) echo -e "${RED}Unknown diagram type: $DIAGRAM_TYPE${NC}"; exit 1 ;;
  esac
}

if [ -n "$OUTPUT_FILE" ]; then
  generate > "$OUTPUT_FILE"
  echo -e "${GREEN}✅ Diagram written to $OUTPUT_FILE${NC}" >&2
else
  generate
fi
