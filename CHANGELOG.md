# Changelog

All notable changes to GSD-OpenClaw will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

[1.1.0]: https://github.com/Chaturaphut/gsd-openclaw/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/Chaturaphut/gsd-openclaw/releases/tag/v1.0.0
