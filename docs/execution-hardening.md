# 🛡️ Execution Hardening

> **Adapted from:** GSD v1.26 Execution Hardening
> **Purpose:** Pre-wave dependency checks and cross-plan data contracts to prevent execution failures.

---

## Overview

Execution Hardening adds verification gates **before** each wave starts, ensuring all dependencies are met and data contracts between tasks are consistent. This prevents the most common multi-agent failure: agents building against mismatched assumptions.

---

## Pre-Wave Dependency Checks

Before launching any wave, the coordinator verifies:

### 1. Task Dependencies Resolved

```
Wave 2 Pre-Check:
  Task 4 depends on Task 1 → Task 1 status: ✅ Complete
  Task 4 depends on Task 2 → Task 2 status: ✅ Complete
  Task 5 depends on Task 3 → Task 3 status: ✅ Complete
  
  All dependencies met → ✅ Proceed with Wave 2
```

### 2. File Dependencies Exist

```
Wave 2 Pre-Check — File Dependencies:
  Task 4 reads from: src/api/types.ts → ✅ Exists (created by Task 1)
  Task 5 imports: src/services/auth.ts → ✅ Exists (created by Task 2)
  Task 6 uses: src/config/db.ts → ❌ NOT FOUND
  
  BLOCKED: Task 6 depends on src/config/db.ts which doesn't exist yet.
  Action: Check if Task 3 was supposed to create it.
```

### 3. Schema Consistency

```
Wave 2 Pre-Check — Schema Contracts:
  Task 4 (Frontend) expects API: POST /api/auth/login { email, password }
  Task 1 (Backend) created API: POST /api/auth/login { username, password }
  
  ❌ MISMATCH: Frontend expects "email", Backend uses "username"
  Action: Resolve before executing Wave 2.
```

---

## Cross-Plan Data Contracts

When multiple plan files exist (multi-phase or multi-agent), enforce data contracts:

### Contract Definition

Add to PLAN.md:

```markdown
## Data Contracts

### API Contract: Auth Endpoints
```json
{
  "POST /api/auth/login": {
    "request": { "email": "string", "password": "string" },
    "response": { "token": "string", "refreshToken": "string", "user": { "id": "string", "email": "string", "role": "string" } }
  },
  "POST /api/auth/refresh": {
    "request": { "refreshToken": "string" },
    "response": { "token": "string" }
  }
}
```

### DB Schema Contract
```sql
CREATE TABLE users (
  id UUID PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  role VARCHAR(50) DEFAULT 'user',
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

### Event Contract
```json
{
  "user.created": { "userId": "string", "email": "string", "role": "string" },
  "user.login": { "userId": "string", "timestamp": "ISO8601" }
}
```
```

### Contract Verification

Before execution, verify all consumers match the contract:

```
Contract Check: POST /api/auth/login
  Producer (Backend PLAN): ✅ Matches contract
  Consumer (Frontend PLAN): ✅ Matches contract
  Consumer (Mobile PLAN): ❌ Uses "username" instead of "email"
  
  Action: Fix Mobile PLAN before executing.
```

---

## Hardening Checklist

Run before each wave:

```markdown
## Wave N Pre-Execution Checklist

### Dependencies
- [ ] All predecessor tasks complete (check HANDOFF.json)
- [ ] All file dependencies exist on disk
- [ ] No unresolved WAITING.json decisions blocking this wave

### Contracts
- [ ] API schemas match between producer/consumer tasks
- [ ] DB schema matches ORM model definitions
- [ ] Environment variables documented and available
- [ ] Shared types/interfaces consistent across tasks

### Resources
- [ ] Required MCP tools available (check tool inventory)
- [ ] Required services running (DB, Redis, etc.)
- [ ] Required config files in place (.env, config.json)

### Context
- [ ] Agent instructions include current HANDOFF.json context
- [ ] Agent instructions include relevant data contracts
- [ ] Total instruction size within context limits
```

---

## Implementation Pattern

### Coordinator Pre-Wave Script

```markdown
Before spawning Wave N agents:

1. Read all completed HANDOFF.json files from previous waves
2. Read PLAN.md data contracts section
3. For each task in Wave N:
   a. Check task dependencies against completed tasks
   b. Verify file dependencies exist (use `exec: ls -la <path>`)
   c. Verify schema contracts match between this task and its data providers
4. If any check fails → STOP and report mismatch
5. If all checks pass → spawn Wave N agents with contract context
```

### Agent Instruction Augmentation

Include contracts in agent instructions:

```markdown
## Data Contracts You Must Follow

### API Response Format (from Task 1 — Backend)
POST /api/auth/login returns:
{
  "token": "string (JWT)",
  "refreshToken": "string (UUID)",
  "user": { "id": "string", "email": "string", "role": "string" }
}

⚠️ You MUST use these exact field names. No variations.
```

---

## Common Failures Prevented

| Failure | Without Hardening | With Hardening |
|---------|-------------------|----------------|
| Field name mismatch | Discovered in QA (rework) | Caught before execution |
| Missing dependency | Runtime error | Pre-wave check blocks |
| Schema drift | Silent data loss | Contract verification |
| Environment gap | "Works on my machine" | Resource check |
| Unresolved decision | Agent guesses wrong | WAITING.json gate |

---

## Related

- [Wave Execution Guide](wave-execution-guide.md) — Wave patterns and dependencies
- [Ship Workflow](ship-workflow.md) — Post-execution shipping
- [QA Standards](qa-standards.md) — Post-execution verification
