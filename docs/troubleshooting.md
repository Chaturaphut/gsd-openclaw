# Troubleshooting: Common Multi-Agent Workflow Failures

**Scope:** GSD-OpenClaw workflows using multiple specialized agents.  
**Audience:** Anyone orchestrating 5–50 agents with the GSD workflow.

---

## 1. Agent Produces Wrong Output / Misunderstands Task

**Symptoms:**
- Backend agent builds the wrong API schema
- QA agent tests the wrong scenario
- Frontend agent uses hardcoded values instead of API data

**Root Causes:**
- Task instruction was ambiguous or missing context
- Agent didn't read `SPEC.md` or `PLAN.md` before working
- Handoff from previous agent was incomplete

**Fix:**
```markdown
✅ Always include in task instruction:
   - Which files to read first (SPEC, PLAN, CONTEXT)
   - What "done" looks like (acceptance criteria)
   - What NOT to do (scope boundary)
   - Link to the HANDOFF.json if continuing from another agent
```

**Prevention:** Use [`templates/PLAN.md`](../templates/PLAN.md) — it has `Read First` and `Acceptance Criteria` sections that prevent this.

---

## 2. Wave Execution Deadlock (Agent Waiting on Agent)

**Symptoms:**
- Wave 2 agent is blocked waiting for Wave 1 output
- Two agents waiting on each other's output
- Progress stalls at ~50%

**Root Causes:**
- Wave dependency not declared in PLAN.md
- Wave 1 agent didn't write output artifact to expected path
- Incorrect assumption about who produces what

**Fix:**
```markdown
1. Check .planning/PLAN.md → Wave definitions → confirm output/input contracts
2. Check if Wave 1 actually wrote its output file
3. If stuck: manually complete Wave 1 artifact, unblock Wave 2
4. Add explicit "Output:" section to each Wave task definition
```

**Prevention:** Use the data-flow contract pattern from [`docs/execution-hardening.md`](execution-hardening.md).

---

## 3. Context Rot — Agent Quality Degrades Mid-Session

**Symptoms:**
- Agent output quality drops after many tool calls
- Agent starts repeating itself or losing track of requirements
- Contradicts earlier decisions

**Root Causes:**
- Session context window filling up (>60% used)
- Agent has been running too many sequential tasks without a handoff
- No structured CONTEXT.md checkpointing

**Fix:**
```markdown
1. Checkpoint current state → write to .planning/CONTEXT.md
2. Spawn fresh agent with pointer to CONTEXT.md
3. New agent reads CONTEXT.md first, then continues
```

**Prevention:** Use [`docs/context-management.md`](context-management.md) — checkpoint after every major step.

---

## 4. Spec/API Drift — Frontend and Backend Out of Sync

**Symptoms:**
- Frontend uses `user_id`, backend returns `userId`
- Frontend sends POST body, backend expects query params
- Missing fields in API response that UI expects

**Root Causes:**
- Frontend and backend agents worked from different specs
- No shared schema contract defined before execution
- Spec was updated after one agent already implemented it

**Fix:**
```markdown
1. Create API-CONTRACT.md with exact field names, types, HTTP methods
2. Both Frontend and Backend agents must read API-CONTRACT.md before coding
3. If drift found: Backend is source of truth → fix Frontend to match
```

**Prevention:** Always define the API contract in PLAN.md Wave 1 before spawning Frontend or Backend agents. See [`recipes/api-with-frontend.md`](../recipes/api-with-frontend.md).

---

## 5. Agent Scope Creep — Added Features Nobody Asked For

**Symptoms:**
- Agent rewrites an entire service when asked to fix one function
- Extra UI components appear that weren't in the spec
- Agent "improves" things outside the task scope

**Root Causes:**
- Task instruction lacked explicit scope boundary
- Agent is over-eager (especially with large context)
- No "do NOT change" list in the instruction

**Fix:**
```markdown
Immediately:
1. Review diff → revert everything outside scope
2. Re-run the specific task with explicit scope limit

In the instruction, always add:
"⚠️ SCOPE LIMIT: Only modify files in [list]. Do NOT touch [list]. 
If you see improvements elsewhere, log them in .planning/seeds/ but do not implement."
```

---

## 6. QA Loop Never Ends (Ping-Pong Bug)

**Symptoms:**
- QA reports bug → Dev fixes → QA reports same bug again
- Same fix applied 3+ times
- Bug appears fixed in one scenario, broken in another

