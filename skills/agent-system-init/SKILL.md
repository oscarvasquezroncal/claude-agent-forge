---
name: agent-system-init
description: Standardize a repository for multi-agent development with Claude Code. Use this skill whenever the user wants to set up, bootstrap, initialize, or standardize a CLAUDE.md knowledge base plus a specialized subagent pipeline (architecture-analyst, senior engineer, tester, docs-updater) for a codebase — Python, JavaScript, TypeScript, Go, or any structured project. Trigger when the user mentions standardizing agents, initializing agents, "/init-agents", setting up a CLAUDE.md system, generating per-directory CLAUDE.md docs, refreshing stale CLAUDE.md against real code, creating a CLAUDE.md from scratch when none exists, or building a repeatable agent workflow for features. Also trigger when a user has one big CLAUDE.md and wants it split into a root + per-directory structure with agents derived from the real architecture.
---

# Agent System Init

Bootstraps a repository into a standardized multi-agent setup for Claude Code. It produces three things:

1. A created-or-refreshed **CLAUDE.md knowledge base** — a compact root `CLAUDE.md` (global truth, loaded every session) plus per-directory `CLAUDE.md` files (local detail, loaded on demand). **If the repo has no CLAUDE.md, the skill creates a good one from scratch** (see Phase 1B).
2. A **fixed pipeline of 4 subagents** in `.claude/agents/`: `architecture-analyst` → `<lang>-senior` → `tester` → `docs-updater`.
3. An **`AGENTS_GUIDE.md`** that tells the user exactly how to prompt so the agents run in order — including a ready-to-copy, stylized prompt template. This is ALWAYS produced, in every run.

## Honest scope — state this to the user, do not oversell

This skill **standardizes context and enforces a consistent workflow**. By giving agents verified docs, clear specialized roles, and explicit handoffs, it improves consistency and reduces avoidable mistakes. It does **NOT** guarantee bug-free code, and it does not remove the need for code review, tests, or version control. Frame it as "standardization + consistency", never as "error-free development". One successful run on one project is not proof it works identically everywhere.

## Consumption budget — moderate and controlled (important)

The goal is NOT minimum tokens; it is a **moderate, well-structured pass** that avoids a massive crawl.

- Discover with **targeted reads**: manifests, config files, entry points, route/module indexes, and a representative SAMPLE of files per area — not every file in the repo.
- For a large repo, use at most **2–3 focused exploration subagents** in parallel, each with a narrow scope (e.g. "map the API layer", "extract the design system"). For a small/medium repo, do discovery inline with no subagents.
- Never re-read a file you've already read. Batch related reads. Stop exploring an area once you can describe it accurately.
- The init itself should be ONE focused pass, not an open-ended investigation. The 4 agents' model tiers (below) control ongoing cost.

## What "good" looks like

- The root `CLAUDE.md` is **dense and true** — every claim verified against real code (or marked `[UNVERIFIED]`), stale content removed, no filler. It loads on every session, so every line costs tokens forever.
- Per-directory docs exist **only where they earn their tokens** (a complex subsystem), not for trivial/generated folders.
- The 4 agents carry the project's **real conventions and do-not-break constraints**, not generic advice.
- The user finishes with a clear next action: the prompt template in `AGENTS_GUIDE.md`.

---

## The method — phases

Work in order. **The run is autonomous — `/init-agents` completes without stopping for approval.** It prints a brief plan as it goes; the user reviews the result and the git diff afterward, so a commit/stash beforehand is strongly recommended.

### Phase 0 — Detect stack & preflight
- Find build manifests to detect language/framework: `package.json` (Node/TS/JS — note Next.js, React, Vue), `pyproject.toml`/`requirements.txt` (Python — FastAPI, Django, Flask), `go.mod`, `Cargo.toml`, `pom.xml`/`build.gradle`, `composer.json`, etc.
- Record real versions and the primary framework — this names the senior agent (`backend-senior`, `frontend-senior`, `<lang>-senior`) and fills its stack rules.
- **Check whether `CLAUDE.md` already exists** (root, `.claude/CLAUDE.md`, and per-directory). This decides the branch:
  - Exists → **Phase 1A** (audit & refresh).
  - Does not exist → **Phase 1B** (create from scratch with a short interview).
- Tell the user to **commit/stash first** — init only writes docs + agent files, but a clean tree gives a safe rollback point.

