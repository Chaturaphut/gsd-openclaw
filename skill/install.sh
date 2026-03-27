#!/bin/bash
# ─────────────────────────────────────────────────────────────
# GSD-OpenClaw Skill Installer
# Post-install script for ClawHub installation
# Copies workflow file to OpenClaw config directory
# ─────────────────────────────────────────────────────────────

set -euo pipefail

# ─── Colors ──────────────────────────────────────────────────
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# ─── Help ────────────────────────────────────────────────────
show_help() {
  cat << EOF
🚀 GSD-OpenClaw Skill Installer

Post-install script that sets up the GSD workflow in your OpenClaw workspace.

USAGE:
  $(basename "$0") [OPTIONS]

OPTIONS:
  --workspace DIR   OpenClaw workspace directory (default: ~/.openclaw/workspace)
  --config-dir DIR  Config directory name (default: gsd-openclaw)
  --skip-agents     Don't modify AGENTS.md
  -h, --help        Show this help message

WHAT IT DOES:
  1. Copies workflow file to config/gsd-openclaw/
  2. Copies templates to config/gsd-openclaw/templates/
  3. Makes tool scripts executable
  4. Optionally adds GSD reference to AGENTS.md
EOF
}

# ─── Args ────────────────────────────────────────────────────
WORKSPACE="${HOME}/.openclaw/workspace"
CONFIG_DIR="gsd-openclaw"
SKIP_AGENTS=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --workspace) WORKSPACE="$2"; shift 2 ;;
    --config-dir) CONFIG_DIR="$2"; shift 2 ;;
    --skip-agents) SKIP_AGENTS=true; shift ;;
    -h|--help) show_help; exit 0 ;;
    *) shift ;;
  esac
done

# ─── Determine source directory ──────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_ROOT="$(dirname "$SCRIPT_DIR")"

echo -e "${BLUE}🚀 Installing GSD-OpenClaw Skill${NC}"
echo -e "   Source: $SKILL_ROOT"
echo -e "   Target: $WORKSPACE/config/$CONFIG_DIR"
echo ""

# ─── Create config directory ─────────────────────────────────
CONFIG_PATH="$WORKSPACE/config/$CONFIG_DIR"
mkdir -p "$CONFIG_PATH"

# ─── Copy workflow file ──────────────────────────────────────
if [ -f "$SKILL_ROOT/workflow/gsd-workflow.md" ]; then
  cp "$SKILL_ROOT/workflow/gsd-workflow.md" "$CONFIG_PATH/"
  echo -e "${GREEN}✅ Workflow file copied${NC}"
else
  echo -e "${YELLOW}⚠️  workflow/gsd-workflow.md not found${NC}"
fi

# ─── Copy templates ──────────────────────────────────────────
if [ -d "$SKILL_ROOT/templates" ]; then
  mkdir -p "$CONFIG_PATH/templates"
  cp "$SKILL_ROOT/templates/"* "$CONFIG_PATH/templates/" 2>/dev/null || true
  echo -e "${GREEN}✅ Templates copied${NC}"
fi

# ─── Copy tools ──────────────────────────────────────────────
for tool_dir in tools/auto-plan tools/analytics tools/visualize; do
  if [ -d "$SKILL_ROOT/$tool_dir" ]; then
    mkdir -p "$CONFIG_PATH/$tool_dir"
    cp -r "$SKILL_ROOT/$tool_dir/"* "$CONFIG_PATH/$tool_dir/" 2>/dev/null || true
    # Make scripts executable
    find "$CONFIG_PATH/$tool_dir" -name "*.sh" -exec chmod +x {} \;
  fi
done
echo -e "${GREEN}✅ Tools copied${NC}"

# ─── Copy CI templates ──────────────────────────────────────
if [ -d "$SKILL_ROOT/ci-templates" ]; then
  mkdir -p "$CONFIG_PATH/ci-templates"
  cp "$SKILL_ROOT/ci-templates/"* "$CONFIG_PATH/ci-templates/" 2>/dev/null || true
  echo -e "${GREEN}✅ CI templates copied${NC}"
fi

# ─── Copy integrations ──────────────────────────────────────
if [ -d "$SKILL_ROOT/integrations" ]; then
  mkdir -p "$CONFIG_PATH/integrations"
  cp "$SKILL_ROOT/integrations/"* "$CONFIG_PATH/integrations/" 2>/dev/null || true
  find "$CONFIG_PATH/integrations" -name "*.sh" -exec chmod +x {} \;
  echo -e "${GREEN}✅ Integrations copied${NC}"
fi

# ─── Copy dashboard ─────────────────────────────────────────
if [ -d "$SKILL_ROOT/dashboard" ]; then
  mkdir -p "$CONFIG_PATH/dashboard"
  cp "$SKILL_ROOT/dashboard/"* "$CONFIG_PATH/dashboard/" 2>/dev/null || true
  find "$CONFIG_PATH/dashboard" -name "*.sh" -exec chmod +x {} \;
  echo -e "${GREEN}✅ Dashboard copied${NC}"
fi

# ─── Update AGENTS.md ────────────────────────────────────────
if [ "$SKIP_AGENTS" = false ]; then
  AGENTS_FILE="$WORKSPACE/AGENTS.md"
  GSD_MARKER="## GSD Workflow"
  
  if [ -f "$AGENTS_FILE" ]; then
    if ! grep -q "$GSD_MARKER" "$AGENTS_FILE" 2>/dev/null; then
      cat >> "$AGENTS_FILE" << AGENTS

## GSD Workflow
- Full doc: \`config/$CONFIG_DIR/workflow/gsd-workflow.md\`
- Every Dev task must follow: Spec → Research → Plan → Execute → QA
- Quick Mode: ≤3 files + no new API
- Fast Mode: 1 file, ≤20 lines change
- Tools: \`config/$CONFIG_DIR/tools/\`
- Dashboard: \`config/$CONFIG_DIR/dashboard/index.html\`
AGENTS
      echo -e "${GREEN}✅ AGENTS.md updated with GSD reference${NC}"
    else
      echo -e "${YELLOW}⏭️  AGENTS.md already has GSD section${NC}"
    fi
  else
    echo -e "${YELLOW}⚠️  AGENTS.md not found at $AGENTS_FILE${NC}"
  fi
fi

# ─── Done ────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}🎉 GSD-OpenClaw installed successfully!${NC}"
echo ""
echo "Next steps:"
echo "  1. Read the workflow: config/$CONFIG_DIR/workflow/gsd-workflow.md"
echo "  2. Start a project:  mkdir .planning && touch .planning/REQUIREMENTS.md"
echo "  3. View dashboard:   open config/$CONFIG_DIR/dashboard/index.html"
echo ""
