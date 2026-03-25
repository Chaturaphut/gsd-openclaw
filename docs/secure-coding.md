# 🔒 Secure Coding Standards for AI Agent Teams

> Based on OWASP Top 10, adapted for AI-generated code.

AI agents write functional code fast. But they also write insecure code fast — often following patterns they've seen in training data that include common vulnerabilities. This guide ensures every line of AI-generated code meets security standards.

---

## Why AI-Generated Code Needs Extra Scrutiny

- 🧠 **Training data includes vulnerable code** — Stack Overflow answers, old tutorials, insecure patterns
- ⚡ **Speed over security** — Agents optimize for "it works" not "it's secure"
- 📋 **Pattern completion** — Agents complete code patterns even if the pattern is insecure
- 🔄 **No threat modeling instinct** — Agents don't think about adversaries by default

---

## The Rules

### 1. Input Validation (Client + Server)

**Never trust input — validate on BOTH sides:**

```typescript
// ❌ NEVER — client-only validation
const email = req.body.email; // Used directly

// ✅ ALWAYS — server-side validation
import { z } from 'zod';
const schema = z.object({
  email: z.string().email().max(255),
  name: z.string().min(1).max(100).trim(),
  age: z.number().int().min(0).max(150),
});
const validated = schema.parse(req.body);
```

### 2. Parameterized Queries Only

**NEVER concatenate strings into queries:**

```typescript
// ❌ NEVER — SQL injection
const query = `SELECT * FROM users WHERE email = '${email}'`;

// ✅ ALWAYS — parameterized
const user = await db.query('SELECT * FROM users WHERE email = ?', [email]);

// ❌ NEVER — NoSQL injection
const user = await User.findOne({ email: req.body.email });

// ✅ ALWAYS — explicit type casting
const user = await User.findOne({ email: String(req.body.email) });
```

### 3. XSS Prevention

```typescript
// ✅ Sanitize output
import DOMPurify from 'dompurify';
const safeHtml = DOMPurify.sanitize(userInput);

// ✅ Content Security Policy header
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      scriptSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
    },
  },
}));

// ✅ React auto-escapes by default — but NEVER use dangerouslySetInnerHTML
```

### 4. Authentication

```typescript
// ✅ Password hashing — bcrypt with ≥10 rounds (12 recommended)
import bcrypt from 'bcrypt';
const hash = await bcrypt.hash(password, 12);

// ✅ JWT — short-lived, httpOnly cookies
const token = jwt.sign({ userId }, secret, { expiresIn: '24h' });
res.cookie('token', token, {
  httpOnly: true,    // Not accessible via JavaScript
  secure: true,      // HTTPS only
  sameSite: 'strict', // CSRF protection
  maxAge: 86400000,  // 24 hours
});

// ❌ NEVER store JWT in localStorage — XSS can steal it
```

### 5. Authorization (Every Endpoint)

```typescript
// ✅ Every endpoint has permission check
@RequirePermission('users.read')
@Get('/users')
async getUsers() { ... }

// ✅ IDOR prevention — verify ownership
async getDocument(userId: string, docId: string) {
  const doc = await Document.findById(docId);
  if (doc.ownerId !== userId) throw new ForbiddenException();
  return doc;
}

// ❌ NEVER — endpoint without auth (except health check)
@Get('/api/internal/users')  // ← Anyone can access!
async getUsers() { ... }
```

### 6. Error Handling

```typescript
// ❌ NEVER — expose internal details
catch (error) {
  res.status(500).json({
    error: error.message,        // Reveals internals
    stack: error.stack,          // Reveals file paths
    query: sql,                  // Reveals DB structure
  });
}

// ✅ ALWAYS — generic user-facing errors
catch (error) {
  logger.error('User fetch failed', { error, userId }); // Log internally
  res.status(500).json({
    error: 'An unexpected error occurred',
    requestId: req.id, // For support reference
  });
}
```

### 7. CORS Configuration

```typescript
// ❌ NEVER
app.use(cors({ origin: '*' }));

// ✅ ALWAYS — whitelist specific origins
app.use(cors({
  origin: ['https://app.example.com', 'https://admin.example.com'],
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
}));
```

### 8. Rate Limiting

```typescript
// ✅ Rate limit all public endpoints
import rateLimit from 'express-rate-limit';

// General API
app.use('/api/', rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100,
}));

// Login — stricter
app.use('/api/auth/login', rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 5, // 5 attempts per 15 min
}));
```

### 9. Dependency Security

```bash
# Check for known vulnerabilities
npm audit
pip audit

# Must pass before merge — vulnerabilities in dependencies = your vulnerabilities
```

### 10. Logging Rules

```typescript
// ❌ NEVER log sensitive data
logger.info('User login', { email, password });        // ← password!
logger.info('Payment', { cardNumber, cvv });           // ← card data!
logger.info('API call', { headers: req.headers });     // ← auth tokens!

// ✅ ALWAYS — sanitize logs
logger.info('User login', { email, success: true });
logger.info('Payment', { last4: card.slice(-4), amount });
logger.info('API call', { path: req.path, method: req.method });
```

---

## Security Checklist for Every MR

- [ ] Input validation on all endpoints (server-side)
- [ ] Parameterized queries (no string concatenation)
- [ ] XSS prevention (output sanitization + CSP)
- [ ] Authentication on all non-public endpoints
- [ ] Authorization checks (permission + IDOR)
- [ ] Error messages don't leak internals
- [ ] CORS whitelist (no wildcard `*`)
- [ ] Rate limiting on sensitive endpoints
- [ ] `npm audit` / `pip audit` passes
- [ ] No credentials in code, logs, or error responses
- [ ] JWT in httpOnly cookies (not localStorage)
- [ ] Bcrypt ≥10 rounds for password hashing

---

## Integration with QA

QA agents MUST test these 10 security categories:

1. **Injection** — SQL/NoSQL injection in all input fields
2. **Auth Bypass** — Access without token, with expired token
3. **IDOR** — Access other users' resources
4. **Brute Force** — Rate limiting on login/sensitive endpoints
5. **Data Exposure** — API returns only necessary fields
6. **Error Disclosure** — No stack traces or internal paths
7. **CORS** — Only whitelisted origins work
8. **Security Headers** — X-Frame-Options, CSP, HSTS
9. **Dependencies** — `npm audit` clean
10. **Token Storage** — httpOnly cookies, not localStorage

**Security vulnerability = 🔴 Critical — fix before deploy, no exceptions.**

---

*Based on OWASP Top 10 2021, enforced across all AI-generated code in production.*
