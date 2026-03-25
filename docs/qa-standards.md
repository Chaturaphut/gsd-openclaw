# 🧪 QA Standards for AI Agent Teams

> **Rule:** No feature ships without passing ALL 10 QA sections. No exceptions.

AI agents are great at writing code. They're terrible at testing it honestly. An AI dev agent will say "everything works" after running one happy-path test. This QA framework ensures every feature is battle-tested before it reaches production.

---

## The QA Loop

```
Dev Agent completes work
        ↓
Auto-spawn QA Agent (immediately — no human trigger needed)
        ↓
QA runs full 10-section checklist
        ↓
    ┌─ PASS → Report to stakeholder → Ship it 🚀
    │
    └─ FAIL → Bug list back to Dev Agent
                    ↓
              Dev fixes bugs
                    ↓
              Re-spawn QA Agent (loop until PASS)
```

### Critical Rules
- ⚠️ **NEVER report to stakeholders before QA passes** — Only present verified work
- 🔄 **Dev → QA loop runs automatically** — No human intervention needed for the cycle
- 🚫 **QA agent ≠ Dev agent** — Different agent, fresh perspective, no bias
- 🧪 **QA must use a test account** — Never use admin/CEO/production accounts for testing

---

## The 10-Section QA Report

Every QA report MUST include all 10 sections. Missing a section = incomplete QA = redo.

### 1. 📋 Summary
```markdown
**Feature:** [Brief description]
**QA Engineer:** [Agent name]
**Date:** [Date] | **Build:** [Version]
**Overall Verdict:** PASS / CONDITIONAL PASS / FAIL
```

### 2. 🖱️ UI Clickthrough

Test EVERY interactive element on the page:

| Element | Test | Pass Criteria |
|---------|------|--------------|
| Every button | Click it | Has a real action (not a dead button) |
| Every dropdown | Open + select | Options load, selection works |
| Every tab | Click each | Content changes correctly |
| Every link | Click it | Navigates to correct page |
| Every modal trigger | Click it | Modal opens AND closes properly |
| Every form | Fill + submit | Submission works, validation fires |
| Empty state | No data scenario | Shows helpful message, not blank page |
| Error state | API error scenario | Shows error message, not broken page |
| Loading state | During data fetch | Shows spinner/skeleton, not flash |

> 💀 **Dead button rule:** A button that looks clickable but does nothing = **CRITICAL BUG**. If it's not ready, it must show "Coming Soon" and be disabled.

### 3. 📱 Responsive Testing

Test on ALL four viewport sizes:

| Device | Size | Check |
|--------|------|-------|
| Desktop Large | 1920×1080 | Full layout |
| Desktop Small | 1366×768 | No overflow |
| Mobile iPhone | 390×844 | Touch targets ≥44px |
| Mobile Android | 360×800 | No horizontal scroll |

**Responsive failures = BUG:**
- Layout breaks or overflows
- Text gets cut off
- Buttons too small to tap (< 44px)
- Modal extends beyond screen
- Horizontal scrollbar appears

### 4. 🔴 Console & Network Errors

Open browser DevTools and check:

- [ ] No red console errors
- [ ] No `undefined`, `null`, `NaN`, or `[object Object]` displayed on UI
- [ ] No broken images (404 on image URLs)
- [ ] No mixed content warnings (HTTP resources on HTTPS page)
- [ ] API calls return expected status codes (not 500s)

### 5. 🔄 CRUD Full Cycle

For every data entity, test the complete lifecycle:

```
Create → Read (verify) → Update → Read (verify) → Delete → Read (verify gone) → Refresh
```

**Edge cases (mandatory):**
| Input | Expected Behavior |
|-------|------------------|
| Empty value | Validation error, not crash |
| Very long string (1000+ chars) | Truncate or scroll, not break layout |
| Special characters (`<script>`, `'; DROP TABLE`, `../../../etc/passwd`) | Sanitized, not executed |
| Negative numbers / zero | Handled gracefully |
| Duplicate rapid submit | Prevented (disabled button or debounce) |

### 6. 🔐 Permission & Auth Testing

| Scenario | Expected |
|----------|----------|
| No auth token | 401 Unauthorized |
| Expired token | Redirect to login |
| Fake/invalid token | 401 rejection |
| Valid token, no permission | 403 Forbidden |
| IDOR (access other user's data) | 403 or 404, NOT the data |

### 7. 🛡️ Security Testing

| Category | Test |
|----------|------|
| SQL/NoSQL injection | `' OR 1=1 --`, `{$gt: ""}` in inputs |
| XSS | `<script>alert(1)</script>` in all text fields |
| Auth bypass | Access protected routes without token |
| Brute force | Rate limiting on login/sensitive endpoints |
| Data exposure | API doesn't return passwords/tokens/internal IDs unnecessarily |
| Error disclosure | Error messages don't reveal stack traces or internal paths |
| CORS | Only whitelisted origins allowed |
| Security headers | X-Frame-Options, CSP, HSTS present |
| Dependencies | `npm audit` / `pip audit` passes |
| Token storage | JWT in httpOnly cookie, not localStorage |

### 8. 🌊 User Flow Testing

| Flow | Test |
|------|------|
| Happy path | Complete the main use case end-to-end |
| Back button | Navigate back — state preserved correctly |
| F5 Refresh | Refresh page — data reloads, no errors |
| Deep link | Direct URL access — page loads correctly |
| Logout → Login | Session clears, fresh login works |
| Multi-tab | Same page in 2 tabs — no conflicts |
| Slow network | Throttle to 3G — loading states appear, no timeouts |

### 9. 🔄 Regression Testing

After completing a new phase, run previous phases' test suites:

```
Phase 3 done → Run Phase 1 tests → Run Phase 2 tests → Run Phase 3 tests
All pass = ✅ PASS
Any fail = ❌ REGRESSION — fix before shipping
```

Also scan for stubs:
```bash
grep -rn "TODO\|FIXME\|HACK\|PLACEHOLDER\|Not implemented\|// stub" src/
# Found in production code = BUG
# Exception: Comments tagged "FUTURE:" are acceptable
```

### 10. ✅ Final Verdict

| Verdict | Meaning |
|---------|---------|
| ✅ **PASS** | All sections pass, ready to ship |
| 🟡 **CONDITIONAL PASS** | Minor issues listed, fix and ship (no re-QA needed) |
| ❌ **FAIL** | Critical bugs found, must fix and re-QA |

---

## Modal/Overlay Testing (Special Section)

Every popup, drawer, side-panel, and overlay must pass:

- [ ] Has backdrop/overlay OR pushes content aside
- [ ] Panel doesn't cover content without visual separation
- [ ] Close button works
- [ ] Clicking backdrop closes the panel
- [ ] Background content is non-interactive when modal is open
- [ ] Content resizes properly for drawers/split-panels

> 💀 **Panel covering content without visual separation = BUG** — Fix immediately.

---

## QA Agent Instructions Template

When spawning a QA agent, include:

```markdown
## QA Task
Test [feature name] on [URL]. Use the 10-section QA checklist.

## Test Account
Create a new test account. Do NOT use admin or production accounts.

## Viewports to Test
- Desktop: 1920x1080, 1366x768
- Mobile: 390x844, 360x800

## Report Format
Use the 10-section report: Summary, UI Clickthrough, Responsive, Console,
CRUD, Permission, Security, User Flows, Regression, Verdict.

## Rules
- Test EVERY button, not just the happy path
- Button that does nothing = BUG
- Compare UI values with API response values
- Include specific test results, not just "X tests pass"
```

---

*Battle-tested across 46+ pages, 60+ API modules, catching 150+ bugs before production.*
