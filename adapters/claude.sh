#!/usr/bin/env bash
# Configures the Sprout profile for Claude Code and prints the toge plugin install steps.
# Claude Code installs via the plugin marketplace now — not via symlinks. The actual
# install runs inside Claude Code (`/plugin ...`), so this script can only set the
# profile, clean up pre-plugin symlinks, and show the commands to run.

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

mkdir -p "$HOME/.claude"

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

# --- Clean up stale symlinks from the pre-plugin install ---
# Older versions symlinked individual skills into ~/.claude/skills/. The plugin now
# provides these under the /toge: namespace, so remove any symlink that points back
# into this repo to avoid duplicate skills (e.g. /prototype AND /toge:prototype).
removed_any=false
for name in prd-gap-analyzer prd-ux-validator secondary-research user-journey \
            prototype design-tokens design-qa animations handoff workflow-state learnings; do
  link="$HOME/.claude/skills/$name"
  if [ -L "$link" ]; then
    dest=$(readlink "$link" || true)
    case "$dest" in
      "$SCRIPT_DIR"/*)
        rm "$link"
        echo "  ✓ removed stale symlink: skills/$name"
        removed_any=true
        ;;
    esac
  fi
done
agent_link="$HOME/.claude/agents/product-design.md"
if [ -L "$agent_link" ]; then
  dest=$(readlink "$agent_link" || true)
  case "$dest" in
    "$SCRIPT_DIR"/*)
      rm "$agent_link"
      echo "  ✓ removed stale symlink: agents/product-design.md"
      removed_any=true
      ;;
  esac
fi
if [ "$removed_any" = true ]; then
  echo ""
fi

cat <<'EOF'
Claude Code installs the toge plugin from its marketplace. Inside Claude Code, run:

  /plugin marketplace add micserr/sprout-design-agent
  /plugin install toge@sprout

Then restart Claude Code. Every skill is available under the /toge: namespace
(type /toge: to list them — e.g. /toge:user-journey, /toge:design-qa), along with
the product-design agent. Update later with: /plugin update toge@sprout
EOF
