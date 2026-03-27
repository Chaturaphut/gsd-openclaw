# 🔗 Issue Tracker Integrations

Sync your GSD workflow with GitHub Issues or GitLab Issues for full traceability.

## Overview

| File | Description |
|------|-------------|
| `github-issues.md` | Guide + scripts for GitHub Issues integration |
| `gitlab-issues.md` | Guide + scripts for GitLab Issues integration |
| `sync-script.sh` | Universal sync script (auto-detects platform) |

## What It Does

```
REQUIREMENTS.md  ──→  Issues created (one per requirement)
PLAN.md tasks    ──→  Issues linked (comments added)
QA.md passes     ──→  Issues closed automatically
STATE.md phase   ──→  Labels updated per GSD phase
```

## Quick Start

### 1. Set up labels

```bash
# GitHub
./integrations/sync-script.sh --platform github sync-labels

# GitLab
export GITLAB_TOKEN="glpat-xxx"
export GITLAB_PROJECT_ID="12345678"
./integrations/sync-script.sh --platform gitlab sync-labels
```

### 2. Create issues from requirements

```bash
./integrations/sync-script.sh create-issues
```

### 3. Link plan tasks to issues

Reference issues in PLAN.md (`## Task: Implement auth (#12)`), then:

```bash
./integrations/sync-script.sh link-tasks
```

### 4. Close issues on QA pass

Mark tasks with ✅ and issue refs in QA.md, then:

```bash
./integrations/sync-script.sh close-passed
```

### 5. Check sync status

```bash
./integrations/sync-script.sh status
```

## GSD Phase → Label Mapping

| Phase | GitHub Label | GitLab Label |
|-------|-------------|-------------|
| Requirements | `gsd:requirements` | `GSD::Requirements` |
| Research | `gsd:research` | `GSD::Research` |
| Planning | `gsd:planning` | `GSD::Planning` |
| Execution | `gsd:execution` | `GSD::Execution` |
| QA | `gsd:qa` | `GSD::QA` |
| Done | `gsd:done` | `GSD::Done` |
| Blocked | `gsd:blocked` | `GSD::Blocked` |

## Dry Run

Preview changes without executing:

```bash
./integrations/sync-script.sh --dry-run create-issues
# 🔵 Would create: REQ: User authentication
# 🔵 Would create: REQ: Dashboard API
```
