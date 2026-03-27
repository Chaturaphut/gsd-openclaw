# 📊 Interactive Workflow Dashboard

A single-file HTML dashboard for visualizing GSD workflow progress — no build tools required.

## Quick Start

### 1. Export your workflow data

```bash
cd your-project/
./dashboard/export-data.sh
# Creates: dashboard-data.json
```

### 2. Open the dashboard

```bash
# Simply open in your browser
open dashboard/index.html
# or
xdg-open dashboard/index.html
```

### 3. Load your data

- **File upload:** Click "📂 Load Data" → drag & drop or browse for your JSON
- **Paste:** Click "📂 Load Data" → paste JSON into the text area → click "Load"
- **Sample:** Click "🎯 Sample Data" to see a demo

## Features

- 📋 **Overview stats** — Phases, tasks, waves, decisions at a glance
- 🧪 **Quality metrics** — QA pass rate, rework cycles, regressions, stub count
- 🔄 **Phase progress** — Each phase with progress bar and status
- 🌊 **Wave timeline** — Horizontal timeline of wave execution
- 👥 **Agent assignments** — Who's working on what, task completion
- ✅ **QA results** — Pass/fail/skip breakdown by category
- 🌙 **Dark theme** — Easy on the eyes
- 📱 **Responsive** — Works on desktop and mobile

## Data Format

The dashboard expects JSON with this structure:

```json
{
  "project": "My App",
  "generated": "2026-03-27T10:00:00Z",
  "summary": {
    "total_phases": 3,
    "completed_phases": 2,
    "total_tasks": 15,
    "completed_tasks": 11,
    "total_waves": 7,
    "qa_pass_rate": 93.5,
    "rework_cycles": 2,
    "total_regressions": 0,
    "blockers_encountered": 1,
    "stub_count": 0,
    "decisions_made": 8
  },
  "phases": [
    {
      "name": "Phase 1: API",
      "status": "complete",
      "tasks": { "total": 5, "completed": 5 },
      "waves": [
        { "name": "Wave 1: Foundation", "tasks": ["DB Schema", "Auth"] }
      ],
      "qa": { "passed": true, "pass_count": 12, "fail_count": 0 }
    }
  ],
  "agents": [
    { "id": "Agent-1", "role": "Developer", "tasks_assigned": 8, "tasks_completed": 8, "status": "idle" }
  ],
  "qa_summary": {
    "total_checks": 30,
    "passed": 28,
    "failed": 1,
    "skipped": 1,
    "categories": {
      "functional": { "passed": 12, "failed": 0 },
      "regression": { "passed": 8, "failed": 1 }
    }
  }
}
```

## Export Script Options

```bash
# Default export
./dashboard/export-data.sh

# Custom planning directory
./dashboard/export-data.sh --dir my-project/.planning

# Custom output file
./dashboard/export-data.sh --output my-metrics.json
```

## No Build Required

The dashboard is a single `index.html` file with:
- Inline CSS (dark theme, responsive)
- Inline JavaScript (data loading, rendering)
- No dependencies, no npm, no build step
- Works offline — just open in any modern browser
