---
name: toge:wireframing
description: >
  Use when creating wireframes, sketching page layouts, designing information architecture,
  or structuring screens. Trigger phrases: "wireframe", "sketch a layout", "design a screen",
  "information architecture", "IA", "page layout", "sketch this page".
---

## Overview

This skill produces low-fidelity, grayscale wireframes that communicate structure and layout — not visual design. Output is always based on the layout blueprints and adapted to whatever stack the target project uses.

**Core rule:** Wireframes use grayscale only. No brand colors. No production styling.

---

## Step 1 — Read the Layout Blueprint

Before writing any code, read the matching layout blueprint from `skills/wireframing/templates/layout/`. These are pure HTML + Tailwind files that define page structure independent of any framework.

| Template | Use when... | Blueprint file |
|---|---|---|
| `dashboard` | Primary overview, data-heavy, multiple metrics or summaries | `templates/layout/dashboard.html` |
| `form-page` | Data entry, settings, configuration, multi-field input | `templates/layout/form-page.html` |
| `onboarding-wizard` | Multi-step flows, setup sequences, guided processes | `templates/layout/onboarding-wizard.html` |
| `settings-page` | Account preferences, app configuration, sectioned options | `templates/layout/settings-page.html` |
| `complex-dashboard` | Multi-panel SaaS workflows — selector panel + data table + detail side panel | `templates/layout/complex-dashboard.html` |

Focus on:
- HTML comments — they explain structural intent (e.g. `<!-- SIDEBAR: fixed width, primary navigation -->`)
- Layout classes — `flex`, `grid`, `w-56`, `gap-4`, `overflow-y-auto`, `rounded-xl`
- Visual states — active, selected, disabled, placeholder

Ignore implementation details (which component library, which element tag) — those are resolved by the implementer.

---

## Step 2 — Generate the Wireframe

Translate the blueprint into the target project's stack:
- Map each structural region to the equivalent element or component in the target framework
- Replace ALL CAPS labels with actual screen names (e.g. `"MAIN CONTENT"` → `"EMPLOYEE LIST"`)
- Add/remove sections as needed for the specific screen
- Keep everything grayscale

**Viewer shortcut:** A ready-to-use local viewer is available at `skills/wireframing/viewer/`. Run `npm run dev` inside that directory to preview wireframes instantly.

---

## Wireframe Conventions

These apply regardless of framework or output format:

- **Grayscale only** — `gray-50` through `gray-900`. Never use color.
- **ALL CAPS for structural regions** — `"NAVIGATION"`, `"MAIN CONTENT"`, `"FEATURE TITLE"`
- **Descriptive dummy values for data** — `"USER NAME"`, `"FIELD VALUE"`, `"CATEGORY"`
- **Minimal state** — only what's needed for basic interactivity (selected tab, active step, open modal)
- **Dashed borders for placeholders** — for charts, images, maps, and any non-text content area

### Layout Style — Bento

All wireframes use a **bento layout** by default. Panels and sections are floating cards on a gray background, with visible gaps between them. Never use flush borders between adjacent panels.

**Rules:**
- Outer content area: `bg-gray-100 p-3 gap-3` — the gray shows through as the gutter
- Each panel/card: `bg-white rounded-xl shadow-sm` — no `border-r` or `border-l` between panels
- Fixed side nav: full height, outside the bento grid
- Top bar (if present): flush to the top, full width, with a bottom border

```
┌─────────────────────────────────────────────┐
│ TOP BAR (full width, flush)                 │
├─────────────────────────────────────────────┤
│ bg-gray-100  p-3  gap-3                     │
│  ┌──────────┐  ┌─────────────┐  ┌────────┐ │
│  │  Panel   │  │   Panel     │  │ Panel  │ │
│  │ rounded  │  │  rounded    │  │rounded │ │
│  └──────────┘  └─────────────┘  └────────┘ │
└─────────────────────────────────────────────┘
```

---

## Multiple Screens

Generate one file per screen, numbered sequentially:

```
wireframe-01-login
wireframe-02-dashboard
wireframe-03-detail
```
