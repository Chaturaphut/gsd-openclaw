# 🚀 GSD-OpenClaw Skill Package

Install GSD-OpenClaw as an OpenClaw skill for automatic workflow integration.

## Install via ClawHub

```bash
clawhub install gsd-openclaw
```

This will:
1. Download the skill to your OpenClaw workspace
2. Copy the workflow file to `config/gsd-openclaw/`
3. Copy all tools, templates, and dashboard
4. Add GSD reference to your AGENTS.md

## Manual Install

```bash
# Clone the repo
cd ~/.openclaw/workspace
git clone https://github.com/Chaturaphut/gsd-openclaw.git config/gsd-openclaw

# Run the installer
./config/gsd-openclaw/skill/install.sh
```

## What Gets Installed

```
config/gsd-openclaw/
├── workflow/
│   └── gsd-workflow.md          # Core workflow specification
├── templates/                    # Planning templates
├── tools/
│   ├── auto-plan/               # Plan generation
│   ├── analytics/               # Performance metrics
│   └── visualize/               # Mermaid diagrams + terminal dashboard
├── ci-templates/                 # GitHub Actions + GitLab CI
├── integrations/                 # Issue tracker sync
└── dashboard/                    # Web dashboard
```

## After Installation

Your agents will automatically follow the GSD workflow:

1. **New task?** → Check task sizing (Fast/Quick/Full)
2. **Full GSD?** → Requirements → Research → Plan → Execute → QA
3. **Quality gates** → Stub detection, regression testing, plan coverage
4. **Handoffs** → HANDOFF.json between agent sessions

## Verify Installation

```bash
# Check the workflow file exists
cat ~/.openclaw/workspace/config/gsd-openclaw/workflow/gsd-workflow.md | head -5

# Check tools are executable
ls -la ~/.openclaw/workspace/config/gsd-openclaw/tools/*/

# Check AGENTS.md has GSD section
grep "GSD Workflow" ~/.openclaw/workspace/AGENTS.md
```

## Uninstall

```bash
# Remove the skill
rm -rf ~/.openclaw/workspace/config/gsd-openclaw

# Remove GSD section from AGENTS.md (manual)
# Edit AGENTS.md and remove the "## GSD Workflow" section
```

## Skill Metadata

| Field | Value |
|-------|-------|
| Name | gsd-openclaw |
| Version | 1.5.0 |
| Author | Chaturaphut |
| License | MIT |
| Category | Development |
| Tags | workflow, gsd, multi-agent, planning, qa |
