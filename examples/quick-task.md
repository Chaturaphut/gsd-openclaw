# Example: Quick Task

> Use Quick Mode when: ≤3 files, no new API endpoints

## Quick Task: Fix date formatting in user profile

- **Files:** `src/components/UserProfile.tsx`
- **Action:**
  1. Import `format` from `date-fns`
  2. Replace `new Date(user.createdAt).toString()` with `format(new Date(user.createdAt), 'dd MMM yyyy')`
  3. Add locale support: `import { th } from 'date-fns/locale'`
- **Verify:**
  - Profile page shows "26 Mar 2026" instead of raw date string
  - Thai locale shows "26 มี.ค. 2569" when locale is `th`
- **Done When:** Date displays in human-readable format on both locales
