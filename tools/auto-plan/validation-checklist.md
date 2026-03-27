# ✅ Plan Validation Checklist

Use this checklist to verify a generated (or manually created) PLAN.md before execution.

## Structure Checks

- [ ] **Read First section exists** — Links to REQUIREMENTS.md, RESEARCH.md, PROJECT.md
- [ ] **Summary is clear** — 1-2 sentences describing what the plan achieves
- [ ] **Wave grouping is correct** — Tasks organized into numbered waves
- [ ] **Every task has all fields:**
  - [ ] Files (exact paths)
  - [ ] Dependencies (or "None")
  - [ ] Action (numbered steps)
  - [ ] Verify (how to test)
  - [ ] Done When (acceptance criteria)

## Dependency Checks

- [ ] **No intra-wave dependencies** — Tasks in the same wave must be independent
- [ ] **Dependencies reference valid tasks** — No broken references
- [ ] **No circular dependencies** — Wave N can only depend on Wave 1..N-1
- [ ] **Dependency chain is complete** — If Task 3.1 needs Task 2.1, Task 2.1 must also list *its* dependencies

## Requirements Coverage

- [ ] **Requirements Coverage table exists** — Maps every requirement to task(s)
- [ ] **No orphan requirements** — Every requirement has at least one task
- [ ] **No scope creep** — Every task traces back to a requirement
- [ ] **v2 items excluded** — Only v1 requirements are planned

## API Consistency

- [ ] **Field names match** — Same field names across frontend/backend tasks
- [ ] **API schemas defined** — Request/response formats specified
- [ ] **Error handling specified** — What happens on 400, 401, 404, 500
- [ ] **Data types consistent** — IDs are strings everywhere, dates are ISO format everywhere

## Task Quality

- [ ] **Tasks are right-sized** — Each completable in one agent session
- [ ] **No task touches >5 files** — Split if larger
- [ ] **No task has >10 steps** — Split if more complex
- [ ] **File paths are exact** — Not "somewhere in src/" but "src/api/auth.ts"
- [ ] **Acceptance criteria are measurable** — Not "works correctly" but "returns 200 with JWT"

## Research Integration

- [ ] **Known pitfalls addressed** — RESEARCH.md findings reflected in verification steps
- [ ] **Edge cases in verify steps** — Not just happy path
- [ ] **Library versions specified** — If research found version constraints
- [ ] **Security considerations included** — From OWASP checks if applicable

## Quick Validation Script

Run this to check basic plan structure:

```bash
PLAN_FILE=".planning/PLAN-draft.md"

echo "📋 Validating: $PLAN_FILE"
echo "================================"

# Check required sections
for section in "Read First" "Summary" "Wave" "Acceptance Criteria" "Requirements Coverage"; do
  if grep -q "$section" "$PLAN_FILE"; then
    echo "✅ Found: $section"
  else
    echo "❌ Missing: $section"
  fi
done

# Check task structure
TASKS=$(grep -c "^### Task" "$PLAN_FILE" || echo "0")
echo "📊 Tasks found: $TASKS"

# Check for incomplete fields
MISSING_FILES=$(grep -c "\[specify\|TBD\|TODO" "$PLAN_FILE" || echo "0")
if [ "$MISSING_FILES" -gt 0 ]; then
  echo "⚠️ Incomplete fields: $MISSING_FILES (search for [specify/TBD/TODO)"
else
  echo "✅ No incomplete fields"
fi

# Check for unmapped requirements
UNMAPPED=$(grep -c "Unmapped" "$PLAN_FILE" || echo "0")
if [ "$UNMAPPED" -gt 0 ]; then
  echo "❌ Unmapped requirements: $UNMAPPED"
else
  echo "✅ All requirements mapped"
fi

echo "================================"
```

## Common Issues

| Issue | How to Fix |
|-------|-----------|
| Task too large | Split into subtasks in the same wave |
| Circular dependency | Restructure waves to break the cycle |
| Missing verification | Add specific test steps + expected output |
| Vague acceptance criteria | Replace "works" with measurable outcome |
| Scope creep | Remove tasks not tied to v1 requirements |
| Field name mismatch | Align on exact names in a shared schema section |
