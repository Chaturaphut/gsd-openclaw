# QA Report Template

## 📊 QA Report: [Feature Name]
**QA Engineer:** [Name] | **Date:** [Date] | **Build:** [Version]

---

### 1. 📋 Summary
**Feature:** [Brief description]
**Overall:** [PASS / CONDITIONAL PASS / FAIL]

### 2. 🖱️ UI Clickthrough
- [ ] Every button has a real action
- [ ] Every dropdown opens and selects correctly
- [ ] Every tab switches content
- [ ] Every link navigates correctly
- [ ] Every modal opens and closes
- [ ] Every form submits successfully
- [ ] UI values match API responses

### 3. 📱 Responsive
- [ ] Desktop 1920x1080 — Layout OK
- [ ] Desktop 1366x768 — Layout OK
- [ ] Mobile 390x844 — No overflow, touch targets ≥44px
- [ ] Mobile 360x800 — No overflow

### 4. 🔴 Console & Network
- [ ] No red console errors
- [ ] No undefined/null/NaN on UI
- [ ] No broken images
- [ ] No mixed content warnings
- [ ] API responses return expected status codes

### 5. 🔄 CRUD Full Cycle
- [ ] Create → Read → Update → Delete → Refresh
- [ ] Empty values handled
- [ ] Long values handled
- [ ] Special characters / XSS handled
- [ ] Duplicate submit prevented

### 6. 🔐 Permission & Auth
- [ ] No auth → 401
- [ ] Invalid token → 401
- [ ] No permission → 403
- [ ] IDOR check — can't access other users' data

### 7. 🛡️ Security
- [ ] Input validation (client + server)
- [ ] SQL/NoSQL injection tested
- [ ] XSS prevention verified
- [ ] Rate limiting in place
- [ ] Error messages don't leak internals

### 8. 🌊 User Flows
- [ ] Happy path complete
- [ ] Back button works
- [ ] F5 refresh preserves state
- [ ] Deep link works
- [ ] Logout → Login flow works

### 9. 🔄 Regression
- [ ] Previous phase tests still pass
- [ ] No stub/TODO/FIXME in production code

### 10. 🐛 Bugs Found
| # | Severity | Title | Root Cause | Suggested Fix |
|---|----------|-------|------------|---------------|
| 1 | 🔴 Critical / 🟡 Medium / 🟢 Low | [Title] | [Cause] | [Fix] |

### ✅ Verdict
**[PASS / CONDITIONAL PASS / FAIL]**
- Conditions for pass: [if conditional]
