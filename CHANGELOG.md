# Changelog

All notable changes to GSD-OpenClaw will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.5.0] - 2026-03-27

### Added
- **Pre-built CI/CD Pipeline Templates** — GitHub Actions and GitLab CI workflows with GSD-integrated stages: lint, test, plan verification, stub detection, security scan, regression gate (`ci-templates/`)
- **GitHub/GitLab Issue Integration** — Auto-create issues from REQUIREMENTS.md, link to PLAN.md tasks, auto-close on QA pass, universal sync script with platform auto-detection (`integrations/`)
- **Auto-Plan Generation** — Script and AI prompt template to generate draft PLAN.md from REQUIREMENTS.md and RESEARCH.md, with validation checklist (`tools/auto-plan/`)
- **Agent Performance Analytics** — Metrics collector analyzing .planning/ artifacts for phase completion, QA pass rate, rework cycles, regressions, handoff quality; outputs text/markdown/JSON (`tools/analytics/`)
- **Workflow Visualization Tools** — Mermaid diagram generator (flowchart, gantt, state, wave) and terminal dashboard with progress bars, watch mode (`tools/visualize/`)
- **Interactive Workflow Dashboard** — Single-file HTML dashboard (no build required) with dark theme, responsive design, data import via file/paste/sample (`dashboard/`)
- **OpenClaw Skill Package** — AgentSkill definition for ClawHub auto-install with post-install script (`skill/`)

### Changed
- Document version bumped to 1.5.0
- All 7 roadmap items completed

## [1.4.0] - 2026-03-27

### Added
- **Advisor Mode** — Lightweight parallel agent analysis for gray areas before decisions (cherry-picked from GSD v1.27)
- **Milestone Summary** — Post-build onboarding and feature summaries for completed milestones (from GSD v1.28)
- **Decision Waiting Signal** — `WAITING.json` machine-readable signal for decision points (from GSD v1.26)
- **Plant Seed / Persistent Threads** — Backlog and context thread persistence in `.planning/seeds/` (from GSD v1.27)
- **New Templates** — Added `MILESTONE-SUMMARY.md`, `WAITING.json`, and `CONTEXT.md` to `templates/`
- **Updated Plan Template** — Added `Read First` and `Acceptance Criteria` sections (from GSD v1.23)

### Changed
- Document version bumped to 1.4

## [1.3.0] - 2026-03-26

### Added
- **Wave Execution Guide** — Patterns for parallel agent orchestration and dependency management
- **Agent Skill Injection** — Inject project-specific skills into sub-agents via config (cherry-picked from GSD v1.29)
- **UI-Phase and UI-Review Steps** — Formalized autonomous workflow steps for frontend (from GSD v1.29)
- **Security Scanning CI** — Automated prompt injection and secret scanning (from GSD v1.29)

### Changed
- Document version bumped to 1.3

## [1.2.0] - 2026-03-26

### Added
- **Credential Security Guide** — Git-leaks integration, pre-commit scanning, config patterns, emergency response
- **Git Branch Flow Guide** — Protected branches, Conventional Commits, MR workflow, branch naming
- **QA Standards Guide** — Complete 10-section QA report framework with UI clickthrough, responsive, security testing
- **Secure Coding Guide** — OWASP Top 10 adapted for AI-generated code with TypeScript examples
- **Agent Delegation Guide** — Orchestration patterns, wave execution, model assignment strategy, communication templates
- **Permission Registration Guide** — 4-point pattern ensuring every endpoint is locked down
- **Docker Deploy Guide** — Compose-first standards, deploy scripts, health checks
- **Unit Testing Guide** — Coverage requirements, AAA pattern, mocking strategies
- **Context Management Guide** — Memory architecture, document size limits, preventing context rot
- **Error Handling Guide** — Retry-before-report, model fallback strategy, user-facing error standards

## [1.1.0] - 2026-03-26

### Added
- **Session Handoff Protocol** — `HANDOFF.json` for clean agent-to-agent context transfer (cherry-picked from GSD v1.26)
- **Cross-Phase Regression Gate** — QA must run previous phase test suites after execution (from GSD v1.26)
- **Requirements Coverage Gate** — Plan verification ensures every requirement maps to a task (from GSD v1.26)
- **Stub Detection** — Catches TODO/FIXME/placeholder code before production (from GSD v1.27)
- **Fast Mode** — 3-tier task sizing: Fast (1 file, ≤20 lines) / Quick (≤3 files) / Full GSD (from GSD v1.27)
- **Workstream Namespacing** — Parallel milestone work without `.planning/` conflicts (from GSD v1.28)
- **Post-Mortem Forensics** — Structured investigation when workflows go wrong (from GSD v1.28)
- **Upstream GSD Tracking** — Automated weekly checks for new GSD releases

### Changed
- Document version bumped to 1.1

## [1.0.0] - 2026-03-22

### Added
- Initial GSD-OpenClaw workflow adapted from [GSD](https://github.com/gsd-build/get-shit-done) for OpenClaw multi-agent architecture
- Core 5-stage workflow: Requirements → Research → Plan → Execute → QA
- Wave-based parallel execution with dependency tracking
- Document system: PROJECT.md, REQUIREMENTS.md, ROADMAP.md, STATE.md
- Per-phase documents: CONTEXT, RESEARCH, PLAN, UI-SPEC, SUMMARY, QA
- Quick Mode for small tasks (≤3 files, no new API)
- Stage 0: Codebase mapping for brownfield projects
- Role-based ownership: Coordinator, SA, Dev Pool, QA Pool, UX Pool
- Context size limits to prevent context window overflow
- Plan verification checklist
- Integration rules with existing Git, QA, Docker, and permission workflows

[1.4.0]: https://github.com/Chaturaphut/gsd-openclaw/compare/v1.3.0...v1.4.0
[1.3.0]: https://github.com/Chaturaphut/gsd-openclaw/compare/v1.2.0...v1.3.0
[1.2.0]: https://github.com/Chaturaphut/gsd-openclaw/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/Chaturaphut/gsd-openclaw/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/Chaturaphut/gsd-openclaw/releases/tag/v1.0.0
