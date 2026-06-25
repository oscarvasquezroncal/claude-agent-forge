# Claude Agent Forge

**Standardize any repository for multi-agent development with Claude Code — in one command.**

`claude-agent-forge` is a [Claude Code](https://www.anthropic.com/claude-code) skill that turns a codebase into a consistent, agent-ready project. It generates a verified `CLAUDE.md` knowledge base by analyzing your repo's real architecture, design patterns, conventions, and dependencies — plus a pipeline of four specialized subagents and a guide that tells you exactly how to prompt them. Works with Python, JavaScript/TypeScript, Go, and any other structured project.

> **Honest scope:** this standardizes context and enforces a consistent workflow. It improves reliability and reduces avoidable mistakes by giving agents verified docs, specialized roles, and explicit handoffs. It does **not** guarantee bug-free code, and it does not replace code review, tests, or version control.

---

## Why this exists

Claude Code already reads your `CLAUDE.md` and writes code. The problem is that, left to grow organically, three things drift:

1. **Docs go stale.** A `CLAUDE.md` written months ago quietly starts lying — wrong versions, missing subsystems, outdated conventions. Agents then build on false assumptions.
2. **One generalist does everything.** A single context handles analysis, implementation, testing, and documentation in one pass, with no separation of concerns.
3. **Knowledge isn't fed back.** Features get built but the docs don't capture what changed, so the drift compounds.

`claude-agent-forge` fixes all three with a repeatable standard: **verified docs + specialized agents + a feedback loop.**

---

## What it produces

Running the skill on a repo creates:

### 1. A `CLAUDE.md` knowledge base
- A **compact root `CLAUDE.md`** (global truth — loaded every session, so every line earns its tokens). It's built from the repo's real architecture, design patterns, conventions, and dependencies — not boilerplate.
- **Per-directory `CLAUDE.md`** files for non-trivial subsystems (local detail — loaded only when an agent works in that folder).
- If the repo has **no `CLAUDE.md`**, the skill creates a good one from scratch: it infers what it can from the code, uses any context you provide, and marks anything it can't verify as `[UNVERIFIED]` for you to confirm.

### 2. A four-agent pipeline (`.claude/agents/`)

```
architecture-analyst  →  <lang>-senior  →  tester  →  docs-updater
     (understand)          (implement)      (prove)     (document)
```

| Agent | Model | Role |
|-------|-------|------|
| `architecture-analyst` | sonnet | Maps which files the task touches, verifies claims against real code, surfaces do-not-break constraints. Writes no code. |
| `<lang>-senior` | opus | Implements production-grade code following the repo's real conventions. Flags `DOCS UPDATE REQUIRED` for significant changes. |
| `tester` | sonnet | Writes and **actually runs** the relevant tests; a red suite blocks progress. |
| `docs-updater` | haiku | Updates the `CLAUDE.md` knowledge base — only when the change is architecturally significant. |

Each agent is filled with **your project's real stack, conventions, and constraints** — not generic advice.

### 3. `AGENTS_GUIDE.md`
A guide at your repo root explaining how to drive the pipeline, including a **copy-ready, stylized prompt template** that runs the four agents in order around any task you give them.

---

## How it works — the method

The skill runs a focused, moderate-consumption pass (targeted reads and at most a couple of scoped explorers — never a full-repo crawl), end to end, autonomously:

| Phase | What happens |
|-------|--------------|
| **0 — Detect** | Reads the build manifest, identifies language/framework and versions, checks whether a `CLAUDE.md` already exists. |
| **1A — Audit** *(docs exist)* | Verifies every existing claim against real code, prints a brief gap-analysis summary, then continues. |
| **1B — Create** *(no docs)* | Infers a base from the code and any context you gave, marking unverifiable items `[UNVERIFIED]`, then continues. |
| **2 — Write docs** | Writes the root + per-directory `CLAUDE.md`. Evidence-only; stale content removed; unconfirmed items marked `[UNVERIFIED]`. |
| **3 — Generate agents** | Fills the four agent templates with your real stack and constraints, writes them to `.claude/agents/`. |
| **4 — Guide** | Produces `AGENTS_GUIDE.md` with the prompt template. |

**The run is autonomous** — it prints a brief plan as it goes and reports any `[UNVERIFIED]` items at the end. Because nothing pauses for approval, **commit (or stash) before running** so you have a clean rollback point, and **review the git diff afterward**.

---

## Installation

### Option 1 — Claude Code plugin (recommended, two commands)

Inside Claude Code, from any repo:

```
/plugin marketplace add https://github.com/oscarvasquezroncal/claude-agent-forge
/plugin install claude-agent-forge@claude-agent-forge
```

Restart Claude Code, then run `/init-agents` in any project.

### Option 2 — Manual install (fallback)

```bash
git clone https://github.com/oscarvasquezroncal/claude-agent-forge.git
cd claude-agent-forge

# macOS / Linux
./install.sh

# Windows PowerShell
.\install.ps1
```

This copies the skill into `~/.claude/skills/agent-system-init` and the `/init-agents` command into `~/.claude/commands/`. Restart Claude Code afterward.

> Requires Claude Code. Tested manually; treat early runs as a first pass and review the output.

---

## Usage

Inside any repository, in Claude Code:

```
/init-agents
```

or just ask in natural language:

> "Standardize this repo with the agent system."

The skill will detect your stack, audit (or create) the `CLAUDE.md`, print a brief plan as it goes, then generate the docs, the four agents, and `AGENTS_GUIDE.md`.

### Then, to build a feature

Open `AGENTS_GUIDE.md` and use the prompt template — it wraps your task with the orchestration header so the four agents run in order. In short:

```
Execute the TASK below using the .claude/agents/ pipeline IN ORDER:
1. architecture-analyst — map and verify; no code.
2. <lang>-senior — implement, following the briefing and repo conventions.
3. tester — write and RUN the tests; report real results.
4. docs-updater — update CLAUDE.md only if a significant change was made.

=== TASK ===
[ describe what you want built, with any hard rules and the tests you expect ]
```

---

## Recommended practice

- **Commit before each run.** The agents edit files; you want a rollback point. (Initialization itself only writes docs + agent files.)
- **Review the git diff afterward.** The run is autonomous, so the diff is your safety net.
- **Start small.** Run a tiny task first to watch the handoff behave and gauge token cost.
- **Tune cost.** The senior agent runs on the most expensive model by design — drop its `model:` field to a cheaper tier to economize. Use `/clear` between unrelated tasks and `/usage` to track spend.
- **Trust the code over the docs.** If an agent reports a divergence between `CLAUDE.md` and reality, the code wins — let `docs-updater` fix the doc.

---

## Repository layout

```
claude-agent-forge/
├── .claude-plugin/
│   ├── plugin.json                   # plugin manifest
│   └── marketplace.json              # marketplace catalog
├── commands/
│   └── init-agents.md                # the /init-agents slash command
├── skills/
│   └── agent-system-init/
│       ├── SKILL.md                  # the method: phases + rules
│       ├── reference/
│       │   └── claude-md-spec.md     # root (8-section) + per-dir CLAUDE.md spec
│       └── templates/
│           ├── architecture-analyst.md
│           ├── senior-engineer.md
│           ├── tester.md
│           ├── docs-updater.md
│           └── AGENTS_GUIDE.template.md
├── install.sh                        # manual installer (macOS/Linux)
├── install.ps1                       # manual installer (Windows)
├── LICENSE
├── CHANGELOG.md
└── CONTRIBUTING.md
```

---

## Status & roadmap

This is an early release built from a real, working pattern. It has **not yet been benchmarked across many repositories**, so:

- Treat the first run on a new stack as a first pass and review the generated docs and agents.
- The most likely rough edge is an unfilled `{{placeholder}}` in a generated agent — the skill is instructed to leave none, but check.

Done so far: Claude Code plugin distribution (v0.1.0).
Planned: evaluation across multiple stacks (Python / TS / messy repos), optional stack-specific specialist agents, and a companion command to refresh docs on an already-initialized repo.

Contributions and issues welcome — see [CONTRIBUTING.md](CONTRIBUTING.md).

---

## License

[MIT](LICENSE) © 2026 Oscar Vasquez Roncal