#!/usr/bin/env bash
# sprout-design-agent installer
# Installs the product-design agent and skills to your AI framework of choice.

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

echo ""
echo "sprout-design-agent"
echo "==================="
echo ""
echo "Which framework would you like to install to?"
echo ""
echo "  1) Claude Code   — symlinks skills + agent to ~/.claude/"
echo "  2) Codex CLI     — generates AGENTS.md in the current directory"
echo "  3) Cursor        — generates .cursor/rules/*.mdc in the current directory"
echo "  4) BMAD          — generates _bmad/product-design/ in the current directory"
echo "  5) All of the above"
echo ""
read -rp "Enter choice [1-5]: " choice
echo ""

run_claude() {
  echo "→ Installing for Claude Code..."
  bash "$SCRIPT_DIR/adapters/claude.sh"
}

run_codex() {
  echo "→ Installing for Codex CLI..."
  bash "$SCRIPT_DIR/adapters/codex.sh" "$(pwd)"
}

run_cursor() {
  echo "→ Installing for Cursor..."
  bash "$SCRIPT_DIR/adapters/cursor.sh" "$(pwd)"
}

run_bmad() {
  echo "→ Installing for BMAD..."
  bash "$SCRIPT_DIR/adapters/bmad.sh" "$(pwd)"
}

case "$choice" in
  1) run_claude ;;
  2) run_codex ;;
  3) run_cursor ;;
  4) run_bmad ;;
  5)
    run_claude
    echo ""
    run_codex
    echo ""
    run_cursor
    echo ""
    run_bmad
    ;;
  *)
    echo "Invalid choice. Run ./install.sh and enter 1–5."
    exit 1
    ;;
esac

echo ""
echo "Installation complete."
