#!/usr/bin/env bash
# Generates _bmad/product-design/ module for BMAD (Breakthrough Method for Agile AI-Driven Development).
# Usage: ./adapters/bmad.sh [target-dir]
# Default target: current working directory

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
TARGET_DIR="${1:-$(pwd)}"
BMAD_DIR="$TARGET_DIR/_bmad/product-design"

mkdir -p "$BMAD_DIR/agents"

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

echo "Generating _bmad/product-design/ → $BMAD_DIR"

# --- module.yaml ---
cat > "$BMAD_DIR/module.yaml" <<YAML
name: product-design
version: 1.0.0
description: >
  Product design workflow module — covers UX research, problem framing,
  user journeys, wireframing, and interactive prototyping. Includes a
  senior product design advisor agent and 7 supporting skills.
agents:
  - product-design-agent
skills:
  - prd-gap-analyzer
  - prd-ux-validator
  - secondary-research
  - user-journey
  - wireframing
  - prototype
  - design-tokens
  - design-qa
  - ui-polish
YAML
echo "  ✓ module.yaml"

# --- Agent file (BMAD persona format) ---
AGENT_OUT="$BMAD_DIR/agents/product-design-agent.md"

cat > "$AGENT_OUT" <<'PERSONA'
# Role: Product Design Agent

## Persona

You are a senior product designer — opinionated, direct, and collaborative. You push back on weak
briefs, name tradeoffs clearly, and give recommendations rather than lists of options.

**Activation keywords:** product design, UX, user experience, wireframes, user journey, design review,
usability, design feedback, competitive research, problem framing, HMW statements, JTBD, design brief,
information architecture, prototype, clickable prototype, "make it interactive", "bring it to life".

---

PERSONA

# Append agent body
strip_frontmatter "$SCRIPT_DIR/agents/product-design.md" | adapt_tools >> "$AGENT_OUT"

echo "" >> "$AGENT_OUT"
echo "---" >> "$AGENT_OUT"
echo "" >> "$AGENT_OUT"
echo "## Embedded Skills" >> "$AGENT_OUT"
echo "" >> "$AGENT_OUT"
echo "The following skills are embedded for reference. Apply the relevant skill at each workflow phase." >> "$AGENT_OUT"
echo "" >> "$AGENT_OUT"

SKILLS=(
  "prd-gap-analyzer:PRD Gap Analyzer"
  "prd-ux-validator:PRD UX Validator"
  "secondary-research:Secondary Research"
  "user-journey:User Journey"
  "wireframing:Wireframing"
  "prototype:Prototyping"
  "design-tokens:Design Tokens"
  "design-qa:Design QA"
  "ui-polish:UI Polish"
)

for entry in "${SKILLS[@]}"; do
  slug="${entry%%:*}"
  label="${entry##*:}"
  skill_file="$SCRIPT_DIR/skills/$slug/SKILL.md"
  if [ -f "$skill_file" ]; then
    echo "### Skill: $label" >> "$AGENT_OUT"
    echo "" >> "$AGENT_OUT"
    strip_frontmatter "$skill_file" | adapt_tools >> "$AGENT_OUT"
    echo "" >> "$AGENT_OUT"
  fi
done

echo "  ✓ agents/product-design-agent.md"
echo ""
echo "✓ _bmad/product-design/ generated at $BMAD_DIR"
echo "  Add this module to your BMAD config to activate the product-design agent."
