#!/usr/bin/env bash
# Installs product-design skills and agent into Claude Code (~/.claude/)

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

mkdir -p "$HOME/.claude/skills"
mkdir -p "$HOME/.claude/agents"

create_symlink() {
  local target="$1"
  local link="$2"
  [ -L "$link" ] && rm "$link"
  ln -s "$target" "$link"
  echo "  ✓ $(basename "$link")"
}

echo "Installing skills..."
create_symlink "$SCRIPT_DIR/skills/ux-market-research" "$HOME/.claude/skills/ux-market-research"
create_symlink "$SCRIPT_DIR/skills/problem-framing"    "$HOME/.claude/skills/problem-framing"
create_symlink "$SCRIPT_DIR/skills/user-journey"       "$HOME/.claude/skills/user-journey"
create_symlink "$SCRIPT_DIR/skills/wireframing"        "$HOME/.claude/skills/wireframing"
create_symlink "$SCRIPT_DIR/skills/prototype"          "$HOME/.claude/skills/prototype"
create_symlink "$SCRIPT_DIR/skills/design-tokens"      "$HOME/.claude/skills/design-tokens"
create_symlink "$SCRIPT_DIR/skills/design-qa"          "$HOME/.claude/skills/design-qa"
create_symlink "$SCRIPT_DIR/skills/ui-polish"          "$HOME/.claude/skills/ui-polish"

echo "Installing agent..."
create_symlink "$SCRIPT_DIR/agents/product-design.md"  "$HOME/.claude/agents/product-design.md"

echo ""
echo "Done. Restart Claude Code to load the new skills and agent."
