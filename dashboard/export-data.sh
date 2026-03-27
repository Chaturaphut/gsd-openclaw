#!/bin/bash
# ─────────────────────────────────────────────────────────────
# GSD Dashboard Data Exporter
# Exports .planning/ data as JSON for the dashboard
# ─────────────────────────────────────────────────────────────

set -euo pipefail

VERSION="1.0.0"
PLANNING_DIR=".planning"
OUTPUT_FILE="dashboard-data.json"

# ─── Colors ──────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# ─── Help ────────────────────────────────────────────────────
show_help() {
  cat << EOF
📦 GSD Dashboard Data Exporter v${VERSION}

Exports .planning/ artifacts as JSON for the web dashboard.

USAGE:
  $(basename "$0") [OPTIONS]

OPTIONS:
  -d, --dir DIR       Planning directory (default: .planning)
  -o, --output FILE   Output file (default: dashboard-data.json)
  -h, --help          Show this help message

EXAMPLES:
  # Export to default file
  $(basename "$0")

  # Custom output
  $(basename "$0") --output my-data.json

  # Custom planning dir
  $(basename "$0") --dir my-project/.planning
EOF
}

# ─── Parse Args ──────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case $1 in
    -d|--dir) PLANNING_DIR="$2"; shift 2 ;;
    -o|--output) OUTPUT_FILE="$2"; shift 2 ;;
    -h|--help) show_help; exit 0 ;;
    *) echo -e "${RED}Unknown: $1${NC}"; show_help; exit 1 ;;
  esac
done

# ─── Validate ────────────────────────────────────────────────
if [ ! -d "$PLANNING_DIR" ]; then
  echo -e "${RED}❌ Planning directory not found: $PLANNING_DIR${NC}"
  exit 1
fi

echo -e "${BLUE}📦 Exporting data from $PLANNING_DIR${NC}"

# ─── Collect Data ────────────────────────────────────────────
python3 << 'PYEOF'
import json
import os
import re
import sys
from datetime import datetime
from pathlib import Path

planning_dir = os.environ.get('PLANNING_DIR', '.planning')
output_file = os.environ.get('OUTPUT_FILE', 'dashboard-data.json')

data = {
    "project": "",
    "generated": datetime.utcnow().isoformat() + "Z",
    "summary": {
        "total_phases": 0,
        "completed_phases": 0,
        "total_tasks": 0,
        "completed_tasks": 0,
        "total_waves": 0,
        "qa_pass_rate": 0,
        "rework_cycles": 0,
        "total_regressions": 0,
        "blockers_encountered": 0,
        "stub_count": 0,
        "decisions_made": 0
    },
    "phases": [],
    "agents": [],
    "qa_summary": {
        "total_checks": 0,
        "passed": 0,
        "failed": 0,
        "skipped": 0,
        "categories": {}
    }
}

# Read project name
project_file = os.path.join(planning_dir, "PROJECT.md")
if os.path.isfile(project_file):
    with open(project_file) as f:
        for line in f:
            if line.startswith("#"):
                data["project"] = line.lstrip("#").strip()
                break

# Read requirements
req_file = os.path.join(planning_dir, "REQUIREMENTS.md")
total_reqs = 0
done_reqs = 0
if os.path.isfile(req_file):
    with open(req_file) as f:
        for line in f:
            if re.match(r'\s*-\s*\[[ x]\]', line):
                total_reqs += 1
                if re.match(r'\s*-\s*\[x\]', line):
                    done_reqs += 1

