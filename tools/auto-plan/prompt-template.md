# Auto-Plan Generation Prompt Template

Use this prompt with your AI agent to generate a structured PLAN.md from REQUIREMENTS.md and RESEARCH.md.

---

## Prompt

```
You are a GSD (Get Shit Done) Solution Architect. Generate a structured execution plan from the requirements and research provided below.

## Input Documents

### REQUIREMENTS.md
{REQUIREMENTS_CONTENT}

### RESEARCH.md
{RESEARCH_CONTENT}

## Output Format

Generate a PLAN.md following this exact structure:

---
# Execution Plan: {PROJECT_NAME}

## Read First
- **Requirements:** .planning/REQUIREMENTS.md
- **Research:** .planning/RESEARCH.md
- **Conventions:** Follow existing project patterns

## Summary
[1-2 sentence overview of what this plan achieves]

## Wave 1: [Foundation — Independent Tasks]

### Task 1.1: [Descriptive Name]
- **Files:** [exact file paths to create/modify]
- **Dependencies:** None
- **Action:**
  1. [Step-by-step implementation instructions]
  2. [Be specific about what to implement]
  3. [Reference research findings where relevant]
- **Verify:** [How to test this task]
- **Done When:** [Measurable acceptance criteria]

### Task 1.2: [Descriptive Name]
[Same structure...]

## Wave 2: [Integration — Depends on Wave 1]

### Task 2.1: [Descriptive Name]
- **Dependencies:** Task 1.1, Task 1.2
[Same structure...]

## Wave 3: [Polish — Depends on Wave 2]
[If needed...]

## Acceptance Criteria
- [ ] [Criterion from requirements]
- [ ] [Criterion from requirements]
- [ ] All tests passing
- [ ] No stubs or TODOs in production code

## Requirements Coverage
| Requirement | Task(s) |
|-------------|---------|
| [Req 1] | Task 1.1 |
| [Req 2] | Task 1.2, Task 2.1 |

---

## Rules

1. **Every requirement must map to at least one task** — no orphan requirements
2. **Tasks in the same wave must be independent** — no dependencies within a wave
3. **File paths must be exact** — no "somewhere in src/"
4. **API schemas must be consistent** — same field names across frontend/backend tasks
5. **Acceptance criteria must be measurable** — not "works correctly" but "returns 200 with JWT token"
6. **Include edge cases** from research in verification steps
7. **No scope creep** — only implement what's in v1 requirements
8. **Task sizing matters:**
   - Each task should be completable in one agent session
   - If a task touches >5 files, split it
   - If a task has >10 steps, split it
```

## Variables

| Variable | Source | Description |
|----------|--------|-------------|
| `{REQUIREMENTS_CONTENT}` | `.planning/REQUIREMENTS.md` | Full requirements document |
| `{RESEARCH_CONTENT}` | `.planning/RESEARCH.md` | Research findings (if exists) |
| `{PROJECT_NAME}` | `.planning/PROJECT.md` title | Project name |

## Tips for Better Plans

1. **Include the full REQUIREMENTS.md** — don't summarize
2. **Include RESEARCH.md** if available — agents use pitfalls to write better verification steps
3. **Review the generated plan** before executing — AI plans need human review
4. **Check the Requirements Coverage table** — ensure no gaps
5. **Validate wave dependencies** — ensure tasks in the same wave are truly independent
