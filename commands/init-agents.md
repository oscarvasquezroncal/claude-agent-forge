---
description: Standardize this repo — generate the CLAUDE.md knowledge base and the 4-agent pipeline (runs autonomously).
---

Use the `agent-system-init` skill to standardize this repository for multi-agent development. Run its full method autonomously, end to end, without stopping for approval:

1. Detect the stack and check for an existing CLAUDE.md.
2. Audit the architecture (or, if no CLAUDE.md exists, infer the base from the code). Print a brief gap-analysis/plan summary as you go — but do NOT stop for approval; proceed.
3. Generate/refresh the root + per-directory CLAUDE.md, create the 4 agents in `.claude/agents/`, and write `AGENTS_GUIDE.md`.
4. At the end, report what was written and any `[UNVERIFIED]` items for me to confirm, and remind me to review the git diff.

Follow the skill's hard rules: evidence only (mark unverifiable items `[UNVERIFIED]`), docs + agent files only (do not modify source during init), and be honest about scope (this standardizes and improves consistency — it does not guarantee error-free code).

Note: since this runs without an approval gate, it's best to `git commit` or stash before running so there's a clean rollback point.