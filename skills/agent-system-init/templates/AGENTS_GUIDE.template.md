# Agent System — How to Use ({{PROJECT_NAME}})

This repo is standardized for multi-agent development with Claude Code. Four specialized subagents live in `.claude/agents/`, and the CLAUDE.md knowledge base is their ground truth.

## The pipeline

```
{{ANALYST_NAME}}  →  {{SENIOR_NAME}}  →  {{TESTER_NAME}}  →  {{DOCS_NAME}}
   (understand)        (implement)         (prove)            (document)
```

- **{{ANALYST_NAME}}** — reads the CLAUDE.md + maps which files the task touches; surfaces do-not-break constraints. Writes no code.
- **{{SENIOR_NAME}}** — implements, following the briefing and the repo's real conventions. Flags `DOCS UPDATE REQUIRED` for big changes.
- **{{TESTER_NAME}}** — writes and actually runs the relevant tests; blocks progress on a red suite.
- **{{DOCS_NAME}}** — updates the CLAUDE.md only when the change is architecturally significant.

## Why it works

The agents don't add a magic new capability — Claude Code already reads CLAUDE.md and implements. What this adds is **consistency**: verified docs the agents trust, specialized roles instead of one generalist, explicit handoffs, and a feedback loop that keeps the docs from going stale. It improves reliability; it does not replace your review, tests, or git.

## How to prompt (copy this header above your task)

```
Execute the TASK below using the .claude/agents/ pipeline IN ORDER. Honor every
invariant and constraint in the TASK over anything else.

1. {{ANALYST_NAME}} — verify the relevant files/claims against the real repo and
   produce the briefing. Do NOT code. STOP and surface any conflict with a core
   constraint before implementation.
2. {{SENIOR_NAME}} — implement the TASK following the briefing and the repo's
   conventions. Hand off to the tester after each logical part. On handoff, state
   files changed, new flags/contracts, and whether DOCS UPDATE REQUIRED.
3. {{TESTER_NAME}} — write and RUN the relevant tests; report real pass/fail
   counts. A red suite blocks progress — hand failures back to the senior.
4. {{DOCS_NAME}} — only if DOCS UPDATE REQUIRED was emitted, update the relevant
   CLAUDE.md (docs only).

=== TASK ===
[ describe what you want built/changed here — be specific. Include any invariants,
  hard rules (e.g. no git ops, local tests only), the work itself, and the tests
  you expect. ]
```

## Before each run
- `git commit` (or stash) first — the agents edit files; you want a rollback point.
- Start with a SMALL task the first time, to see the handoff behave and gauge token cost.
- For big tasks, run one part, confirm it's green, then continue.

## Cost tips
- The senior runs on the most expensive model by design; drop it to a cheaper tier if you want to economize (edit its `model:` field).
- Use `/clear` between unrelated tasks; check spend with `/usage`.

## Files
- Agents: `.claude/agents/{{ANALYST_NAME}}.md`, `{{SENIOR_NAME}}.md`, `{{TESTER_NAME}}.md`, `{{DOCS_NAME}}.md`
- Knowledge base: root `CLAUDE.md` + per-directory `CLAUDE.md` files
