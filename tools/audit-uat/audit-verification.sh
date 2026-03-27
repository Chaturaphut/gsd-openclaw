#!/bin/bash
# GSD Verification Debt Auditor
# Scans a project for untested features and generates a debt report
# Usage: ./tools/audit-uat/audit-verification.sh [project-root]

set -euo pipefail

PROJECT_ROOT="${1:-.}"
SRC_DIR="$PROJECT_ROOT/src"
TEST_DIRS=("$PROJECT_ROOT/tests" "$PROJECT_ROOT/test" "$PROJECT_ROOT/__tests__" "$SRC_DIR")

echo "# Verification Debt Audit"
echo ""
echo "**Project:** $(basename "$PROJECT_ROOT")"
echo "**Date:** $(date -Iseconds)"
echo ""

# Count source files
SRC_COUNT=0
TESTED_COUNT=0
UNTESTED_FILES=()

if [ -d "$SRC_DIR" ]; then
  while IFS= read -r src; do
    SRC_COUNT=$((SRC_COUNT + 1))
    base=$(basename "$src" | sed 's/\.[^.]*$//')
    found=false
    
    for test_dir in "${TEST_DIRS[@]}"; do
      if find "$test_dir" \( -name "${base}.test.*" -o -name "${base}.spec.*" -o -name "test_${base}.*" \) 2>/dev/null | grep -q .; then
        found=true
        break
      fi
    done
    
    if [ "$found" = true ]; then
      TESTED_COUNT=$((TESTED_COUNT + 1))
    else
      UNTESTED_FILES+=("$src")
    fi
  done < <(find "$SRC_DIR" \
    -name "*.ts" -o -name "*.js" -o -name "*.tsx" -o -name "*.jsx" -o -name "*.py" \
    | grep -v ".test\." | grep -v ".spec\." | grep -v "__test" | grep -v "node_modules" \
    | sort)
fi

# Count test files
TEST_COUNT=0
for test_dir in "${TEST_DIRS[@]}"; do
  if [ -d "$test_dir" ]; then
    count=$(find "$test_dir" \( -name "*.test.*" -o -name "*.spec.*" \) 2>/dev/null | wc -l)
    TEST_COUNT=$((TEST_COUNT + count))
  fi
done

# Calculate coverage
if [ "$SRC_COUNT" -gt 0 ]; then
  COVERAGE=$((TESTED_COUNT * 100 / SRC_COUNT))
else
  COVERAGE=0
fi

# Determine risk level
if [ "$COVERAGE" -ge 80 ]; then
  RISK="LOW"
elif [ "$COVERAGE" -ge 50 ]; then
  RISK="MEDIUM"
else
  RISK="HIGH"
fi

echo "## Summary"
echo ""
echo "- **Source Files:** $SRC_COUNT"
echo "- **Test Files:** $TEST_COUNT"
echo "- **Files with Tests:** $TESTED_COUNT ($COVERAGE%)"
echo "- **Files without Tests:** ${#UNTESTED_FILES[@]}"
echo "- **Risk Level:** $RISK"
echo ""

# Check .planning/ for planned features
PLANNED=0
if [ -d "$PROJECT_ROOT/.planning" ]; then
  PLANNED=$(grep -rh "^## Task\|^### Task" "$PROJECT_ROOT/.planning/" 2>/dev/null | wc -l)
  echo "- **Planned Tasks:** $PLANNED"
  echo ""
fi

# List untested files
if [ ${#UNTESTED_FILES[@]} -gt 0 ]; then
  echo "## 🔴 Files Without Tests"
  echo ""
  for file in "${UNTESTED_FILES[@]}"; do
    echo "- \`$file\`"
  done
  echo ""
fi

# Check for stubs in production code
echo "## 🟡 Stubs in Production Code"
echo ""
STUB_COUNT=0
if [ -d "$SRC_DIR" ]; then
  while IFS= read -r line; do
    if [ -n "$line" ]; then
      STUB_COUNT=$((STUB_COUNT + 1))
      echo "- $line"
    fi
  done < <(grep -rn "TODO\|FIXME\|HACK\|PLACEHOLDER\|Not implemented\|// stub" "$SRC_DIR" 2>/dev/null | head -20)
fi

if [ "$STUB_COUNT" -eq 0 ]; then
  echo "None found ✅"
fi

echo ""
echo "---"
echo ""
echo "**Debt Score:** $((100 - COVERAGE))% untested → $RISK RISK"
if [ "$COVERAGE" -lt 50 ]; then
  echo "⚠️ **WARNING:** Coverage below 50% — consider blocking ship until improved."
fi
if [ "$COVERAGE" -lt 20 ]; then
  echo "🚫 **CRITICAL:** Coverage below 20% — DO NOT ship without adding tests."
fi
