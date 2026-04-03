# Recipe: Legacy Code Migration (The Strangler Fig Pattern)

## 🎯 Goal
Migrate a legacy feature or module to a modern tech stack (e.g., PHP → Node.js, JS → TS, or REST → GraphQL) while ensuring zero downtime and 100% logic parity.

## 👥 Virtual Team Roles
- **Coordinator (MumuX):** Project setup, roadmap, and wave orchestration.
- **Solution Architect (Son):** Architecture research, parity design, and data contract verification.
- **Backend Dev (Mai):** Implementing the new logic.
- **QA Pool (Meekun/Gam):** Parity testing, regression verification.
- **DevSecOps (Gideon):** Deployment, routing rules, and observability.

---

## 🔄 Workflow

### Phase 1: Mapping & Research
- **Input:** Legacy codebase + current production metrics.
- **GSD Step:** Stage 0 (Map Codebase) + Stage 2 (Research).
- **Output:**
  - `STACK.md` (Legacy vs New)
  - `CONCERNS.md` (Known bugs in legacy, hidden dependencies)
  - `RESEARCH.md` (Comparison of migration strategies, risk assessment)

### Phase 2: Parity Planning
- **Input:** RESEARCH.md.
- **GSD Step:** Stage 1 (Requirements) + Stage 3 (Plan).
- **Output:**
  - `REQUIREMENTS.md` (Explicit parity list — including "accidental" legacy behaviors)
  - `PLAN.md` (Wave 1: Test harness creation, Wave 2: New logic implementation)
- **Rule:** Use a "Shadow Proxy" or "Dark Launch" approach where possible.

### Phase 3: The Parallel Bridge (Wave 1)
- **Tasks:**
  - Build a proxy/wrapper that intercepts calls to the legacy code.
  - Implement a logging mechanism to record legacy inputs and outputs (The "Gold Master" approach).
- **Verification:** Ensure the proxy has zero impact on legacy performance.

### Phase 4: Implementation (Wave 2)
- **Tasks:**
  - Build the new logic in the modern stack.
  - Implement a "Parity Checker" that runs both legacy and new logic, comparing results.
- **Verification:** `QA.md` must show 0% mismatch in parity checker logs.

### Phase 5: The Cutover (Wave 3)
- **Tasks:**
  - Gradually shift traffic (1% → 10% → 100%) to the new logic.
  - Monitor error rates and latency.
- **Verification:** Final `SUMMARY.md` + regression gate pass.

---

## 💡 Best Practices for Agents
1. **Never Assume:** Legacy code "looks" like it does X, but may do Y due to a side effect. Agents must use the "Gold Master" technique (recording actual I/O).
2. **Atomic Commits:** Separate "Refactor Legacy" commits from "Implement New" commits.
3. **Forensics First:** If parity fails, run `/gsd:forensics` immediately to find if it's a logic error or an environmental difference (e.g., DB collation).

---

## 🛠️ Related Docs
- [docs/execution-hardening.md](../docs/execution-hardening.md)
- [docs/forensics-guide.md](../docs/forensics-guide.md)
- [docs/verification-debt.md](../docs/verification-debt.md)
