---
name: agent-system-init
description: Standardize a repository for multi-agent development with Claude Code. Use this skill whenever the user wants to set up, bootstrap, initialize, or standardize a CLAUDE.md knowledge base plus a specialized subagent pipeline (architecture-analyst, senior engineer, tester, docs-updater) for a codebase — Python, JavaScript, TypeScript, Go, or any structured project. Trigger when the user mentions standardizing agents, initializing agents, "/init-agents", setting up a CLAUDE.md system, generating per-directory CLAUDE.md docs, refreshing stale CLAUDE.md against real code, or creating a repeatable agent workflow for building features. Also trigger when a user has one big CLAUDE.md and wants it split into a root + per-directory structure with agents derived from the real architecture.
---

# Agent System Init

Bootstraps a repository into a standardized multi-agent setup for Claude Code. It produces three things:

1. A refreshed/created **CLAUDE.md knowledge base** — a compact root `CLAUDE.md` (global truth, loaded every session) plus per-directory `CLAUDE.md` files (local detail, loaded on demand).
2. A **fixed pipeline of 4 subagents** in `.claude/agents/`: `architecture-analyst` → `<lang>-senior` → `tester` → `docs-updater`.
3. An **`AGENTS_GUIDE.md`** that tells the user exactly how to prompt so the agents run in order — including a ready-to-copy, stylized prompt template.

## Honest scope — state this to the user, do not oversell

This skill **standardizes context and enforces a consistent workflow**. By giving agents verified docs, clear specialized roles, and explicit handoffs, it improves consistency and reduces avoidable mistakes. It does **NOT** guarantee bug-free code, and it does not remove the need for code review, tests, or version control. Frame it as "standardization + consistency", never as "error-free development". One successful run on one project is not proof it works identically everywhere. Keep the promise modest and the user will trust it.

## What "good" looks like

- The root `CLAUDE.md` is **dense and true** — every claim verified against real code, stale content removed, no filler. It loads on every session, so every line costs tokens forever.
- Per-directory docs exist **only where they earn their tokens** (a complex subsystem), not for trivial/generated folders.
- The 4 agents carry the project's **real conventions and do-not-break constraints**, not generic advice.
- The user finishes with a clear next action: the prompt template in `AGENTS_GUIDE.md`.

---

## The method — 5 phases

Work through them in order. **Phase 1 has a mandatory pause.**

### Phase 0 — Detect stack & preflight
- Find build manifests to detect language/framework: `package.json` (Node/TS/JS — note Next.js, React, Vue, etc.), `pyproject.toml`/`requirements.txt` (Python — note FastAPI, Django, Flask), `go.mod`, `Cargo.toml`, `pom.xml`/`build.gradle`, `composer.json`, etc.
- Record real versions and the primary framework — this names the senior agent (`backend-senior`, `frontend-senior`, etc.) and fills its stack rules.
- Check whether `CLAUDE.md` already exists (root and/or `.claude/CLAUDE.md`, and any per-directory ones).
- Tell the user to **commit/stash first** — even though init only writes docs + agent files, a clean tree gives them a safe rollback point.

### Phase 1 — Audit & gap analysis  ⛔ PAUSE AFTER THIS
- Read every existing `CLAUDE.md` in full. Treat companion docs (ARCHITECTURE.md, audits, READMEs) as **claims to verify, not truth**.
- Map the repository: walk top-level directories; for each significant one determine purpose, key entry points, how it connects to the rest, and local conventions. Identify the core runtime flows.
- **Evidence only.** Every future statement must trace to real code/config. If you can't verify it, omit it or mark `[UNVERIFIED]`.
- Produce a **gap-analysis checklist**: claims now FALSE/stale; areas that exist in code but are UNDOCUMENTED; documented things that no longer exist; conventions used but unstated.
- **STOP. Show the checklist and the planned file list. Wait for explicit user approval before writing or editing anything.** This pause is the single most important safety step — it is what prevents deleting valuable content blindly.

### Phase 2 — Generate the CLAUDE.md knowledge base
After approval:
- Write/refresh the **root `CLAUDE.md`** using the 8-section spec in `reference/claude-md-spec.md`. Preserve still-accurate content, update stale, delete false. Keep it compact.
- Create **per-directory `CLAUDE.md`** only for non-trivial directories (judgment call — a complex feature/subsystem, the API layer, core engine, etc.). Skip generated/trivial dirs (`node_modules`, `.next`, `dist`, `build`, `__pycache__`, egg-info). Each ≤ ~60 lines.
- No duplication: root holds global truth, per-dir holds local detail.
- **Documentation only during init — do not modify source, configs, or tests.**

### Phase 3 — Generate the 4 agents
- Read the four files in `templates/`. They are skeletons with `{{PLACEHOLDERS}}`.
- Fill each placeholder from the CLAUDE.md you just produced: the real stack, conventions, do-not-break constraints, test framework/commands, and known gotchas. **Never ship a file with `{{...}}` left in it.**
- Name the senior agent after the stack (`backend-senior`, `frontend-senior`, or `<lang>-senior`).
- Set model tiers for cost: analyst → `sonnet`, senior → `opus`, tester → `sonnet`, docs-updater → `haiku` (note the user can adjust).
- Write the four files to `.claude/agents/`. The file's name MUST match its `name:` frontmatter field.

### Phase 4 — Produce AGENTS_GUIDE.md
- From `templates/AGENTS_GUIDE.template.md`, write `AGENTS_GUIDE.md` at the repo root.
- Fill in the project's agent names and the stylized **orchestration prompt template** (the header that makes the 4 agents run in order, wrapping the user's task).
- This is the deliverable the user reads to know how to drive the system.

---

## Fallback: repos without clear structure or docs

If there is no recognizable manifest AND no existing `CLAUDE.md`:
1. Do a best-effort architecture map from the file tree and obvious entry points.
2. Write a **minimal root `CLAUDE.md`** first, marking inferred items `[UNVERIFIED]` generously, and tell the user it needs their confirmation.
3. Only then derive the agents from that base. Be explicit that quality scales with how structured the repo is — a messy repo yields a rougher first pass that the user should refine.

---

## Hard rules (apply throughout)

1. **Evidence only** — verify against real code; mark uncertainty `[UNVERIFIED]`; never invent.
2. **Init writes only docs + agent files** — never touch source, configs, or tests during initialization.
3. **Token economy** — CLAUDE.md loads every session; write dense, high-signal docs; no filler or marketing.
4. **Mandatory pause** after the Phase 1 gap analysis; get approval before writing.
5. **Honest framing** — "standardizes + improves consistency", never "error-free".
6. **Language-agnostic** — the method works for Python, JS/TS, Go, etc.; adapt the senior agent and conventions to the detected stack.

## Bundled resources

- `reference/claude-md-spec.md` — the 8-section root spec + per-directory rules. Read before Phase 2.
- `templates/architecture-analyst.md`, `templates/senior-engineer.md`, `templates/tester.md`, `templates/docs-updater.md` — agent skeletons. Read before Phase 3.
- `templates/AGENTS_GUIDE.template.md` — the user-facing guide skeleton. Read before Phase 4.
- `commands/init-agents.md` — a slash command that triggers this skill. Tell the user to copy it to `.claude/commands/init-agents.md` in their repo so they can run `/init-agents`.

## Closing the run

End by showing the user: which CLAUDE.md files were written, the 4 agents created, any `[UNVERIFIED]` items they should confirm, and a pointer to `AGENTS_GUIDE.md` with the prompt template. Remind them to commit when satisfied.
