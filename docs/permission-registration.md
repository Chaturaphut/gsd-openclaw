# 🔐 Permission Registration Pattern

> **Rule:** Every new endpoint MUST register its permission. No permission = security hole.

When AI agents create new API endpoints, they often forget the permission layer. The code works, the feature looks great — but anyone with a valid token can access anything. This guide ensures every endpoint is locked down from day one.

---

## The 4-Point Permission Registration

Every time a new feature/endpoint/page is added, ALL 4 points must be completed:

### 1. Permission Constants

Define the permission key, label, description, and category:

```typescript
// permissions.constants.ts
export const PERMISSIONS = {
  // ... existing permissions ...

  // New feature permissions
  REPORT_VIEW: {
    key: 'report.view',
    label: 'View Reports',
    description: 'Can view analytics and reports',
    category: 'Reports',
  },
  REPORT_EXPORT: {
    key: 'report.export',
    label: 'Export Reports',
    description: 'Can export reports to CSV/PDF',
    category: 'Reports',
  },
} as const;
```

### 2. Controller Guards

Every endpoint gets a permission decorator:

```typescript
// reports.controller.ts
@Controller('reports')
export class ReportsController {

  @Get('/')
  @RequirePermission(PERMISSIONS.REPORT_VIEW.key)
  async getReports() { ... }

  @Get('/export')
  @RequirePermission(PERMISSIONS.REPORT_EXPORT.key)
  async exportReport() { ... }

  // ❌ NEVER — unprotected endpoint
  @Get('/internal-data')
  async getInternalData() { ... }  // ← SECURITY HOLE
}
```

### 3. Sidebar/Menu Config

If the feature has a UI page, add the permission requirement to menu config:

```typescript
// menu.config.ts
{
  label: 'Reports',
  icon: BarChart,
  path: '/reports',
  requiredPermission: 'report.view',  // ← This controls visibility
  children: [
    {
      label: 'Export',
      path: '/reports/export',
      requiredPermission: 'report.export',
    },
  ],
}
```

### 4. Role Management UI

Verify the new permission appears in the Role Management page so admins can assign it:

```
Admin → Settings → Roles → Edit Role → 
  ✅ "Reports" category visible
  ✅ "View Reports" checkbox available
  ✅ "Export Reports" checkbox available
  ✅ Saving role with new permissions works
```

---

## Permission Naming Convention

```
<module>.<action>

Examples:
  user.view           — View users list
  user.create         — Create new users
  user.edit           — Edit existing users
  user.delete         — Delete users
  report.view         — View reports
  report.export       — Export reports
  setting.manage      — Manage system settings
  ticket.assign       — Assign tickets to agents
```

---

## MR Checklist

Before merging any MR that adds new endpoints:

- [ ] Permission key defined in `permissions.constants.ts`
- [ ] `@RequirePermission()` decorator on every new endpoint
- [ ] Menu config includes `requiredPermission` (if UI page)
- [ ] New permission appears in Role Management UI
- [ ] No endpoints are publicly accessible (except health check)
- [ ] IDOR check: endpoints verify resource ownership, not just permission

---

## Testing

QA agents must verify:

```
1. Access endpoint WITHOUT permission → 403 Forbidden ✅
2. Access endpoint WITH permission → 200 OK ✅
3. Access endpoint without ANY auth → 401 Unauthorized ✅
4. New permission visible in Role Management → ✅
5. Assign permission to role → Role gains access → ✅
6. Remove permission from role → Role loses access → ✅
```

---

## Common Mistakes

| Mistake | Impact | Fix |
|---------|--------|-----|
| Endpoint without `@RequirePermission` | Anyone with token can access | Add decorator |
| Permission defined but not in Role UI | Admins can't assign it | Check category registration |
| Menu visible without permission check | Users see pages they can't access | Add `requiredPermission` to menu |
| IDOR: permission check but no ownership check | User A can access User B's data | Add ownership verification |
| Hardcoded admin bypass | "Admin" role skips all checks | Use permission system for admins too |

---

*Zero unauthorized access incidents since adoption across 60+ API endpoints.*
