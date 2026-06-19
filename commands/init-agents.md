---
description: Standardize this repo — generate the CLAUDE.md knowledge base and the 4-agent pipeline.
---

Use the `agent-system-init` skill to standardize this repository for multi-agent development.

Run its full method:
1. Detect the stack and check for existing CLAUDE.md.
2. Audit the architecture and produce a gap-analysis checklist — then STOP and wait for my approval before writing anything.
3. After I approve: generate/refresh the root + per-directory CLAUDE.md, create the 4 agents in `.claude/agents/`, and write `AGENTS_GUIDE.md`.

Follow the skill's hard rules: evidence only, docs + agent files only (do not modify source during init), and be honest about scope (this standardizes and improves consistency — it does not guarantee error-free code).
