# 🎨 Workflow Visualization Tools

Generate visual diagrams and dashboards from your GSD workflow state.

## Files

| File | Description |
|------|-------------|
| `generate-mermaid.sh` | Generate Mermaid diagrams from .planning/ |
| `workflow-status.sh` | Terminal-based workflow dashboard |
| `templates/` | Ready-to-use Mermaid templates |

## Quick Start

### Terminal Dashboard

```bash
# One-shot view
./tools/visualize/workflow-status.sh

# Watch mode (refreshes every 5s)
./tools/visualize/workflow-status.sh --watch

# Compact view
./tools/visualize/workflow-status.sh --compact
```

Example output:
```
╔══════════════════════════════════════════════════╗
║       📊 GSD Workflow Status Dashboard          ║
╚══════════════════════════════════════════════════╝
  2026-03-27 10:30:00  |  .planning

  📋 Requirements
     [████████████████░░░░░░░░░] 64% (7/11)

  🔄 Phases
     ✅ phase 1 api setup — QA passed
        Tasks: 5 | Waves: 2
     ⚡ phase 2 frontend — executing
        Tasks: 8 | Waves: 3
     ⬜ phase 3 polish — pending

  🏥 Quick Health
     ✅ No stubs
     📦 1 handoff(s)
     ✅ No blockers
     🌱 3 seed(s) in backlog
```

### Mermaid Diagrams

```bash
# Workflow flowchart
./tools/visualize/generate-mermaid.sh flowchart

# Phase timeline
./tools/visualize/generate-mermaid.sh gantt

# Task state machine
./tools/visualize/generate-mermaid.sh state

# Wave dependency graph
./tools/visualize/generate-mermaid.sh wave

# All diagrams in one file
./tools/visualize/generate-mermaid.sh all --output diagrams.md
```

### Use Mermaid Templates

Copy templates for your documentation:

```bash
# View available templates
ls tools/visualize/templates/

# Templates included:
# - workflow-stages.md   — Full GSD workflow flowchart
# - wave-execution.md    — Parallel wave execution
# - dependency-graph.md  — Task dependencies with critical path
```

Paste the Mermaid code into GitHub/GitLab markdown, Notion, or any Mermaid-compatible renderer.

## Diagram Types

### Flowchart (`flowchart`)
Shows the complete GSD workflow with phase statuses:
- ⬜ Pending → 🔬 Researching → ⚡ Executing → 🧪 QA → ✅ Done

### Gantt Chart (`gantt`)
Timeline view of phases with durations (reads timestamps from HANDOFF.json when available).

### State Diagram (`state`)
Task lifecycle: Planned → InProgress → Review → QA → Done (with rework loops).

### Wave Graph (`wave`)
Reads PLAN.md files and shows task groupings per wave with dependencies.

## Options

### generate-mermaid.sh
```
  -d, --dir DIR       Planning directory
  -o, --output FILE   Write to file
  -h, --help          Show help
```

### workflow-status.sh
```
  -d, --dir DIR       Planning directory
  -w, --watch         Auto-refresh every 5s
  -c, --compact       Less detail
  -h, --help          Show help
```
