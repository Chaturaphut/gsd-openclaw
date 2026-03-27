# 📋 Verification Debt Auditor

Scans your project for untested source files, stubs in production code, and generates a verification debt report.

## Usage

```bash
# Audit current project
./tools/audit-uat/audit-verification.sh /path/to/project

# Audit and save report
./tools/audit-uat/audit-verification.sh /path/to/project > VERIFICATION-DEBT.md
```

## What It Checks

1. **Test Coverage** — Source files that have corresponding test files
2. **Stub Detection** — TODO/FIXME/HACK/PLACEHOLDER in production code
3. **Risk Scoring** — Overall verification debt risk level

## Risk Levels

| Coverage | Risk |
|----------|------|
| ≥ 80% | LOW |
| 50-79% | MEDIUM |
| < 50% | HIGH |
| < 20% | CRITICAL — blocks shipping |

## Integration

Add to your QA or ship workflow:

```bash
# Run audit before shipping
./tools/audit-uat/audit-verification.sh . > .planning/VERIFICATION-DEBT.md

# Check if shipping should be blocked
COVERAGE=$(./tools/audit-uat/audit-verification.sh . | grep "Risk Level" | awk '{print $NF}')
if [ "$COVERAGE" = "CRITICAL" ]; then
  echo "❌ Cannot ship — verification debt too high"
  exit 1
fi
```
