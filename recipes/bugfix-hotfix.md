# Recipe: Bugfix / Hotfix Fast-Track

**When to use:** Production bug or urgent regression. Time is critical, but you still need discipline.  
**GSD Tier:** Quick (≤3 files) or Hotfix (emergency patch).  
**Based on:** GSD v1.27 Fast Mode + GSD v1.28 forensics patterns.

---

## Triage First (5 min)

Before touching code, answer these 3 questions:

1. **Is it in production right now?** → Yes = Hotfix path. No = Normal bugfix branch.
2. **Do I know the root cause?** → No = Run `/gsd:forensics` first (see below).
3. **One file or many?** → 1 file ≤20 lines = Fast Mode. Multiple = Quick Mode.

---

## Path A: Hotfix (Production Emergency)

```
SYMPTOM REPORTED
     ↓
🔍 Reproduce locally (≤10 min budget)
     ↓
📋 Log in FORENSICS.md (root cause + impact scope)
     ↓
🌿 git checkout -b hotfix/<ticket-id>-<short-desc>
     ↓
🔧 Fix (minimal change — no refactoring)
     ↓
✅ Smoke test the exact failing scenario
     ↓
🚀 PR → merge → deploy → verify in production
     ↓
📝 Post-mortem: update FORENSICS.md + add regression test
```

### Hotfix Branch Rules
- Branch from `main`, NOT from a feature branch
- Commit message: `fix(hotfix): <what was broken and why>`
- PR description must include: **Root cause / Fix / How to verify / Regression risk**
- Merge same-day — escalate if blocked

---

## Path B: Regression / Non-Emergency Bug

```
BUG CONFIRMED
     ↓
🔬 Reproduce → write failing test (if testable layer)
     ↓
🌿 git checkout -b fix/<ticket-id>-<short-desc>
     ↓
📋 FORENSICS.md: root cause, affected versions, linked ticket
     ↓
🔧 Fix (stay minimal — no opportunistic refactoring)
     ↓
✅ Run relevant test suite
     ↓
👥 PR → review → merge
```

---

## Forensics Template (fast fill)

```markdown
## Bug: <title>

**Reported:** <datetime>
**Environment:** production / staging / local
**Severity:** P1 Critical / P2 High / P3 Medium

### Symptom
<What users see>

### Root Cause
<Why it happens — the actual line/logic/assumption that was wrong>

### Timeline
- HH:MM — symptom first observed
- HH:MM — root cause identified
- HH:MM — fix applied
- HH:MM — verified resolved

### Fix Summary
<One paragraph what was changed and why>

### Prevention
<What would have caught this earlier — test, type check, validation, alerting>
```

---

## Agent Delegation for Hotfixes

| Step | Agent | Instruction |
|------|-------|-------------|
| Reproduce | **QA (Elijah)** | "Reproduce bug X in environment Y, log exact steps" |
| Root Cause | **Backend/Frontend owner** | "Read FORENSICS.md → find root cause → propose minimal fix" |
| Fix | **Backend/Frontend owner** | "Apply fix in hotfix branch — no refactoring, minimal diff" |
| Verify | **QA (Elijah)** | "Smoke test against reported scenario — pass/fail only" |
| Deploy | **DevSecOps (Gideon)** | "Deploy hotfix branch to production, monitor 15 min" |

---

## ⚠️ Hotfix Anti-Patterns

| ❌ Don't | ✅ Do instead |
|----------|--------------|
| Refactor while fixing | Fix only — refactor in separate ticket |
| Push directly to `main` | Always hotfix branch → PR → merge |
| Skip root cause analysis | Always fill FORENSICS.md before shipping |
| Fix without regression test | Add a test covering the exact failure |
| Deploy without verification | Check the specific broken scenario in production |

---

## GSD Commands Reference

```bash
# Start forensics investigation
/gsd:forensics

# Fast mode for single-file fix
/gsd:fast

# Create clean PR branch after fix
/gsd:pr-branch
```

---

## Related Docs

- [`docs/execution-hardening.md`](../docs/execution-hardening.md) — Pre-wave dependency checks
- [`docs/verification-debt.md`](../docs/verification-debt.md) — Track untested scenarios
- [`docs/error-handling.md`](../docs/error-handling.md) — Resilient error patterns
- [`templates/FORENSICS.md`](../templates/FORENSICS.md) — Full forensics template
