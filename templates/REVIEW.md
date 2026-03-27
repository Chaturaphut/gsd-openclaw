# Peer Review: [Phase/Task Name]

**Reviewer:** [agent/model name]
**Author:** [original agent/model]
**Date:** [YYYY-MM-DD]
**Verdict:** [PASS / CHANGES REQUESTED]

---

## Review Scope

- **Plan:** [reference to PLAN.md]
- **Files Reviewed:** [list of files]
- **Review Focus:** [correctness / security / performance / all]

---

## Findings

### 🔴 Critical (Must Fix Before QA)

1. **[Issue Title]**
   - **File:** `[file:line]`
   - **Issue:** [description]
   - **Fix:** [suggested fix]

### 🟡 Warning (Should Fix)

1. **[Issue Title]**
   - **File:** `[file:line]`
   - **Issue:** [description]
   - **Fix:** [suggested fix]

### 🔵 Info (Nice to Have)

1. **[Issue Title]**
   - **File:** `[file:line]`
   - **Issue:** [description]
   - **Fix:** [suggested fix]

---

## Summary

| Severity | Count |
|----------|-------|
| 🔴 Critical | [N] |
| 🟡 Warning | [N] |
| 🔵 Info | [N] |

---

## Checklist

### Correctness
- [ ] Code matches PLAN.md specifications
- [ ] All "Done When" criteria met
- [ ] Edge cases handled

### Security
- [ ] No hardcoded credentials
- [ ] Input validation present
- [ ] No injection vulnerabilities

### Quality
- [ ] No TODO/FIXME in production code
- [ ] Consistent naming conventions
- [ ] No dead code

### Contracts
- [ ] API schemas match data contracts
- [ ] Field names consistent with plan

---

<!--
Guidelines:
- Use a DIFFERENT model from the author when possible
- Focus on what the author might have missed
- Be specific — file:line + suggested fix
- PASS = proceed to QA; CHANGES REQUESTED = back to author
-->
