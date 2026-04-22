#!/usr/bin/env bash
# Installs product-design skills and agent into Claude Code (~/.claude/)

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

mkdir -p "$HOME/.claude/skills"
mkdir -p "$HOME/.claude/agents"

# --- Profile selection ---
PROFILE_FILE="$HOME/.claude/sprout-profile.yaml"
if [ ! -f "$PROFILE_FILE" ]; then
  echo ""
  echo "Sprout profile — declares where artifacts land for your SDLC."
  echo ""
  echo "  1) bmad     — BMAD mesh (implem-aidlc style, Sally + John coexistence)"
  echo "  2) vanilla  — no framework (docs/design/, in-repo prototype)"
  echo ""
  read -rp "Choose profile [1-2, default 2]: " profile_choice
  case "${profile_choice:-2}" in
    1) chosen_profile="bmad" ;;
    *) chosen_profile="vanilla" ;;
  esac
  cat > "$PROFILE_FILE" <<EOF
# Active Sprout profile (set by adapters/claude.sh at install).
# To change, edit this file — or create \$REPO/.sprout/profile.yaml for a
# per-repo override.
extends: $chosen_profile
EOF
  echo "  ✓ active profile: $chosen_profile (→ $PROFILE_FILE)"
  echo ""
fi

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
create_symlink "$SCRIPT_DIR/skills/workflow-state"     "$HOME/.claude/skills/workflow-state"
create_symlink "$SCRIPT_DIR/skills/learnings"          "$HOME/.claude/skills/learnings"

echo "Installing agent..."
create_symlink "$SCRIPT_DIR/agents/product-design.md"  "$HOME/.claude/agents/product-design.md"

echo ""
echo "Done. Restart Claude Code to load the new skills and agent."
