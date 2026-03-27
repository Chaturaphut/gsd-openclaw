# 🧠 Context Window Optimization

> **Adapted from:** GSD v1.27 Context Window Size Awareness
> **Purpose:** Strategies to maximize quality within finite context windows.

---

## Overview

AI agents have finite context windows. As context fills up, output quality degrades — the agent "forgets" earlier instructions, makes inconsistent decisions, and produces lower-quality code. This guide provides strategies to stay within optimal context usage.

---

## Context Budget

### Model Context Limits

| Model | Total Context | Optimal Usage | Danger Zone |
|-------|--------------|---------------|-------------|
| Claude Sonnet 4 | 200K tokens | ≤ 80K tokens | > 120K tokens |
| Claude Opus 4 | 200K tokens | ≤ 80K tokens | > 120K tokens |
| GPT-4o | 128K tokens | ≤ 60K tokens | > 90K tokens |
| Gemini 2.5 Pro | 1M tokens | ≤ 200K tokens | > 500K tokens |

**Rule of thumb:** Stay under 40-50% of total context for best output quality.

---

## Document Size Limits (Enforced)

| Document | Max Size | ~Tokens | Why |
|----------|----------|---------|-----|
| PROJECT.md | 2,000 words | ~2,700 | Vision only — no implementation details |
| REQUIREMENTS.md | 3,000 words | ~4,000 | Bullet points, not prose |
| RESEARCH.md | 3,000 words | ~4,000 | Actionable findings only |
| PLAN.md (per plan) | 2,000 words | ~2,700 | One plan per task group |
| Agent instruction | 4,000 words | ~5,400 | Plan + context combined |
| SUMMARY.md | 1,000 words | ~1,350 | What changed, not why |
| HANDOFF.json | 500 lines | ~2,000 | Machine-readable, compact |

---

## Optimization Strategies

### 1. Scope Narrowing

Give each agent only the context it needs:

```
❌ Wrong: Send the entire REQUIREMENTS.md + RESEARCH.md + all PLANs to a dev agent
✅ Right: Send only the specific task from PLAN.md + relevant RESEARCH section
```

### 2. Progressive Summarization

For long-running projects, summarize earlier phases:

```
Phase 1: Full PLAN.md + SUMMARY.md (current)
Phase 2: Full PLAN.md + SUMMARY.md (current)
Phase 3: Full PLAN.md + SUMMARY.md (current)

For a Phase 4 agent:
  - Phase 1: SUMMARY.md only (500 words)
  - Phase 2: SUMMARY.md only (500 words)
  - Phase 3: HANDOFF.json + SUMMARY.md (1,000 words)
  - Phase 4: Full PLAN.md + CONTEXT.md (4,000 words)
  
Total: ~6,000 words instead of 20,000+
```

### 3. Context Rotation

For very long sessions, rotate context:

```
Session Start: Load PLAN.md + RESEARCH.md + CONTEXT.md
After Wave 1:  Unload RESEARCH.md, load HANDOFF.json
After Wave 2:  Unload Wave 1 details, load Wave 2 results
After QA:      Unload execution details, load QA report
```

### 4. Reference by Path, Don't Inline

```
❌ Wrong: [paste entire file content in instructions]
✅ Right: "Read src/api/routes.ts for the current API structure"
```

Let the agent read files on demand instead of front-loading everything.

### 5. Template Compression

Use shorthand in templates:

```markdown
❌ Verbose:
Task 1: Create the authentication service
  This task involves creating a new authentication service that will handle
  user login, registration, and token management. The service should be
  located in src/services/auth.ts and should export functions for...

✅ Compressed:
Task 1: Auth service
  Files: src/services/auth.ts (NEW)
  Action: Create login(), register(), refreshToken()
  Verify: Unit tests pass, JWT valid
```

---

## Context Budget Calculator

Estimate context usage before spawning agents:

```
Agent Instruction Template:
  System prompt:      ~500 tokens (fixed)
  GSD workflow rules: ~1,000 tokens (fixed)
  Task from PLAN.md:  ~500 tokens
  Relevant RESEARCH:  ~800 tokens
  Data contracts:     ~300 tokens
  HANDOFF context:    ~400 tokens
  ─────────────────────────────
  Total input:        ~3,500 tokens
  
  + Agent's working memory during execution: ~2,000 tokens
  + Code output: ~3,000 tokens
  ─────────────────────────────
  Total session:      ~8,500 tokens ✅ (well within limits)
```

---

## Warning Signs of Context Overflow

Watch for these in agent output:

1. **Inconsistent naming** — Agent forgets earlier naming decisions
2. **Repeated code** — Agent doesn't remember what it already wrote
3. **Ignored instructions** — Earlier instructions get "pushed out"
4. **Truncated output** — Agent stops mid-implementation
5. **Contradictions** — Agent says one thing, does another

**Action:** If you see these → split the task into smaller pieces or reduce context.

---

## Configuration

```json
// .planning/config.json
{
  "context": {
    "maxInstructionTokens": 5400,
    "maxDocumentWords": {
      "project": 2000,
      "requirements": 3000,
      "research": 3000,
      "plan": 2000,
      "summary": 1000
    },
    "progressiveSummarization": true,
    "warnOnContextExceed": true
  }
}
```

---

## Related

- [Context Management](context-management.md) — Document architecture and memory
- [Agent Delegation](agent-delegation.md) — How to scope agent instructions
- [Wave Execution Guide](wave-execution-guide.md) — Task splitting for parallel execution
