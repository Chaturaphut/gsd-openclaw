# Forensics Guide — Post-Mortem Workflow Investigation

> Cherry-picked from GSD v1.28.0 — Adapted for OpenClaw multi-agent workflows

## Overview

`/gsd:forensics` is a structured post-mortem investigation workflow for debugging complex failures that span multiple agents, phases, or sessions. When a build breaks, a deployment goes wrong, or a multi-agent workflow produces unexpected output, forensics gives you a systematic way to trace root cause.

---

## When to Use Forensics

| Situation | Use Forensics? |
|-----------|---------------|
| Bug report from QA after execute-phase | ✅ Yes |
| Production incident (rollback needed) | ✅ Yes |
| Agent produced unexpected output | ✅ Yes |
| Simple syntax error / typo | ❌ No — just fix it |
| Known issue with obvious fix | ❌ No |

**Rule of thumb:** If you've spent >15 minutes debugging without a clear lead, trigger forensics.

---

## OpenClaw Multi-Agent Forensics Flow

```
CEO/MumuX
  └─ spawn Obadiah (Pentest/Forensics) or Elijah (QA)
       └─ investigate with structured FORENSICS.md output
            └─ findings → spawn fix agent (Moses/David/Ezra)
                 └─ fix → Elijah verifies → MR
```

### Step 1: Trigger Investigation

```
/gsd:forensics
```

Or explicitly in an agent prompt:
```
Run forensics on the failure in [phase/feature/incident].
Generate FORENSICS.md with full investigation trail.
```

### Step 2: FORENSICS.md Structure

The forensics agent produces a structured artifact at `.planning/FORENSICS.md`:

```markdown
# FORENSICS: [Incident Title]
**Date:** YYYY-MM-DD
**Reported by:** [Agent/Human]
**Severity:** Critical / High / Medium

## Timeline
- HH:MM — Event description
- HH:MM — What agent did
- HH:MM — Failure point

## Symptoms
- What was observed
- What was expected

## Root Cause Analysis
### Primary Cause
[Exact cause with file/line reference]

### Contributing Factors
1. Factor A — why it wasn't caught earlier
2. Factor B — compounding issue

## Evidence
- `path/to/file.ts:42` — relevant code
- Error log excerpt
- API response that triggered failure

## Impact Assessment
- Affected components: [list]
- Data integrity: [ok / compromised]
- Agents impacted: [list]

## Fix Plan
1. Immediate: [what to do now]
2. Short-term: [prevent recurrence]
3. Long-term: [systemic improvement]

## Lessons Learned
- What the workflow should do differently
- What guardrails to add
```

---

## Agent Delegation for Forensics

| Failure Type | Lead Agent | Support |
|-------------|-----------|---------|
| Production crash / server | **Ezra** (SysAdmin) | Samuel (NOC) |
| API / backend bug | **Moses** (Backend) | Elijah (QA) |
| Frontend / UI issue | **David** (Frontend) | Elijah (QA) |
| Security incident | **Obadiah** (Pentest) | Michael (Security) |
| Database corruption | **Levi** (DBA) | Moses (Backend) |
| AI/ML model behavior | **Isaiah** (AI/ML) | Beam |
| Deployment failure | **Gideon** (DevSecOps) | Ezra |

**MumuX Role:** Receive FORENSICS.md → assign fix agent → monitor resolution → report to CEO

---

## OpenClaw Spawn Pattern

```
spawn Obadiah:
  task: |
    Investigate failure: [describe incident]
    
    Context:
    - Phase: execute-phase for [feature]
    - When it broke: [timestamp]
    - Error: [paste error]
    
    Output: FORENSICS.md at .planning/FORENSICS.md
    Include: timeline, root cause, fix plan
    Format: follow docs/forensics-guide.md structure
```

---

## Debug Knowledge Base Integration

GSD v1.24.0+ introduced **persistent debug knowledge base** at `.planning/debug/knowledge-base.md`. After each forensics session, append resolved findings:

```markdown
## [YYYY-MM-DD] [Issue Title]
**Root Cause:** Short description
**Fix:** What was done
**Pattern:** Type of failure (config / race-condition / type-error / etc.)
**Prevention:** Guardrail added
```

This eliminates cold-start investigation when similar issues recur.

---

## Integration with Other Commands

```
/gsd:forensics          → Investigate current failure
/gsd:review             → Peer review before shipping  
/gsd:verify-work        → Structured verification
/gsd:audit-uat          → Track verification debt
```

---

## Anti-Patterns

❌ **"Just fix it" without investigation** — Root cause unknown → same bug recurs  
❌ **Forensics without FORENSICS.md** — Knowledge lost after session  
❌ **Multiple agents investigating in parallel** — Conflicting findings, wasted effort  
❌ **Skip lessons-learned section** — Team doesn't learn, pattern repeats  

---

## Quick Checklist

```
[ ] Trigger /gsd:forensics or spawn forensics agent
[ ] Timeline reconstructed (who did what, when)
[ ] Root cause identified (not just symptoms)
[ ] Evidence documented (file:line references)
[ ] Fix plan has 3 levels: immediate / short-term / systemic
[ ] Findings appended to .planning/debug/knowledge-base.md
[ ] CEO notified if severity = Critical or High
```

---

*Cherry-picked from GSD v1.28.0 — /gsd:forensics command*  
*Adapted for Ruk-Com OpenClaw multi-agent team by MumuX*
