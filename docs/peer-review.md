# 🔍 Cross-AI Peer Review (`/gsd:review`)

> **Adapted from:** GSD v1.27 `/gsd:review` command
> **Purpose:** Have a different AI agent review code produced by another agent — catch blind spots.

---

## Overview

When one agent writes code, it has inherent blind spots — patterns it favors, edge cases it overlooks, assumptions it makes. Cross-AI Peer Review spawns a **separate agent** (ideally a different model) to review the work before QA.

---

## Why Peer Review?

| Without Peer Review | With Peer Review |
|---------------------|------------------|
| Author agent reviews own code | Fresh eyes catch blind spots |
| Same model = same blind spots | Different model = different perspective |
| QA catches issues late | Issues caught before QA |
| 1 pass of analysis | 2 passes of analysis |

---

## When to Use

- ✅ After execution, before QA (always recommended for Full GSD)
- ✅ For security-sensitive code
- ✅ For complex architecture decisions
- ✅ When the executing agent's profile shows low first-pass rate
- ❌ Skip for Fast Mode changes
- ❌ Skip for trivial Quick Mode tasks

---

## Review Workflow

```
1. Dev Agent completes task → creates SUMMARY.md
2. Coordinator spawns Review Agent (different model if possible)
3. Review Agent reads:
   - PLAN.md (what was supposed to be built)
   - SUMMARY.md (what was built)
   - Modified files (actual code)
   - Data contracts (schema expectations)
4. Review Agent produces REVIEW.md
5. If issues found → Dev Agent fixes before QA
6. If clean → Proceed to QA
```

---

## Review Agent Instructions

```markdown
## Peer Review Task

You are reviewing code written by another agent. Your job is to find issues
the original agent missed. You did NOT write this code.

### Review Checklist

#### Correctness
- [ ] Code matches PLAN.md specifications exactly
- [ ] All "Done When" criteria are verifiably met
- [ ] Edge cases from RESEARCH.md are handled
- [ ] Error handling covers failure modes

#### Security
- [ ] No hardcoded credentials or secrets
- [ ] Input validation on all user-facing endpoints
- [ ] SQL injection prevention (parameterized queries)
- [ ] XSS prevention (output encoding)
- [ ] Authentication/authorization checks present

#### Quality
- [ ] No TODO/FIXME/HACK in production code
- [ ] No dead code or unused imports
- [ ] Naming conventions consistent with project
- [ ] No magic numbers — constants with descriptive names
- [ ] Error messages are user-friendly

#### Contracts
- [ ] API response format matches data contract
- [ ] Database schema matches ORM models
- [ ] Field names consistent with PLAN.md specifications
- [ ] Types match between producer and consumer

### Output Format
Produce REVIEW.md with:
1. **PASS** or **CHANGES REQUESTED**
2. List of findings (if any) with severity: 🔴 Critical / 🟡 Warning / 🔵 Info
3. Suggested fixes for each finding
```

---

## REVIEW.md Template

```markdown
# Peer Review: [Phase/Task Name]

**Reviewer:** [agent/model]
**Date:** [ISO date]
**Verdict:** CHANGES REQUESTED

## Findings

### 🔴 Critical

1. **SQL Injection in search endpoint**
   - File: `src/api/search.ts:45`
   - Issue: String interpolation in SQL query
   - Fix: Use parameterized query `db.query('SELECT * FROM users WHERE name = $1', [name])`

### 🟡 Warning

2. **Missing rate limiting on login endpoint**
   - File: `src/api/auth.ts`
   - Issue: No rate limiting — vulnerable to brute force
   - Fix: Add rate limiter middleware (see RESEARCH.md recommendation)

### 🔵 Info

3. **Inconsistent error format**
   - File: `src/api/auth.ts:67`
   - Issue: Returns `{ error: "..." }` but other endpoints use `{ message: "..." }`
   - Fix: Standardize to `{ error: { code: "...", message: "..." } }`

## Summary
- 🔴 Critical: 1 (must fix before QA)
- 🟡 Warning: 1 (should fix)
- 🔵 Info: 1 (nice to have)
```

---

## Model Diversity Strategy

For best results, use a different model for review than execution:

```
Execution Model:     claude-sonnet-4-20250514 (fast, good at coding)
Review Model:        gemini-2.5-pro (different perspective, strong at logic)

Alternative:
Execution Model:     gemini-2.5-pro
Review Model:        claude-sonnet-4-20250514
```

The goal is **cognitive diversity** — different models have different strengths and blind spots.

---

## Configuration

```json
// .planning/config.json
{
  "workflow": {
    "peerReview": {
      "enabled": true,
      "requiredFor": ["full"],
      "optionalFor": ["quick"],
      "skipFor": ["fast"],
      "preferDifferentModel": true,
      "reviewModel": "gemini-2.5-pro"
    }
  }
}
```

---

## Related

- [Agent Profiling](agent-profiling.md) — Profile data informs when review is critical
- [QA Standards](qa-standards.md) — QA after review catches remaining issues
- [Secure Coding](secure-coding.md) — Security review checklist
