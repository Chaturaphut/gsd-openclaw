# 🧪 Unit Testing Standards

> **Rule:** Every function and endpoint MUST have unit tests. No tests = no merge.

AI agents are prolific code writers but reluctant test writers. Left to their own devices, they'll ship a feature with zero tests and call it "done." This guide ensures testable, tested code.

---

## Coverage Requirements

| Code Type | Minimum Coverage |
|-----------|-----------------|
| Business logic | ≥ 80% |
| Security-critical code | ≥ 90% |
| Utility functions | ≥ 90% |
| API endpoints | ≥ 80% |
| UI components | ≥ 70% |

## What to Test

### Every Test Must Cover:

1. **Happy path** — Normal input → expected output
2. **Edge cases** — Boundary values, empty input, max values
3. **Error cases** — Invalid input, missing data, network failures

### Test Structure (AAA Pattern)

```typescript
describe('UserService', () => {
  describe('createUser', () => {
    // Happy path
    it('should create a user with valid data', async () => {
      // Arrange
      const input = { email: 'test@example.com', name: 'Test User' };

      // Act
      const result = await userService.createUser(input);

      // Assert
      expect(result).toBeDefined();
      expect(result.email).toBe(input.email);
    });

    // Edge case
    it('should trim whitespace from email', async () => {
      const result = await userService.createUser({
        email: '  test@example.com  ',
        name: 'Test',
      });
      expect(result.email).toBe('test@example.com');
    });

    // Error case
    it('should throw on duplicate email', async () => {
      await userService.createUser({ email: 'dup@test.com', name: 'First' });
      await expect(
        userService.createUser({ email: 'dup@test.com', name: 'Second' })
      ).rejects.toThrow('Email already exists');
    });

    // Error case
    it('should throw on invalid email format', async () => {
      await expect(
        userService.createUser({ email: 'not-an-email', name: 'Test' })
      ).rejects.toThrow();
    });
  });
});
```

### Mock External Dependencies

```typescript
// ✅ Mock database calls
const mockUserRepo = {
  findOne: jest.fn(),
  save: jest.fn(),
  delete: jest.fn(),
};

// ✅ Mock external APIs
jest.mock('../services/email', () => ({
  sendEmail: jest.fn().mockResolvedValue({ success: true }),
}));

// ✅ Mock time for time-dependent logic
jest.useFakeTimers();
jest.setSystemTime(new Date('2026-01-01'));
```

---

## Naming Convention

```
describe('[Module/Class]', () => {
  describe('[method]', () => {
    it('should [expected behavior] when [condition]', () => {});
  });
});
```

**Examples:**
```
✅ it('should return 401 when token is expired')
✅ it('should create user when all fields are valid')
✅ it('should throw ValidationError when email is empty')
❌ it('test create user')        — too vague
❌ it('works')                   — meaningless
```

---

## Pre-Merge Checklist

- [ ] `npm test` passes with zero failures
- [ ] Coverage meets minimum thresholds
- [ ] New functions have corresponding tests
- [ ] Tests cover happy path + edge cases + error cases
- [ ] External dependencies are mocked
- [ ] No flaky tests (time-dependent, order-dependent)
- [ ] Test names clearly describe what they test

---

*Required for every MR across all projects. Zero untested code in production.*