### Phase 1A — Audit & gap analysis (repo HAS CLAUDE.md)
- Read every existing `CLAUDE.md` in full. Treat companion docs (ARCHITECTURE.md, audits, READMEs) as **claims to verify, not truth**.
- Map the repository within the consumption budget; for each significant top-level dir determine purpose, key entry points, connections, local conventions, and the core runtime flows.
- **Evidence only.** Anything you can't verify → omit or mark `[UNVERIFIED]`.
- Produce a **gap-analysis checklist**: claims now FALSE/stale; areas that exist in code but are UNDOCUMENTED; documented things that no longer exist; conventions used but unstated.
- **Print the checklist + the planned file list as a brief summary, then proceed directly to Phase 2** — no approval stop. (The run is autonomous; the user reviews the result + the git diff afterward.)

### Phase 1B — Create CLAUDE.md from scratch (repo has NO CLAUDE.md)
This is the path when there is no existing knowledge base. The repo's own code IS the context; infer everything you can and proceed autonomously.

1. **Infer from code** (within the budget): from manifests, entry points, folder names, and a sample of files, derive the project's purpose, stack, main flows, and obvious conventions. Get as far as the code honestly lets you.
2. **Use any context the user already gave** in their invocation (e.g. "this is an Odoo addon repo for X"). For facts the code cannot reveal and the user did not supply — deploy target, business intent, known-fragile areas — **do NOT stop to ask; write your best inference and mark it `[UNVERIFIED]`** so the user can correct it afterward.
3. **Draft the base root `CLAUDE.md`** using the 8-section spec, merging inferred facts + whatever context the user provided. Mark inferred-but-unconfirmed items `[UNVERIFIED]`.
4. **Print a brief summary of the draft + planned per-dir files, then proceed directly to Phase 2** — no approval stop.

### Phase 2 — Write the CLAUDE.md knowledge base
Proceed directly (no approval gate):
- Write/refresh the **root `CLAUDE.md`** per `reference/claude-md-spec.md`. (1A: preserve accurate, update stale, delete false. 1B: write the inferred draft.)
- Create **per-directory `CLAUDE.md`** only for non-trivial directories. Skip generated/trivial dirs (`node_modules`, `.next`, `dist`, `build`, `__pycache__`, egg-info). Each ≤ ~60 lines.
- No duplication: root = global truth, per-dir = local detail.
- **Documentation only during init — do not modify source, configs, or tests.**

### Phase 3 — Generate the 4 agents
- Read the four files in `templates/` (skeletons with `{{PLACEHOLDERS}}`).
- Fill each placeholder from the CLAUDE.md you just produced: real stack, conventions, do-not-break constraints, test framework/commands, known gotchas. **Never ship a file with `{{...}}` left in it — scan each output and confirm zero remain.**
- Name the senior agent after the stack (`backend-senior`, `frontend-senior`, `<lang>-senior`). The file name MUST match its `name:` frontmatter.
- Model tiers (cost control): analyst → `sonnet`, senior → `opus`, tester → `sonnet`, docs-updater → `haiku`. Note the user can adjust.
- Write the four files to `.claude/agents/`.

### Phase 4 — Produce AGENTS_GUIDE.md (always)
- From `templates/AGENTS_GUIDE.template.md`, write `AGENTS_GUIDE.md` at the repo root, filling in the real agent names and the stylized **orchestration prompt template** (the header that makes the 4 agents run in order, wrapping the user's task).
- This is the deliverable the user reads to know how to drive the system. It must contain the copy-ready example prompt.

---

## Hard rules (apply throughout)

1. **Evidence only** — verify against real code; mark uncertainty `[UNVERIFIED]`; never invent.
2. **Init writes only docs + agent files** — never touch source, configs, or tests during initialization.
3. **Token economy in the docs, moderate budget in the process** — dense, high-signal CLAUDE.md; a single focused discovery pass, not a full crawl.
4. **Autonomous run** — `/init-agents` runs end-to-end without an approval stop. Print a brief plan/summary as you go, but do not block; the user reviews the generated files and the git diff afterward. (Because of this, recommending a commit/stash beforehand matters more — make sure the user knows.)
5. **Honest framing** — "standardizes + improves consistency", never "error-free".
6. **Language-agnostic** — adapt the senior agent and conventions to the detected stack.

## Bundled resources

- `reference/claude-md-spec.md` — the 8-section root spec + per-directory rules. Read before Phase 2.
- `templates/architecture-analyst.md`, `templates/senior-engineer.md`, `templates/tester.md`, `templates/docs-updater.md` — agent skeletons. Read before Phase 3.
- `templates/AGENTS_GUIDE.template.md` — the user-facing guide skeleton. Read before Phase 4.
- `commands/init-agents.md` — a slash command that triggers this skill. Tell the user to copy it to `.claude/commands/init-agents.md`.

## Closing the run

End by showing: which CLAUDE.md files were written, the 4 agents created, any `[UNVERIFIED]` items to confirm, and a pointer to `AGENTS_GUIDE.md` with the prompt template. Remind the user to commit when satisfied.