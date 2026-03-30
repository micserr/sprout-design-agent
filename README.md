# sprout-design-agent

## What is this?

A collection of Claude Code skills and an agent for product designers. It covers the full product design workflow — from market research and problem framing through user journeys, wireframing, and interactive prototyping — so you can run structured, repeatable design thinking directly from your terminal without switching tools.

---

## Skills

| Skill | What it does | Trigger phrases |
|---|---|---|
| `ux-market-research` | Competitive analysis, market sizing, trend identification | "research competitors", "market analysis", "competitive landscape" |
| `problem-framing` | JTBD statements, opportunity trees, HMW statements | "frame the problem", "JTBD", "how might we", "problem statement" |
| `user-journey` | Journey maps and user flow diagrams | "user journey", "user flow", "map the flow", "journey map" |
| `wireframing` | Framework-agnostic layout blueprints for 5 SaaS patterns; bento layout by default | "wireframe", "sketch a layout", "design a screen", "information architecture" |
| `prototype` | Turns wireframes into a runnable, interactive Vue 3 prototype with real navigation, state, and design system components | "prototype", "make it interactive", "clickable prototype", "wire the screens" |
| `design-tokens` | Token architecture, semantic color families, typography, dark mode | "what token should I use", "design token", "which color for", "semantic color" |
| `design-qa` | Pre-handoff QA across 4 pillars: visual consistency, token compliance, accessibility, interaction readiness | "design qa", "review this design", "audit the UI", "is this ready for handoff" |
| `ui-polish` | Micro-interactions, animations, hover states, shadows, borders, typography details, optical alignment — based on principles from Emil Kowalski and Jakub Krehel | "ui polish", "make it feel better", "feels off", "hover state", "animation", "shadow", "border radius", "font smoothing" |

---

## The Product Design Agent

A dual-mode agent — acts as an **advisor** for focused design questions, or as an **orchestrator** that runs the full workflow from a single brief.

### Workflow (Orchestrator Mode)

```
Brief → Phase 1: UX Research → Phase 2: Problem Framing → Phase 3: User Journey → Phase 4: Wireframes → Phase 5: Prototype → Phase 5.5: Design QA → Phase 6: UI Polish
```

The agent checks in between every phase using interactive CLI prompts (`AskUserQuestion`). It never auto-advances.

At the start of every workflow, it confirms which design system the project uses:
- **Toge v1** (`design-system-next` via npm) — see `guide/toge-design-system-v1/`
- **Toge v2** (component registry via `npx shadcn-vue`) — see `guide/toge-design-system-v2/`

**Trigger phrases:** "design agent, here's my brief:", "run product design for", "review this design", "prototype this"

---

## Design System Guides

The `guide/` directory contains reference docs for AI agents working on Sprout products.

| Guide | When to use |
|---|---|
| `guide/toge-design-system-v1/` | Project has `design-system-next` in `package.json` |
| `guide/toge-design-system-v2/` | Project has `components.json` with `@toge` registry |

See `guide/README.md` for how to detect which system a project uses.

---

## Requirements

- Claude Code installed
- For the **wireframing** skill viewer: Node.js (run `npm run dev` inside `skills/wireframing/viewer/`)
- For the **prototype** skill output: a Vue 3 project with Tailwind CSS and either `design-system-next` (Toge v1) or shadcn-vue + Toge registry (Toge v2)

---

## Installation

```bash
git clone https://github.com/YOUR_USERNAME/sprout-design-agent.git
cd sprout-design-agent
chmod +x install.sh
./install.sh
```

Then restart Claude Code.

---

## Usage Examples

**Full workflow from a brief**
```
Design agent, here's my brief: [paste your product brief]. Run the full product design workflow.
```

**Prototype from existing wireframes**
```
Turn these wireframes into an interactive prototype.
```

**Wireframe a single screen**
```
Wireframe a complex dashboard for an HR payroll tool.
```

**Problem framing**
```
Help me frame the problem for [your product]. Use JTBD and generate some How-Might-We statements.
```

**UX research**
```
Research the market for [your product idea]. Who are the top competitors and what are the gaps?
```

**Design review**
```
Review this design and give me feedback based on UX heuristics.
```

---

## Updating

```bash
cd sprout-design-agent
git pull
```

No need to re-run `install.sh` — symlinks update automatically.

---

## Adding More Skills

Skills are markdown files in `skills/`. To add a custom skill:

1. Create a new folder in `skills/` (e.g., `skills/my-skill`)
2. Add a `SKILL.md` with YAML frontmatter containing at minimum `name` and `description`
3. Run `./install.sh` to link it into `~/.claude/skills/`
