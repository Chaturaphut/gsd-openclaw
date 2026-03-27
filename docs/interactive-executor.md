# 🤝 Interactive Executor Mode

> **Adapted from:** GSD v1.26 Interactive Executor Mode
> **Purpose:** Pair-programming pattern where human and agent collaborate in real-time on task execution.

---

## Overview

Interactive Executor Mode bridges the gap between fully autonomous execution and manual coding. The agent executes plan tasks step-by-step, pausing for human review and input at each step.

---

## When to Use

| Scenario | Mode |
|----------|------|
| Routine CRUD, simple changes | Autonomous (default) |
| Security-sensitive code | **Interactive** |
| Complex architecture decisions | **Interactive** |
| First time using GSD on a project | **Interactive** |
| High-risk production changes | **Interactive** |

---

## Configuration

```json
// .planning/config.json
{
  "workflow": {
    "executionMode": "interactive",
    "interactiveOptions": {
      "pauseBeforeEachTask": true,
      "showProposedChanges": true,
      "requireApproval": true,
      "autoApproveTypes": ["test", "docs"]
    }
  }
}
```

---

## Execution Flow

### 1. Task Preview
Agent shows what it plans to do before doing it:

```
📋 Task 3 of 8: Create authentication middleware
   Files: src/middleware/auth.ts (NEW)
   Dependencies: Task 1 (JWT library installed) ✅
   Wave: 1
   
   Proposed approach:
   - Verify JWT token from Authorization header
   - Extract user role from token claims
   - Check role against route permissions
   - Handle token refresh for expired tokens
   
   [Proceed] [Modify] [Skip] [Show Code First]
```

### 2. Code Preview
If requested, agent shows the exact code before writing:

```typescript
// src/middleware/auth.ts — PROPOSED (not yet written)
import { verify } from 'jsonwebtoken';
import { Request, Response, NextFunction } from 'express';

export function authMiddleware(requiredRole?: string) {
  return (req: Request, res: Response, next: NextFunction) => {
    const token = req.headers.authorization?.split(' ')[1];
    if (!token) return res.status(401).json({ error: 'Token required' });
    
    try {
      const decoded = verify(token, process.env.JWT_SECRET!);
      req.user = decoded;
      if (requiredRole && decoded.role !== requiredRole) {
        return res.status(403).json({ error: 'Insufficient permissions' });
      }
      next();
    } catch (err) {
      return res.status(401).json({ error: 'Invalid token' });
    }
  };
}
```

### 3. Human Response Options

| Response | Effect |
|----------|--------|
| **Proceed** | Agent writes the code as shown |
| **Modify** | Human provides changes, agent incorporates |
| **Skip** | Task deferred, agent moves to next |
| **Abort** | Stop execution entirely |
| **Auto** | Switch to autonomous for remaining tasks |

### 4. Post-Task Verification
After each task, agent confirms:

```
✅ Task 3 complete
   Created: src/middleware/auth.ts (42 lines)
   Tests: src/middleware/__tests__/auth.test.ts (68 lines)
   
   Moving to Task 4: "Create login endpoint"
   [Continue] [Review Changes] [Run Tests First]
```

---

## OpenClaw Implementation

In OpenClaw, interactive mode works through the chat interface:

```
Coordinator → spawns Dev Agent with interactive flag
Dev Agent → sends task preview to coordinator
Coordinator → relays to user via Telegram/Discord
User → responds with approval/modification
Coordinator → relays to Dev Agent
Dev Agent → executes and reports
```

### Agent Instruction Pattern

Add to dev agent spawn instructions:

```markdown
## Interactive Execution Mode

You are in INTERACTIVE mode. For each task in PLAN.md:

1. **Preview** — Tell the coordinator what you plan to do
2. **Wait** — Do NOT write any code until approved
3. **Execute** — Only after explicit "proceed" or "approved"
4. **Report** — Show what was created/modified
5. **Pause** — Wait for "continue" before next task

Exception: Tasks tagged with `auto-approve: true` can be executed without waiting.
```

---

## Benefits for OpenClaw Teams

- **Trust Building** — See exactly what agents produce before it hits your codebase
- **Knowledge Transfer** — Learn the agent's approach to problems
- **Quality at Source** — Catch issues before they need QA rework
- **Hybrid Workflow** — Human expertise + agent speed

---

## Related

- [Agent Delegation](agent-delegation.md) — How coordinator manages agents
- [Wave Execution Guide](wave-execution-guide.md) — Autonomous execution patterns
- [Auto Advance](auto-advance.md) — Automatic stage progression
