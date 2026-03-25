# 🚫 Error Handling Standards

> **Rule:** Never show raw errors to users. Retry before escalating.

AI agents love to pass errors straight through — "Error: ECONNREFUSED" is not helpful to anyone. This guide ensures graceful error handling at every level.

---

## Error Handling Layers

### 1. Agent-Level (Retry Before Report)

When an agent encounters an error:

```
Step 1: Retry the operation (2-3 times with backoff)
Step 2: If still failing, try alternative approach
Step 3: If all options exhausted, report to coordinator with:
        - What was attempted
        - Error details
        - Suggested next steps
```

**Never:**
```
❌ "Error occurred" → Report immediately
❌ Raw error dump to stakeholder
```

**Always:**
```
✅ Retry 2-3x → Alternative approach → Then report with context
```

### 2. API-Level (User-Facing)

```typescript
// ✅ Structured error response
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Email address is required",
    "field": "email"
  },
  "requestId": "req-abc123"  // For support reference
}

// ❌ NEVER expose internals
{
  "error": "MongoServerError: E11000 duplicate key error collection: myapp.users index: email_1",
  "stack": "at processTicksAndRejections (node:internal/process/task_queues:95:5)\n..."
}
```

### 3. UI-Level (What Users See)

| State | Show |
|-------|------|
| Loading | Spinner or skeleton animation |
| Empty | Helpful message + action suggestion |
| Error | User-friendly message + retry option |
| Network error | "Connection issue — please try again" |
| 403 | "You don't have permission to access this" |
| 404 | "Page not found" with navigation options |
| 500 | "Something went wrong — please try again later" |

**Never show:** Stack traces, database errors, internal paths, raw JSON, undefined/null/NaN, `[object Object]`

---

## Model Fallback Strategy

When the primary AI model fails, automatically fall back:

```
Primary model (e.g., Claude Opus) → 429/500/timeout
        ↓ retry 2x
Still failing?
        ↓
Fallback model (e.g., Gemini Flash) → attempt
        ↓
Still failing?
        ↓
Report to stakeholder with details
```

---

*Zero raw error exposures to end users since adoption.*
