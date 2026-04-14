# sprout-design-agent

A collection of Claude Code skills and an agent for product designers. Covers the full product design workflow — market research, problem framing, user journeys, prototyping, design QA, and animations — so you can run structured, repeatable design thinking directly from your terminal.

See [`PROMPTS.md`](PROMPTS.md) for ready-to-use prompts for every skill and workflow.

---

## Skills

### PRD → Design Pipeline

| Skill | What it does | Trigger phrases |
|---|---|---|
| `prd-gap-analyzer` | Validates a PRD before design begins — scans for missing sections, rates severity, generates clarifying questions, and produces a handoff block for the enrichment step | "analyze this PRD", "check for gaps", "is this PRD ready for design", "PRD gap check" |
| `prd-ux-validator` | Takes a PRD + gap report and enriches it with secondary research — fills gaps, flags assumptions, and produces a prototype-ready design brief | "validate the PRD", "PRD + research brief", "enrich the brief", "prd-ux-validator" |
| `secondary-research` | Free-form competitive and market research — produces the same 18-section brief format as prd-ux-validator for use when no PRD exists | "research X", "competitive analysis", "landscape of X", "desk research on X" |

### Design Workflow

| Skill | What it does | Trigger phrases |
|---|---|---|
| `user-journey` | Journey maps and user flow diagrams | "user journey", "user flow", "map the flow", "journey map" |
| `prototype` | Builds an interactive Vue 3 prototype from a user flow and layout reference — typography and surfaces built-in | "prototype", "make it interactive", "clickable prototype", "wire the screens" |
| `design-tokens` | Token architecture, semantic color families, typography, dark mode | "what token should I use", "design token", "which color for", "semantic color" |
| `design-qa` | Pre-handoff QA across 4 pillars: visual consistency, token compliance, accessibility, interaction readiness | "design qa", "review this design", "audit the UI", "is this ready for handoff" |
| `animations` | Micro-interactions, hover states, enter/exit transitions, easing, and icon state changes (optional phase — designer decides) | "add animations", "make it feel better", "feels off", "hover state", "transition", "easing", "scale on press" |
| `handoff` | Developer handoff pass — splits oversized components, extracts composables, types props/emits, removes prototype artifacts, verifies file structure | "ready for handoff", "clean up the code", "handoff pass", "production ready", "prepare for dev" |


---

## The Product Design Agent

A dual-mode agent — acts as an **advisor** for focused design questions, or as an **orchestrator** that runs the full workflow from a PRD.

### Workflow (Orchestrator Mode)

```
PM Agent Intent / PRD
  → Phase 0: Validate + Enrich
      prd-gap-analyzer  (flag missing sections)
      prd-ux-validator  (fill gaps with research, tag assumptions)
      Designer check-in (confirm context)
  → Phase 1: Design Framing
      JTBD statements · HMW statements · Problem statement · Success criteria
  → Phase 2: User Journey + Stack Discovery
  → Phase 3: Interactive Prototype (typography + surfaces built-in)
  → Phase 4: Design QA
  → Phase 5: Animations (optional — designer decides)
  → Phase 6: Developer Handoff
```

The agent checks in between every phase. It never auto-advances.

### Design System Support

The agent uses **Toge** (shadcn-vue registry) exclusively. See `guide/toge-design-system-v2/` for reference docs.

---

## Requirements

- Claude Code installed
- For the **prototype** skill output: a Vue 3 project with Tailwind CSS and Toge (shadcn-vue registry)

---

## Installation

```bash
git clone https://github.com/YOUR_USERNAME/sprout-design-agent.git
cd sprout-design-agent
chmod +x install.sh
./install.sh
```

Restart Claude Code after installation. No need to re-run `install.sh` on updates — symlinks stay current with `git pull`.

---

## Updating

```bash
cd sprout-design-agent
git pull
```

---

## Adding More Skills

1. Create a folder in `skills/` (e.g., `skills/my-skill/`)
2. Add `SKILL.md` with YAML frontmatter — `name` and `description` required
3. Run `./install.sh` to link it into `~/.claude/skills/`
