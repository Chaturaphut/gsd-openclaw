# Example: Full GSD Phase

> Use Full GSD when: >3 files OR new API endpoints

## Phase 1: User Authentication Module

### REQUIREMENTS.md (excerpt)
```markdown
### v1 — Must Have
1. **[REQ-001]** Email/password login — Returns JWT token
2. **[REQ-002]** User registration — Email verification required
3. **[REQ-003]** Password reset — Via email link, expires in 1 hour
4. **[REQ-004]** Session management — JWT with refresh token rotation
```

### RESEARCH.md (excerpt)
```markdown
### Pitfalls
| Risk | Mitigation |
|------|------------|
| JWT stored in localStorage — XSS vulnerability | Use httpOnly cookies |
| No rate limiting on login — brute force | Rate limit: 5 attempts / 15 min |
| Plain bcrypt with low rounds — crackable | bcrypt with 12 rounds minimum |
```

### PLAN-01.md (excerpt)
```markdown
## Task 1: Auth API Endpoints (Wave 1)
- **Files:** `src/api/auth.routes.ts`, `src/api/auth.controller.ts`
- **Dependencies:** None
- **Wave:** 1
- **Action:**
  1. POST /api/auth/login — validate email+password, return JWT in httpOnly cookie
  2. POST /api/auth/register — create user, send verification email
  3. POST /api/auth/forgot-password — generate reset token, send email
  4. POST /api/auth/reset-password — validate token, update password
- **Verify:** All 4 endpoints return correct status codes
- **Done When:** Login returns valid JWT, register sends email

## Task 2: User Model (Wave 1)
- **Files:** `src/models/user.ts`, `src/migrations/001-users.ts`
- **Dependencies:** None
- **Wave:** 1
- **Action:**
  1. Define User schema: email (unique), passwordHash, isVerified, createdAt
  2. Create migration for users table
  3. Add bcrypt (12 rounds) password hashing in pre-save hook
- **Verify:** User can be created and retrieved from DB
- **Done When:** Model passes unit tests

## Task 3: Auth Frontend (Wave 2)
- **Files:** `src/pages/Login.tsx`, `src/pages/Register.tsx`, `src/hooks/useAuth.ts`
- **Dependencies:** Task 1 (needs API)
- **Wave:** 2
- **Action:**
  1. Login page with email/password form + validation
  2. Register page with email/password/confirm form
  3. useAuth hook for auth state management
- **Verify:** Login form submits and receives JWT
- **Done When:** User can register and login via UI

### Wave Execution
Wave 1 (parallel): Task 1 + Task 2
         ↓
Wave 2 (after Wave 1): Task 3
```

### HANDOFF.json (after Phase 1 complete)
```json
{
  "phase": "phase-1-auth",
  "status": "complete",
  "completedTasks": ["task-1", "task-2", "task-3"],
  "decisions": [
    {"id": "D001", "summary": "JWT in httpOnly cookie, not localStorage", "reason": "XSS prevention"},
    {"id": "D002", "summary": "bcrypt 12 rounds", "reason": "Security standard"},
    {"id": "D003", "summary": "Refresh token rotation", "reason": "Prevent token reuse"}
  ],
  "modifiedFiles": [
    "src/api/auth.routes.ts",
    "src/api/auth.controller.ts",
    "src/models/user.ts",
    "src/migrations/001-users.ts",
    "src/pages/Login.tsx",
    "src/pages/Register.tsx",
    "src/hooks/useAuth.ts"
  ],
  "nextSteps": ["Phase 2: Role-based access control"]
}
```
