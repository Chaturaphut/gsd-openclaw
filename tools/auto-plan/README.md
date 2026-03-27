# 📐 Auto-Plan Generation

Generate structured PLAN.md files from your REQUIREMENTS.md and RESEARCH.md.

## Files

| File | Description |
|------|-------------|
| `generate-plan.sh` | Script to generate draft PLAN.md |
| `prompt-template.md` | AI prompt template for plan generation |
| `validation-checklist.md` | Checklist to verify plan quality |

## Quick Start

### Generate a draft plan

```bash
# From your project root (with .planning/ directory)
./tools/auto-plan/generate-plan.sh

# Output: .planning/PLAN-draft.md
```

### Generate for a specific phase

```bash
./tools/auto-plan/generate-plan.sh --phase phases/phase-2-frontend

# Output: .planning/phases/phase-2-frontend/PLAN-01.md
```

### Get AI prompt for manual use

```bash
# Output a ready-to-paste prompt for ChatGPT/Claude/etc.
./tools/auto-plan/generate-plan.sh --prompt-only
```

### Specify output file

```bash
./tools/auto-plan/generate-plan.sh --output .planning/phases/phase-1/PLAN-01.md
```

## How It Works

```
REQUIREMENTS.md  ──→  ┌─────────────────┐
                       │  generate-plan   │──→  PLAN-draft.md
RESEARCH.md      ──→  │    .sh           │
                       └─────────────────┘
                              │
                              ▼
                    validation-checklist.md
                    (manual review step)
```

1. **Reads** REQUIREMENTS.md for open requirements (unchecked items)
2. **Reads** RESEARCH.md for context (if available)
3. **Generates** a draft PLAN.md with:
   - Wave-based task grouping
   - Task stubs for each requirement
   - Requirements coverage table
   - Acceptance criteria from requirements
4. **You review** and fill in implementation details

## Important Notes

⚠️ The generated plan is a **draft** — it creates the structure but you must:

1. **Fill in file paths** — Replace `[specify exact file paths]`
2. **Write implementation steps** — Add specific action steps
3. **Define verification** — How to test each task
4. **Set acceptance criteria** — Measurable "done" conditions
5. **Validate** — Use the validation checklist

The draft saves time on structure; the human/AI review ensures quality.

## Validation

After editing the draft:

```bash
# Quick structural check
PLAN=".planning/PLAN-draft.md"
echo "Tasks: $(grep -c '^### Task' "$PLAN")"
echo "Incomplete: $(grep -c '\[specify\|TBD\|TODO' "$PLAN")"
echo "Unmapped: $(grep -c 'Unmapped' "$PLAN")"
```

See `validation-checklist.md` for the full review checklist.

## Options

```
Usage: generate-plan.sh [OPTIONS]

  -d, --dir DIR       Planning directory (default: .planning)
  -p, --phase DIR     Phase directory (e.g., phases/phase-1)
  -o, --output FILE   Output file path
  -n, --name NAME     Project name
  --prompt-only       Output AI prompt instead of plan
  -h, --help          Show help
```