# Process phases
phases_dir = os.path.join(planning_dir, "phases")
if os.path.isdir(phases_dir):
    for phase_name in sorted(os.listdir(phases_dir)):
        phase_path = os.path.join(phases_dir, phase_name)
        if not os.path.isdir(phase_path):
            continue

        phase = {
            "name": phase_name.replace("-", " ").title(),
            "status": "pending",
            "tasks": {"total": 0, "completed": 0},
            "waves": [],
            "qa": {"passed": False, "pass_count": 0, "fail_count": 0}
        }

        data["summary"]["total_phases"] += 1

        # Read PLAN files
        for f in sorted(os.listdir(phase_path)):
            if f.startswith("PLAN") and f.endswith(".md"):
                plan_path = os.path.join(phase_path, f)
                with open(plan_path) as pf:
                    content = pf.read()
                    tasks = len(re.findall(r'^###\s+Task', content, re.MULTILINE))
                    waves_found = re.findall(r'^##\s+Wave\s+\d+[:\s]*(.*)', content, re.MULTILINE)
                    phase["tasks"]["total"] += tasks
                    data["summary"]["total_tasks"] += tasks
                    data["summary"]["total_waves"] += len(waves_found)

                    for wm in waves_found:
                        wave_name = wm.strip() if wm.strip() else f"Wave {len(phase['waves'])+1}"
                        phase["waves"].append({
                            "name": wave_name,
                            "tasks": []
                        })

        # Read HANDOFF.json
        handoff_path = os.path.join(phase_path, "HANDOFF.json")
        if os.path.isfile(handoff_path):
            try:
                with open(handoff_path) as hf:
                    handoff = json.load(hf)
                completed = len(handoff.get("completedTasks", []))
                phase["tasks"]["completed"] = completed
                data["summary"]["completed_tasks"] += completed
                data["summary"]["decisions_made"] += len(handoff.get("decisions", []))
                data["summary"]["blockers_encountered"] += len(handoff.get("blockers", []))

                if handoff.get("status") == "complete":
                    phase["status"] = "complete"
                else:
                    phase["status"] = "in-progress"
            except json.JSONDecodeError:
                pass

        # Read QA.md
        qa_path = os.path.join(phase_path, "QA.md")
        if os.path.isfile(qa_path):
            with open(qa_path) as qf:
                qa_content = qf.read()
                passes = len(re.findall(r'✅', qa_content))
                fails = len(re.findall(r'❌', qa_content))
                phase["qa"]["pass_count"] = passes
                phase["qa"]["fail_count"] = fails
                data["qa_summary"]["passed"] += passes
                data["qa_summary"]["failed"] += fails
                data["qa_summary"]["total_checks"] += passes + fails

                if re.search(r'(?i)(pass|verdict.*pass)', qa_content):
                    phase["qa"]["passed"] = True
                    if phase["status"] == "pending":
                        phase["status"] = "complete"
                    data["summary"]["completed_phases"] += 1

        data["phases"].append(phase)

# Calculate QA pass rate
total_qa = data["qa_summary"]["passed"] + data["qa_summary"]["failed"]
if total_qa > 0:
    data["summary"]["qa_pass_rate"] = round(data["qa_summary"]["passed"] / total_qa * 100, 1)

# Count stubs in source directories
stub_count = 0
for src_dir in ["src", "lib", "app", "components", "pages", "api", "services"]:
    if os.path.isdir(src_dir):
        for root, dirs, files in os.walk(src_dir):
            for fname in files:
                if fname.endswith(('.ts', '.tsx', '.js', '.jsx', '.py', '.go', '.rs', '.java')):
                    try:
                        with open(os.path.join(root, fname)) as sf:
                            content = sf.read()
                            stub_count += len(re.findall(r'TODO|FIXME|HACK|PLACEHOLDER', content))
                    except:
                        pass
data["summary"]["stub_count"] = stub_count

# Write output
with open(output_file, 'w') as out:
    json.dump(data, out, indent=2, ensure_ascii=False)

print(f"✅ Exported to {output_file}")
print(f"   Phases: {data['summary']['total_phases']}")
print(f"   Tasks: {data['summary']['total_tasks']}")
print(f"   QA checks: {data['qa_summary']['total_checks']}")
PYEOF

echo -e "${GREEN}✅ Export complete: $OUTPUT_FILE${NC}"
echo -e "Open dashboard/index.html and load this file"
