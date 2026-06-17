# sprout-design-agent

A collection of Claude Code skills and an agent for product designers. Covers the full product design workflow — market research, problem framing, user journeys, prototyping, design QA, and animations — so you can run structured, repeatable design thinking directly from your terminal.

See [`PROMPTS.md`](PROMPTS.md) for ready-to-use prompts for every skill and workflow.

---

## Skills

### PRD → Design Pipeline

| Skill | What it does | Trigger phrases |
|---|---|---|
| `toge:prd-gap-analyzer` | Mesh Mode screen spec generator — reads a product outcome (why) + product unit (what) and produces a `ux-screen-spec`: actors, screens, states, flow, and open design decisions. Standalone equivalent of the agent's inline Phase 0. | "generate screen spec", "translate this to screens", "what screens do I need", "run Phase 0" |
| `toge:prd-ux-validator` | Optional research enrichment — validates a PRD against secondary research and produces a research brief. Not required in the core workflow; use for novel markets or high-stakes UX decisions. | "validate the PRD", "research against the PRD", "enrich with research" |
| `toge:secondary-research` | Free-form competitive and market research — produces an 18-section research brief for use when no PRD exists | "research X", "competitive analysis", "landscape of X", "desk research on X" |

### Design Workflow

| Skill | What it does | Trigger phrases |
|---|---|---|
| `toge:user-journey` | Journey maps and user flow diagrams | "user journey", "user flow", "map the flow", "journey map" |
| `toge:design-tokens` | Token architecture, semantic color families, typography, dark mode | "what token should I use", "design token", "which color for", "semantic color" |
| `toge:design-qa` | Pre-handoff QA across 4 pillars: visual consistency, token compliance, accessibility, interaction readiness | "design qa", "review this design", "audit the UI", "is this ready for handoff" |
| `toge:animations` | Micro-interactions, hover states, enter/exit transitions, easing, and icon state changes (optional phase — designer decides) | "add animations", "make it feel better", "feels off", "hover state", "transition", "easing", "scale on press" |
| `toge:handoff` | Developer handoff pass — splits oversized components, extracts composables, types props/emits, removes prototype artifacts, verifies file structure | "ready for handoff", "clean up the code", "handoff pass", "production ready", "prepare for dev" |

### Internal helpers

| Skill | What it does |
|---|---|
| `toge:workflow-state` | Reads/writes the feature-scoped workflow ledger. Invoked by other skills; not called by humans directly. No-op on profiles without a ledger. |
| `toge:learnings` | Reads/writes the team-wide UX Learnings file. Read at session start as passive design context. Invoked automatically after design-qa and handoff to capture patterns, anti-patterns, and recurring QA findings. Human-callable for manual entries: "remember this", "add to learnings", "what have we learned". |

### Archived skills

Temporarily out of rotation — not auto-discovered by the plugin and not exposed under `/toge:`. See [`archive/`](archive/).

| Skill | What it did | Status |
|---|---|---|
| `prototype` | Built an interactive Vue 3 prototype from a user flow and layout reference | Archived 2026-06-17 — returning in a future release |

---

## Profiles

Sprout skills are SDLC-neutral — they read the **active profile** to know where to write, what front-matter shape to use, which other agents to coexist with, and where prototype code lives.

Two profiles ship:

- **`bmad`** — full BMAD mesh (implem-aidlc style). Outputs land in `_bmad-output/planning-artifacts/ux/`, Sally's UX spec is preferred input when present, feature-scoped ledger at `_bmad-output/state/`, prototype code goes to sibling `implem-prototype/` repo.
- **`vanilla`** — no framework. Outputs land in `docs/design/`, no coexistence agents, no ledger, prototype code in-repo under `prototype/`.

At install, pick your profile (`adapters/claude.sh` asks; `adapters/bmad.sh` auto-selects `bmad`). Override per-repo with `$REPO/.sprout/profile.yaml`. Teams on other SDLCs (Linear, Notion, Shape Up, custom) can author their own profile — see [`profiles/README.md`](profiles/README.md) or [`docs/profiles-guide.md`](docs/profiles-guide.md).

---

## The Product Design Agent

A dual-mode agent — acts as an **advisor** for focused design questions, or as an **orchestrator** that runs the full workflow from a PRD.

### Workflow (Orchestrator Mode)

```
Product Outcome (why) + Product Unit (what)
  → Phase 0: Screen Spec Translation          [required]
      Actors · Screen inventory · States · Flow · Open design decisions
  → Phase 1: Design Framing                   [optional]
      JTBD statements · HMW statements · Problem statement · Success criteria
  → Phase 2: User Journey                     [optional]
  → Phase 3: Interactive Prototype            [archived — skill temporarily out of rotation]
      Typography + surfaces + real navigation + edge states
  → Phase 4: Design QA                        [required]
  → Phase 5: Animations                       [optional — designer decides]
  → Phase 6: Developer Handoff                [required]
```

The agent checks in between every phase. It never auto-advances. For UAC-level inputs or tight feature specs, Phases 1 and 2 can be skipped.

> **Phase 3 (Prototype) is currently archived** — the `toge:prototype` skill is temporarily out of rotation (see [`archive/`](archive/)). Phases 4 (Design QA) and 6 (Handoff) still run against an existing prototype.

**Mesh Mode:** each skill is independently callable — run just `toge:prd-gap-analyzer` to produce a screen spec, just `toge:design-qa` on a prototype, just `toge:handoff` on existing code. Skills resolve paths from the active profile, so the same command produces BMAD-shaped artifacts in a BMAD repo and plain `docs/design/` markdown in a vanilla one. See the Mesh Mode section in `agents/product-design.md`.

### Design System Support

The agent uses **Toge** (shadcn-vue registry) exclusively. See `guide/toge-design-system/` for reference docs.

---

## Requirements

- Claude Code installed
- For prototype output (when the **prototype** skill is restored from `archive/`): a Vue 3 project with Tailwind CSS and Toge (shadcn-vue registry)

---

## Installation

### Claude Code (recommended)

Sprout ships as a Claude Code **plugin**. Inside Claude Code, add the marketplace once, then install:

```
/plugin marketplace add micserr/sprout-design-agent
/plugin install toge@sprout
```

Restart Claude Code. Every skill is then available under the `/toge:` namespace — type `/toge:` to list them (e.g. `/toge:user-journey`, `/toge:design-qa`) — along with the `product-design` agent.

> **Migrating from the old symlink install?** Earlier versions symlinked skills into `~/.claude/skills/` (invoked as `/prototype`, `/design-qa`, …). Remove those first so you don't get duplicates: run `./install.sh` → option 1, which cleans up the stale symlinks for you, then install the plugin as above.

### Other frameworks (Codex, Cursor, BMAD)

```bash
git clone https://github.com/micserr/sprout-design-agent.git
cd sprout-design-agent
chmod +x install.sh
./install.sh
```

Choose Codex, Cursor, or BMAD at the prompt. These adapters generate their own config and are unaffected by the Claude Code plugin.

---

## Updating

- **Claude Code (plugin):** `/plugin update toge@sprout`
- **Other frameworks:** `cd sprout-design-agent && git pull`, then re-run `./install.sh` for that framework.

---

## Adding More Skills

1. Create a folder in `skills/` (e.g., `skills/my-skill/`)
2. Add `SKILL.md` with YAML frontmatter — `name` and `description` required
3. It's auto-discovered by the plugin (no install step) and invoked as `/toge:my-skill`. Reinstall/update the plugin to pick it up: `/plugin update toge@sprout`.
