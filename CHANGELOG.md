# Changelog

All notable changes to GSD-OpenClaw will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

[1.2.0]: https://github.com/Chaturaphut/gsd-openclaw/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/Chaturaphut/gsd-openclaw/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/Chaturaphut/gsd-openclaw/releases/tag/v1.0.0