**Root Causes:**
- Root cause was never identified — only symptom was patched
- QA and Dev testing different scenarios
- Fix introduced a regression elsewhere

**Fix:**
```markdown
1. Stop the loop → escalate to human review
2. Fill FORENSICS.md with full root cause analysis
3. QA writes the exact reproduction steps as a test case
4. Dev reads forensics + test case before touching code
5. After fix: QA runs the exact test case first, THEN regression suite
```

---

## 7. Permission Denied / Credential Errors Mid-Run

**Symptoms:**
- Agent suddenly can't write files
- API calls return 401/403 after working earlier
- Git push fails with authentication error

**Root Causes:**
- Token expired during long session
- Agent using wrong credential file path
- File permissions changed

**Fix:**
```markdown
# For API tokens
Refresh token → update config file → re-run from checkpoint

# For git
git remote set-url origin https://<user>:<token>@github.com/...
# After push, always clean:
git remote set-url origin https://github.com/<user>/<repo>.git
```

See [`docs/credential-security.md`](credential-security.md) for safe credential patterns.

---

## 8. Agent Stubs Out Code (TODO / Placeholder)

**Symptoms:**
- Function body contains only `# TODO: implement`
- API endpoint returns hardcoded mock data
- Test file has `pass` or `skip` everywhere

**Root Causes:**
- Agent ran out of context before completing
- Task was too large for one session
- Agent misunderstood "scaffold" vs "implement"

**Fix:**
```markdown
1. Find all stubs: grep -r "TODO\|FIXME\|placeholder\|mock data" src/
2. Prioritize by criticality
3. Spawn fresh agent per stub file with explicit instruction:
   "Implement the TODO at line X — no placeholders, production-ready code"
```

**Prevention:** Enable stub detection from [`docs/execution-hardening.md`](execution-hardening.md). Run before any QA handoff.

---

## 9. Plan Verification Fails — Too Many Gaps

**Symptoms:**
- Plan review agent reports 40%+ of requirements unmapped
- Acceptance criteria vague or missing
- Plan approved but execution diverges from it immediately

**Root Causes:**
- Plan written too quickly without reading REQUIREMENTS.md
- Requirements were ambiguous to begin with
- Plan reviewer was the same agent that wrote the plan

**Fix:**
```markdown
1. Return to plan phase — do NOT execute yet
2. Cross-reference each requirement → each plan task
3. Use a different agent to review the plan (cross-AI peer review)
4. Requirement still ambiguous? → /gsd:discuss to resolve before proceeding
```

---

## 10. Deployment Succeeded But Feature Is Broken in Production

**Symptoms:**
- CI passes, deploy succeeds, but users report errors
- Feature works in staging, broken in production
- Environment-specific failure

**Root Causes:**
- Environment variable missing in production
- Database migration didn't run
- Production data format different from staging test data

**Fix:**
```markdown
1. Compare env vars: staging vs production
2. Check migration history in production DB
3. Run the exact failing scenario with production data (anonymized if needed)
4. Add environment audit to deployment checklist
```

See [`docs/docker-deploy.md`](docker-deploy.md) for environment validation steps.

---

## Quick Diagnosis Flowchart

```
❓ Something is wrong
    ↓
Is the bug in production right now?
    Yes → recipes/bugfix-hotfix.md (Hotfix Path)
    No ↓
Do I know the root cause?
    No → /gsd:forensics → FORENSICS.md
    Yes ↓
Is it scope/context/spec drift?
    Yes → Section 1/3/4 above
    No ↓
Is it an agent quality issue?
    Yes → Section 2/3/5/8 above
    No ↓
Is it infrastructure/deploy?
    Yes → Section 7/10 above
```

---

## Related Resources

| Doc | When to Use |
|-----|-------------|
| [`docs/execution-hardening.md`](execution-hardening.md) | Pre-wave dependency + stub checks |
| [`docs/context-management.md`](context-management.md) | Context window management |
| [`docs/verification-debt.md`](verification-debt.md) | Track what's untested |
| [`recipes/bugfix-hotfix.md`](../recipes/bugfix-hotfix.md) | Fast-track production fixes |
| [`templates/FORENSICS.md`](../templates/FORENSICS.md) | Root cause investigation |
| [`docs/qa-standards.md`](qa-standards.md) | Full QA checklist |
