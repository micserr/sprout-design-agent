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
create_symlink "$SCRIPT_DIR/skills/prd-gap-analyzer"   "$HOME/.claude/skills/prd-gap-analyzer"
create_symlink "$SCRIPT_DIR/skills/prd-ux-validator"   "$HOME/.claude/skills/prd-ux-validator"
create_symlink "$SCRIPT_DIR/skills/secondary-research" "$HOME/.claude/skills/secondary-research"
create_symlink "$SCRIPT_DIR/skills/user-journey"       "$HOME/.claude/skills/user-journey"
create_symlink "$SCRIPT_DIR/skills/prototype"          "$HOME/.claude/skills/prototype"
create_symlink "$SCRIPT_DIR/skills/design-tokens"      "$HOME/.claude/skills/design-tokens"
create_symlink "$SCRIPT_DIR/skills/design-qa"          "$HOME/.claude/skills/design-qa"
create_symlink "$SCRIPT_DIR/skills/animations"         "$HOME/.claude/skills/animations"
create_symlink "$SCRIPT_DIR/skills/handoff"            "$HOME/.claude/skills/handoff"

echo "Installing agent..."
create_symlink "$SCRIPT_DIR/agents/product-design.md"  "$HOME/.claude/agents/product-design.md"

echo ""
echo "Done. Restart Claude Code to load the new skills and agent."
