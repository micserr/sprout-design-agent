# sprout-design-agent

A collection of Claude Code skills and an agent for product designers. Covers the full product design workflow — market research, problem framing, user journeys, wireframing, prototyping, design QA, and UI polish — so you can run structured, repeatable design thinking directly from your terminal.

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
| `wireframing` | Framework-agnostic layout blueprints for 5 SaaS patterns; bento layout by default | "wireframe", "sketch a layout", "design a screen", "information architecture" |
| `prototype` | Turns wireframes into a runnable, interactive Vue 3 prototype with real navigation, state, and design system components | "prototype", "make it interactive", "clickable prototype", "wire the screens" |
| `design-tokens` | Token architecture, semantic color families, typography, dark mode | "what token should I use", "design token", "which color for", "semantic color" |
| `design-qa` | Pre-handoff QA across 4 pillars: visual consistency, token compliance, accessibility, interaction readiness | "design qa", "review this design", "audit the UI", "is this ready for handoff" |
| `ui-polish` | Micro-interactions, animations, hover states, shadows, borders, typography details, optical alignment | "ui polish", "make it feel better", "feels off", "hover state", "animation", "shadow", "border radius", "font smoothing" |


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
  → Phase 3: Wireframes
  → Phase 4: Interactive Prototype
  → Phase 5: Design QA
  → Phase 6: UI Polish
```

The agent checks in between every phase. It never auto-advances.

### Design System Support

The agent auto-detects the design system at Phase 3 and carries it forward:

| Design system | Detection |
|---|---|
| **Toge v1** (`design-system-next`) | `package.json` contains `design-system-next` |
| **Toge v2** (shadcn-vue registry) | `components.json` has `registries["@toge"]` |
| **Custom / other** | Falls back to asking the user |

See `guide/toge-design-system-v1/` and `guide/toge-design-system-v2/` for design system reference docs.

---

## Requirements

- Claude Code installed
- For the **wireframing** skill viewer: Node.js (`npm run dev` inside `skills/wireframing/viewer/`)
- For the **prototype** skill output: a Vue 3 project with Tailwind CSS and Toge v1 or v2

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
