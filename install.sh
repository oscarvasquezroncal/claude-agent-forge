#!/usr/bin/env bash
# claude-agent-forge — manual installer (fallback for the plugin path)
# Installs the agent-system-init skill + the /init-agents command into your Claude Code config.
set -euo pipefail

CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
SKILL_SRC="skills/agent-system-init"
CMD_SRC="commands/init-agents.md"

echo "==> Installing claude-agent-forge into: $CLAUDE_DIR"

if [ ! -d "$SKILL_SRC" ]; then
  echo "ERROR: run this from the repo root (skills/agent-system-init not found)." >&2
  exit 1
fi

mkdir -p "$CLAUDE_DIR/skills/agent-system-init"
cp -R "$SKILL_SRC/." "$CLAUDE_DIR/skills/agent-system-init/"
echo "    skill  -> $CLAUDE_DIR/skills/agent-system-init"

mkdir -p "$CLAUDE_DIR/commands"
cp "$CMD_SRC" "$CLAUDE_DIR/commands/init-agents.md"
echo "    command-> $CLAUDE_DIR/commands/init-agents.md"

echo "==> Done. Restart Claude Code, then run /init-agents inside any repo."