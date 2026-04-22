#!/usr/bin/env bash
# Generates .cursor/rules/*.mdc for Cursor IDE in the target directory.
# Usage: ./adapters/cursor.sh [target-dir]
# Default target: current working directory

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
TARGET_DIR="${1:-$(pwd)}"
RULES_DIR="$TARGET_DIR/.cursor/rules"

mkdir -p "$RULES_DIR"

# Strip YAML frontmatter from a markdown file
strip_frontmatter() {
  local file="$1"
  awk 'BEGIN{f=0} /^---/{if(f==0){f=1;next}else{f=2;next}} f==2{print}' "$file"
}

# Replace Claude-specific tool instructions with generic equivalents
adapt_tools() {
  sed \
    -e 's/Use `AskUserQuestion`/Ask the user directly/g' \
    -e 's/via `AskUserQuestion`/directly/g' \
    -e 's/use `AskUserQuestion`:/ask:/g' \
    -e 's/`AskUserQuestion`/a direct question to the user/g' \
    -e 's/All questions go through `a direct question to the user`/Always ask the user directly before proceeding/g'
}

# Extract description from YAML frontmatter
get_description() {
  local file="$1"
  awk '/^description:/{p=1; sub(/^description: *>? */,""); print; next} p && /^  /{print; next} p{exit}' "$file" \
    | tr -d '\n' | sed 's/  */ /g'
}

echo "Generating .cursor/rules/ → $RULES_DIR"

# --- Agent rule ---
AGENT_DESC="A senior product design advisor and end-to-end workflow orchestrator for UX, wireframes, prototyping, and design reviews."
cat > "$RULES_DIR/product-design-agent.mdc" <<MDC
---
description: $AGENT_DESC
globs:
alwaysApply: false
---

MDC
strip_frontmatter "$SCRIPT_DIR/agents/product-design.md" | adapt_tools >> "$RULES_DIR/product-design-agent.mdc"
echo "  ✓ product-design-agent.mdc"

# --- Skill rules ---
skill_desc() {
  case "$1" in
    prd-gap-analyzer)   echo "Mesh Mode screen spec generator — reads a product outcome and product unit, produces a ux-screen-spec (actors, screens, states, flow, open design decisions)." ;;
    prd-ux-validator)   echo "Optional research enrichment — validates a PRD against secondary research. Not required in the core workflow." ;;
    secondary-research) echo "Free-form competitive and market research producing an 18-section design brief." ;;
    user-journey)       echo "Journey maps, user flow diagrams, pain points, and touchpoint summaries." ;;
    prototype)          echo "Turns a screen spec into a runnable Vue 3 prototype with real navigation, live state, and design system components." ;;
    design-tokens)      echo "Token architecture, semantic color families, typography, and dark mode guidance." ;;
    design-qa)          echo "Pre-handoff QA across 4 pillars: visual consistency, token compliance, accessibility, interaction readiness." ;;
    animations)         echo "Animation and micro-interaction principles — hover states, transitions, easing, and motion details." ;;
    handoff)            echo "Developer handoff pass — product unit coverage check, component splits, composable extraction, props/emits typing, prototype artifact removal." ;;
    workflow-state)     echo "Internal helper — reads/writes the feature-scoped workflow ledger. Invoked by other skills, not by humans." ;;
    learnings)          echo "Internal helper — reads/writes the team-wide UX Learnings file. Accumulates patterns, anti-patterns, and recurring QA findings across features." ;;
    *)                  echo "Product design skill." ;;
  esac
}

SKILLS=(prd-gap-analyzer prd-ux-validator secondary-research user-journey prototype design-tokens design-qa animations handoff workflow-state learnings)

for slug in "${SKILLS[@]}"; do
  skill_file="$SCRIPT_DIR/skills/$slug/SKILL.md"
  if [ -f "$skill_file" ]; then
    out_file="$RULES_DIR/$slug.mdc"
    desc="$(skill_desc "$slug")"
    cat > "$out_file" <<MDC
---
description: $desc
globs:
alwaysApply: false
---

MDC
    strip_frontmatter "$skill_file" | adapt_tools >> "$out_file"
    echo "  ✓ $slug.mdc"
  fi
done

echo ""
echo "✓ .cursor/rules/ generated at $RULES_DIR"
echo "  Cursor will pick these up automatically. Rules are off by default — attach them manually or set alwaysApply: true."
