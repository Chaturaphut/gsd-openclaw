# 📊 Agent Performance Analytics

Track and analyze agent performance across GSD workflow phases.

## Files

| File | Description |
|------|-------------|
| `collect-metrics.sh` | Script to collect metrics from .planning/ artifacts |
| `metrics-template.json` | JSON schema for performance data |
| `report-template.md` | Markdown report template with placeholders |

## Quick Start

### Generate a terminal report

```bash
./tools/analytics/collect-metrics.sh
```

Output:
```
📊 GSD Agent Performance Report
══════════════════════════════════════════════════

📋 Project Overview
──────────────────────────────────────────────────
  Phases:           2 / 3 complete
  Tasks:            8 / 12 complete
  Waves:            6 total
  Decisions made:   5

🧪 Quality Metrics
──────────────────────────────────────────────────
  QA Pass Rate:     92.3%  (12 pass / 1 fail)
  Rework Cycles:    2
  Regressions:      0
  Stubs in code:    0

📦 Handoff Health
──────────────────────────────────────────────────
  Handoffs:         2 created
  Completeness:     100.0%
  Blockers:         1 encountered
```

### Generate markdown report

```bash
./tools/analytics/collect-metrics.sh --format markdown --output report.md
```

### Generate JSON for dashboard

```bash
./tools/analytics/collect-metrics.sh --format json --output metrics.json
```

## What It Analyzes

The collector reads these `.planning/` artifacts:

| Artifact | Metrics Extracted |
|----------|------------------|
| `PLAN*.md` | Task count, wave count |
| `QA.md` | Pass/fail counts, pass rate |
| `HANDOFF.json` | Completed tasks, decisions, blockers, completeness |
| `STATE.md` | Regression mentions |
| Source code | Stub/TODO count |

## Metrics Tracked

### Project Level
- Phase completion rate
- Task completion rate
- Total waves executed
- Decisions made

### Quality
- QA pass rate (✅ vs ❌ in QA.md)
- Rework cycles (mentions of rework/redo)
- Regression count
- Stub count in production code

### Handoff Health
- Handoff completeness (required fields present)
- Blockers encountered
- Decision traceability

## Options

```
Usage: collect-metrics.sh [OPTIONS]

  -d, --dir DIR       Planning directory (default: .planning)
  -f, --format FMT    Output: text, markdown, json (default: text)
  -o, --output FILE   Write to file (default: stdout)
  -h, --help          Show help
```

## Report Template

Use `report-template.md` for detailed reports with:
- Executive summary with trends
- Per-phase breakdown
- Agent-level performance
- Quality trend charts (text-based)
- Workflow health indicators
- Actionable recommendations

Replace `{PLACEHOLDERS}` with actual data from the collector.
