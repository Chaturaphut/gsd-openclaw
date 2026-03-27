# 🔧 CI/CD Pipeline Templates

Pre-built CI/CD pipelines that integrate GSD workflow gates into your existing CI system.

## What's Included

| File | Platform | Description |
|------|----------|-------------|
| `github-actions.yml` | GitHub Actions | Full pipeline with 6 stages |
| `gitlab-ci.yml` | GitLab CI | Equivalent pipeline for GitLab |

## Pipeline Stages

Both templates include:

1. **🔍 Lint & Format** — Code quality checks
2. **🧪 Test Suite** — Run tests with coverage
3. **📋 GSD Plan Verification** — Ensures `.planning/` structure is valid:
   - `REQUIREMENTS.md` exists
   - `PLAN.md` exists for Full GSD (>3 files changed)
   - Task sizing validation (Fast/Quick/Full)
4. **🔍 Stub Detection** — Scans source code for `TODO`, `FIXME`, `HACK`, `PLACEHOLDER`, `// stub`
5. **🔒 Security Scan** — Detects leaked secrets (AWS keys, API tokens, PATs, passwords)
6. **🔄 Regression Gate** — Full test suite on PRs to catch cross-phase regressions

## Quick Start

### GitHub Actions

```bash
# Copy to your project
mkdir -p .github/workflows
cp ci-templates/github-actions.yml .github/workflows/gsd-ci.yml
```

### GitLab CI

```bash
# Copy to your project root
cp ci-templates/gitlab-ci.yml .gitlab-ci.yml
```

## Customization

### Change Node Version

```yaml
# GitHub Actions
env:
  NODE_VERSION: '22'

# GitLab CI
variables:
  NODE_VERSION: "22"
```

### Add Source Directories for Stub Detection

Both templates scan these directories by default:
```
src/ lib/ app/ components/ pages/ api/ services/
```

To customize, edit the `SCAN_DIRS` variable in the stub-detection job.

### Add File Extensions for Scanning

Both templates scan common languages:
```
*.ts *.tsx *.js *.jsx *.py *.go *.rs *.java *.rb *.php
```

### Customize Secret Patterns

Add your own patterns to the security scan job:
```yaml
# Example: Detect custom API key format
PATTERNS+=('myapp_key_[a-zA-Z0-9]{32}')
```

### Skip GSD Checks for Non-GSD Projects

The plan verification stage automatically skips if no `.planning/` directory exists.

## Integration with GSD Workflow

These pipelines enforce the GSD methodology in CI:

```
Developer creates PR
        │
        ▼
┌─── Lint & Format ────┐
│   Code quality OK?    │──── ❌ Fix code
│                       │
└───────┬───────────────┘
        │ ✅
        ▼
┌─── Test Suite ────────┐
│   Tests passing?      │──── ❌ Fix tests
│                       │
└───────┬───────────────┘
        │ ✅
        ▼
┌─── GSD Verification ─┐
│   Plan exists?        │──── ❌ Create plan
│   Right task size?    │     (if Full GSD needed)
│                       │
└───────┬───────────────┘
        │ ✅
        ▼
┌─── Stub Detection ───┐
│   No TODOs in src?    │──── ❌ Remove stubs
│                       │
└───────┬───────────────┘
        │ ✅
        ▼
┌─── Security Scan ────┐
│   No leaked secrets?  │──── ❌ Remove secrets
│                       │
└───────┬───────────────┘
        │ ✅
        ▼
┌─── Regression Gate ──┐
│   All tests pass?     │──── ❌ Fix regressions
│                       │
└───────┬───────────────┘
        │ ✅
        ▼
    ✅ Ready to merge
```

## Examples

### PR with Full GSD (>3 files changed)
```
📋 GSD Plan Verification:
  ✅ REQUIREMENTS.md found
  ✅ PLAN-01.md found in phases/phase-1/
  ✅ 12 files changed — Full GSD plan verified
```

### PR with Quick Mode (≤3 files)
```
📋 GSD Plan Verification:
  ✅ REQUIREMENTS.md found
  ⚠️ No PLAN.md found — checking task size
  ✅ 2 files changed — Quick mode acceptable
```

### Stub Detection Failure
```
🔍 Stub Detection:
  ❌ Stubs found:
  src/api/auth.ts:42: // TODO: implement refresh token
  src/services/email.ts:15: throw new Error('Not implemented')
  Found 2 stub(s) — fix before merging
```
