# 📋 Verification Debt Tracking (`/gsd:audit-uat`)

> **Adapted from:** GSD v1.27 `/gsd:audit-uat` command
> **Purpose:** Track what hasn't been tested yet — verification debt accumulates like tech debt.

---

## Overview

Verification debt is the gap between "what was built" and "what was verified." It's easy for agents to ship code without complete testing, especially under time pressure. This tool makes that gap visible.

---

## What Is Verification Debt?

```
Built:     12 API endpoints
Tested:    8 API endpoints (unit + integration)
UAT'd:     5 API endpoints (user acceptance tested)

Verification Debt:
  - 4 endpoints lack unit tests
  - 7 endpoints lack UAT verification
  - Debt Score: 58% (high risk)
```

---

## Audit Template

### VERIFICATION-DEBT.md

```markdown
# Verification Debt Audit

**Project:** [name]
**Date:** [ISO date]
**Auditor:** [agent/human]

## Summary
- **Total Features:** 24
- **Unit Tested:** 20 (83%)
- **Integration Tested:** 15 (63%)
- **UAT Verified:** 10 (42%)
- **Debt Score:** 42% coverage → HIGH RISK

## Debt Register

### 🔴 Critical (No Tests At All)
| Feature | Type | Risk | Owner |
|---------|------|------|-------|
| Password reset flow | API + UI | HIGH — security feature | backend-dev |
| Admin role escalation | API | HIGH — permission bypass possible | security-agent |

### 🟡 Warning (Partial Tests)
| Feature | Has Unit | Has Integration | Has UAT | Gap |
|---------|----------|----------------|---------|-----|
| User search | ✅ | ❌ | ❌ | Integration + UAT |
| File upload | ✅ | ✅ | ❌ | UAT |
| Dashboard charts | ✅ | ❌ | ❌ | Integration + UAT |

### ✅ Fully Verified
| Feature | Unit | Integration | UAT |
|---------|------|------------|-----|
| Login/Register | ✅ | ✅ | ✅ |
| JWT refresh | ✅ | ✅ | ✅ |
| User profile CRUD | ✅ | ✅ | ✅ |

## Debt Reduction Plan
1. **Immediate (this sprint):** Write tests for 🔴 Critical items
2. **Next sprint:** Add integration tests for 🟡 Warning items
3. **Ongoing:** UAT verification as part of each phase ship
```

---

## How to Run an Audit

### Manual Audit

The coordinator or QA agent performs the audit:

```
1. Read PLAN.md — list all features/tasks
2. Read QA-REPORT.md — what was tested
3. Check test files — what has unit/integration coverage
4. Check UAT records — what was user-verified
5. Calculate gaps
6. Generate VERIFICATION-DEBT.md
```

### Automated Audit Script

```bash
#!/bin/bash
# Scan for verification debt

echo "# Verification Debt Audit"
echo "Date: $(date -Iseconds)"
echo ""

# Count features from plan
FEATURES=$(grep -c "^## Task" .planning/phases/*/PLAN-*.md 2>/dev/null || echo 0)
echo "Total planned tasks: $FEATURES"

# Count test files
UNIT_TESTS=$(find . -name "*.test.*" -o -name "*.spec.*" | wc -l)
echo "Test files found: $UNIT_TESTS"

# Check for untested files
echo ""
echo "## Source files without corresponding tests:"
for src in $(find src -name "*.ts" -not -name "*.test.*" -not -name "*.spec.*" -not -path "*/types/*"); do
  test_file="${src%.ts}.test.ts"
  spec_file="${src%.ts}.spec.ts"
  if [ ! -f "$test_file" ] && [ ! -f "$spec_file" ]; then
    echo "  ❌ $src"
  fi
done
```

---

## Integration with QA Workflow

After every QA phase, update the debt register:

```
QA Phase Complete:
  → Update VERIFICATION-DEBT.md
  → Report debt score to coordinator
  → If debt score > 60% → FLAG as high risk
  → If debt score > 80% → BLOCK shipping until reduced
```

---

## Configuration

```json
// .planning/config.json
{
  "workflow": {
    "verificationDebt": {
      "enabled": true,
      "blockShipAbove": 80,
      "warnAbove": 50,
      "trackUAT": true,
      "auditOnShip": true
    }
  }
}
```

---

## Related

- [QA Standards](qa-standards.md) — QA report feeds debt tracking
- [Ship Workflow](ship-workflow.md) — Debt score gates shipping
- [Agent Profiling](agent-profiling.md) — Track which agents produce more debt
