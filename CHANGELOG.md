# Changelog

All notable changes to this project are documented here.
This project follows [Semantic Versioning](https://semver.org/).

## [0.1.0] - 2026-06
### Added
- Initial public release of the `agent-system-init` skill.
- `/init-agents` slash command — runs the full method autonomously (no approval gate).
- Generates a verified `CLAUDE.md` knowledge base (root + per-directory) by analyzing the repo's real architecture, design patterns, conventions, and dependencies.
- Creates the fixed 4-agent pipeline in `.claude/agents/`: `architecture-analyst` (sonnet), `<lang>-senior` (opus), `tester` (sonnet), `docs-updater` (haiku).
- Produces `AGENTS_GUIDE.md` with a copy-ready orchestration prompt template.
- Handles repos with no existing `CLAUDE.md` by inferring a base from the code and marking unverifiable items `[UNVERIFIED]`.
- Claude Code plugin packaging (`.claude-plugin/`) for one-command install via `/plugin marketplace add` + `/plugin install`.
- Manual installers: `install.sh` (macOS/Linux) and `install.ps1` (Windows).

### Notes
- Early release. Validated on real repositories (including an Odoo 17 addon project, where it surfaced a latent dependency issue) but not yet benchmarked across many stacks. Review generated output and check for any unfilled `{{placeholders}}`.