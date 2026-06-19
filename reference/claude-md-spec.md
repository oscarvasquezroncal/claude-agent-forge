# CLAUDE.md Spec — root + per-directory

The structure the skill writes. Adapt section content to the detected stack; keep the section order.

## Root CLAUDE.md — 8 sections (always)

1. **Project Overview** — 3-5 lines: what the system does, who it serves, deploy target.
2. **Architecture Map** — compact tree or table of top-level dirs, one-line responsibility each, plus the main runtime flow(s) (e.g. request → layer → layer → store). Pointers to per-dir CLAUDE.md.
3. **Tech Stack** — language + framework + datastores + infra, with versions taken from the manifest (authoritative). Note anything pinned for a reason.
4. **Key Commands (verified)** — install, run, test, build, lint, typecheck, migrate, deploy. Copy commands exactly from scripts/CI. Mark `[UNVERIFIED]` if not confirmable.
5. **Conventions & Patterns** — the patterns the code ACTUALLY uses (async/sync, typing, error handling, where business logic lives, naming, test layout, import rules).
6. **Critical Constraints ("do not break")** — public contracts (API routes, exported interfaces), invariants, env assumptions, ordering requirements, things that have caused bugs before. Mine audit docs for these.
7. **Subagent Pipeline** — one line: `.claude/agents/` holds analyst → senior → tester → docs-updater, and that this file is their ground truth.
8. **Known Issues / Active Work** — short, factual, dated (e.g. "as of YYYY-MM-DD"). If none, say so.

Frontend projects add a **Design System & UI/UX** section (tokens/brand colors, fonts, theme/dark-mode, component library, and the animation stack — library, where it lives, shared variants/easings).

## Per-directory CLAUDE.md — only where it earns its tokens

Create for non-trivial directories (a complex subsystem, the API layer, the core engine, a major feature module). SKIP generated/trivial dirs: `node_modules`, `.next`, `dist`, `build`, `__pycache__`, `*.egg-info`, asset folders.

Each ≤ ~60 lines: purpose; key files/entry points; how it interacts with the rest of the system; local conventions; gotchas. If a directory is self-evident, do NOT create a file for it. Never duplicate root content — link to it.

## Style

- Terse, technical, bullet-dense. No emojis, no hype, no filler.
- Concrete paths and names (`src/api/client.ts`), never vague references ("the main module").
- Dates on time-sensitive entries.
- Evidence only; `[UNVERIFIED]` for anything not confirmed in code.
