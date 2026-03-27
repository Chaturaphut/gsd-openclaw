#!/bin/bash
# GSD Temp File Reaper
# Cleans up temporary and debug files before shipping
# Usage: ./tools/temp-reaper/reap.sh [project-root] [--dry-run]

set -euo pipefail

PROJECT_ROOT="${1:-.}"
DRY_RUN=false

if [[ "${2:-}" == "--dry-run" ]]; then
  DRY_RUN=true
fi

# Default patterns to clean
PATTERNS=(
  "*.tmp"
  "*.bak"
  "*.orig"
  "*.swp"
  "*.swo"
  "debug-*"
  "*.log"
  ".DS_Store"
  "Thumbs.db"
)

# Directories to clean
CLEAN_DIRS=(
  ".planning/scratch"
  "tmp"
  ".tmp"
)

echo "🧹 GSD Temp File Reaper"
echo "   Project: $PROJECT_ROOT"
echo "   Mode: $([ "$DRY_RUN" = true ] && echo 'DRY RUN' || echo 'LIVE')"
echo ""

TOTAL=0

# Clean file patterns
for pattern in "${PATTERNS[@]}"; do
  while IFS= read -r -d '' file; do
    TOTAL=$((TOTAL + 1))
    if [ "$DRY_RUN" = true ]; then
      echo "  Would remove: $file"
    else
      rm -f "$file"
      echo "  Removed: $file"
    fi
  done < <(find "$PROJECT_ROOT" -name "$pattern" -not -path "*/.git/*" -not -path "*/node_modules/*" -print0 2>/dev/null)
done

# Clean directories
for dir in "${CLEAN_DIRS[@]}"; do
  target="$PROJECT_ROOT/$dir"
  if [ -d "$target" ]; then
    count=$(find "$target" -type f 2>/dev/null | wc -l)
    if [ "$count" -gt 0 ]; then
      TOTAL=$((TOTAL + count))
      if [ "$DRY_RUN" = true ]; then
        echo "  Would clean directory: $target ($count files)"
      else
        rm -rf "$target"/*
        echo "  Cleaned directory: $target ($count files)"
      fi
    fi
  fi
done

# Remove console.log DEBUG statements
DEBUG_COUNT=0
while IFS= read -r file; do
  if grep -q "console\.log.*DEBUG\|console\.log.*debug\|// DEBUG" "$file" 2>/dev/null; then
    DEBUG_COUNT=$((DEBUG_COUNT + 1))
    if [ "$DRY_RUN" = true ]; then
      echo "  Would clean debug statements: $file"
    else
      sed -i '/console\.log.*DEBUG/d;/console\.log.*debug/d;/\/\/ DEBUG/d' "$file"
      echo "  Cleaned debug statements: $file"
    fi
  fi
done < <(find "$PROJECT_ROOT/src" -name "*.ts" -o -name "*.js" -o -name "*.tsx" -o -name "*.jsx" 2>/dev/null)

echo ""
echo "Summary: $TOTAL temp files, $DEBUG_COUNT files with debug statements"
if [ "$DRY_RUN" = true ]; then
  echo "Run without --dry-run to actually clean up."
fi
