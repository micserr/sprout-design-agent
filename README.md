# product-design-agent-promax

## What is this?

A collection of Claude Code skills and an agent for product designers. It covers the full product design workflow — from market research and problem framing through user journeys to wireframing — so you can invoke structured, repeatable design thinking directly from your terminal without switching tools or losing context.

## Skills included

| Skill | What it does | Trigger phrases |
|---|---|---|
| ux-market-research | Competitive analysis, market sizing, trend identification | "research competitors", "market analysis", "competitive landscape" |
| problem-framing | JTBD templates, opportunity trees, HMW statements | "frame the problem", "JTBD", "how might we", "problem statement" |
| wireframing | Vue 3 + shadcn-vue wireframe templates for 6 layout patterns | "wireframe", "sketch a layout", "design a screen", "information architecture" |
| user-journey | Journey maps and user flow diagrams | "user journey", "user flow", "map the flow", "journey map" |
| design-tokens | Token architecture, semantic color families, typography, dark mode | "what token should I use", "design token", "which color for", "semantic color" |

## The Product Design Agent

A dual-mode agent — acts as an advisor for design questions, or as an orchestrator that runs the full workflow (research → problem framing → user journey → wireframe) from a single product brief.

**Trigger phrases:** "design agent, here's my brief:", "run product design for", "review this design"

## Requirements

- Claude Code installed
- For the **wireframing** skill: a Vue 3 project with [Tailwind CSS](https://tailwindcss.com) and [shadcn-vue](https://www.shadcn-vue.com) installed

## Installation

```bash
git clone https://github.com/YOUR_USERNAME/product-design-agent-promax.git
cd product-design-agent-promax
chmod +x install.sh
./install.sh
```

Then restart Claude Code.

## Usage Examples

**UX Research**
```
Research the market for [your product idea]. Who are the top competitors, what are the gaps, and what trends should I be aware of?
```

**Problem Framing**
```
Help me frame the problem for [your product]. Use JTBD and generate some How-Might-We statements.
```

**Wireframing**
```
Wireframe a dashboard page for a project management tool.
```

**User Journey**
```
Map the user journey for someone signing up and using [your product] for the first time.
```

**Agent — orchestrator mode**
```
Design agent, here's my brief: [paste your product brief]. Run the full product design workflow.
```

**Agent — advisor mode**
```
Review this design and give me feedback based on UX heuristics.
```

## Updating

```bash
cd product-design-agent-promax
git pull
```

No need to re-run `install.sh` — symlinks update automatically.

## Adding More Skills

Skills are markdown files in `skills/`. To add a custom skill:

1. Create a new folder in `skills/` (e.g., `skills/my-skill`).
2. Add a `SKILL.md` inside it with YAML frontmatter containing at minimum a `name` and `description` field.
3. Run `./install.sh` to link it into `~/.claude/skills/`.
