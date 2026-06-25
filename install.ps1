# claude-agent-forge - manual installer for Windows (fallback for the plugin path)
# Installs the agent-system-init skill + the /init-agents command into your Claude Code config.
$ErrorActionPreference = "Stop"

$ClaudeDir = if ($env:CLAUDE_CONFIG_DIR) { $env:CLAUDE_CONFIG_DIR } else { "$env:USERPROFILE\.claude" }
$SkillSrc = "skills\agent-system-init"
$CmdSrc = "commands\init-agents.md"

Write-Host "==> Installing claude-agent-forge into: $ClaudeDir"

if (-not (Test-Path $SkillSrc)) {
  Write-Error "Run this from the repo root (skills\agent-system-init not found)."
  exit 1
}

$SkillDest = Join-Path $ClaudeDir "skills\agent-system-init"
New-Item -ItemType Directory -Force -Path $SkillDest | Out-Null
Copy-Item -Recurse -Force "$SkillSrc\*" $SkillDest
Write-Host "    skill   -> $SkillDest"

$CmdDest = Join-Path $ClaudeDir "commands"
New-Item -ItemType Directory -Force -Path $CmdDest | Out-Null
Copy-Item -Force $CmdSrc (Join-Path $CmdDest "init-agents.md")
Write-Host "    command -> $CmdDest\init-agents.md"

Write-Host "==> Done. Restart Claude Code, then run /init-agents inside any repo."