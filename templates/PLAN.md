# PLAN.md Template

## Phase: [Phase Name]
**Created:** [Date] | **Status:** Draft / Verified / Executing / Complete

### Requirements Covered
- [x] REQ-001 → Task 1, Task 3
- [x] REQ-002 → Task 2
- [x] REQ-003 → Task 4, Task 5
- [ ] REQ-004 → ⚠️ NOT COVERED — add tasks before executing!

### Tasks

---

## Task 1: [Name]
- **Files:** `src/api/routes.ts`, `src/services/auth.ts`
- **Dependencies:** None (Wave 1)
- **Wave:** 1
- **Read First:** [Critical info/refs to read before starting this task]
- **Action:**
  1. Create `src/api/routes.ts` with endpoints: `GET /api/items`, `POST /api/items`
  2. Add request validation using Zod schema
  3. Implement error handling middleware
  4. Add rate limiting (100 req/min)
- **Verify:**
  - `curl GET /api/items` returns 200 with JSON array
  - `curl POST /api/items` with invalid body returns 400
  - Rate limit triggers after 100 requests
- **Acceptance Criteria:**
  - [ ] Both endpoints return correct responses with validation
  - [ ] No stubs or TODOs left in the implementation
  - [ ] Code passes linting and security scanning

---

## Task 2: [Name]
- **Files:** `src/models/item.ts`
- **Dependencies:** None (Wave 1)
- **Wave:** 1
- **Action:**
  1. [Step-by-step instructions]
- **Verify:** [How to test]
- **Done When:** [Acceptance criteria]

---

## Task 3: [Name]
- **Files:** `src/components/ItemList.tsx`
- **Dependencies:** Task 1 (needs API)
- **Wave:** 2
- **Action:**
  1. [Step-by-step instructions]
- **Verify:** [How to test]
- **Done When:** [Acceptance criteria]

---

### Wave Execution Order
```
Wave 1 (parallel): Task 1 + Task 2
         ↓
Wave 2 (after Wave 1): Task 3
         ↓
Wave 3 (integration): Task 4 + Task 5
```

### Verification Checklist
- [ ] Every requirement has ≥1 mapped task
- [ ] No scope creep beyond v1
- [ ] API schemas match between FE/BE tasks
- [ ] Dependencies are acyclic
- [ ] Field names consistent across all tasks
- [ ] File paths match project structure
