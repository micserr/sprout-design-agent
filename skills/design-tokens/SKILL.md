---
name: toge:design-tokens
description: >
  Use when applying design tokens, choosing colors, typography, spacing, or surface styles
  for a product UI. Trigger phrases: "what token should I use", "design token", "color token",
  "apply tokens", "which color for", "semantic color", "dark mode token", "typography token",
  "surface token", "what class for", "token for danger", "token for success".
---

## Overview

This skill maps design intent to the correct token class. The system uses a **three-layer architecture** — never skip layers or reach into primitives from component code.

For the full token list, see the references folder:
- [`references/primitives.yaml`](references/primitives.yaml) — all palettes, shades, usage rules
- [`references/color-tokens.yaml`](references/color-tokens.yaml) — all surface, semantic, text, border, outline tokens
- [`references/typography.yaml`](references/typography.yaml) — all component typography classes
- [`references/bridge-dark-mode.yaml`](references/bridge-dark-mode.yaml) — bridge layer, light/dark resolved values

---

## Layer Architecture

```
Layer 1 — Primitives        --color-{palette}-{shade}               CSS vars only. Never use in components.
Layer 2 — Bridge (semantic)  @layer base :root / .dark              Maps primitives to semantic meaning.
Layer 3 — Utilities          bg-{token}, .text-{token}, .border-*  Use these in components.
```

**Rule:** Components always use Layer 3. Layer 1 exists only in `style.css`.
**Exception:** `ubas` palette (charts/data-viz only) — primitives used directly, e.g. `bg-ubas-500`.

---

## Surface Tokens (quick reference)

In-theme — generate `bg-*` utilities. Full table in `references/color-tokens.md`.

| Class | Use when |
|---|---|
| `bg-surface-white` | Page / canvas background — topmost layer |
| `bg-surface-gray` | Main gray canvas / app shell |
| `bg-surface` | Alias for surface-gray |
| `bg-surface-adaptive` | Cards, panels, inputs — translucent elevation overlay |
| `bg-surface-hover` | Hover state on any surface |
| `bg-surface-pressed` | Pressed / mousedown state |
| `bg-surface-disabled` | Disabled container |
| `bg-surface-inverted` | Dark surface in light mode (tooltips, dark chips) |
| `bg-surface-inverted-hover` | Hover on inverted surface |
| `bg-surface-inverted-pressed` | Pressed on inverted surface |
| `bg-surface-active` | Selected / active item |
| `bg-surface-active-soft` | Soft selected state |

---

## Semantic Color Families (quick reference)

Seven families: `brand` · `success` · `information` · `danger` · `pending` · `caution` · `accent`

Each has **9 tokens** — full list per family in `references/color-tokens.md`:

| Modifier | Class | Use when |
|---|---|---|
| `{family}` | `bg-{family}` | Filled background for this state |
| `{family}-hover` | `bg-{family}-hover` | Hover on filled background |
| `{family}-pressed` | `bg-{family}-pressed` | Pressed state on filled background |
| `{family}-subtle` | `bg-{family}-subtle` | Soft/tinted background |
| `{family}-subtle-hover` | `bg-{family}-subtle-hover` | Hover on subtle background |
| `{family}-subtle-pressed` | `bg-{family}-subtle-pressed` | Pressed on subtle background |
| `{family}-text` | `text-{family}-text` | Text color for this state |
| `{family}-text-hover` | `text-{family}-text-hover` | Text on hover |
| `{family}-text-pressed` | `text-{family}-text-pressed` | Text on press |

**Control tokens:** `bg-control` · `bg-control-hover` · `bg-control-pressed`

---

## Component-Only Tokens (quick reference)

Do **not** generate Tailwind utilities. Use as classes directly.

**Text** — full table in `references/color-tokens.md`:
`text-strong` · `text-supporting` · `text-base` · `text-weak` · `text-disabled` · `text-on-fill-disabled` · `text-inverted` · `text-inverted-base` · `text-inverted-weak` · `text-inverted-disabled`

**Border** — always pair with `border` for width:
```html
<div class="border border-base">...</div>
```
`border-strong` · `border-supporting` · `border-base` · `border-base-hover` · `border-base-pressed` · `border-weak` · `border-disabled` · `border-on-fill-disabled`

**Outline** — same values as border, for `outline-color`:
`outline-strong` · `outline-base` · `outline-weak` · _(same modifiers as border)_

---

## Dark Mode

Toggle `.dark` on `<html>`. Never use media queries. All tokens adapt automatically.

Surface token resolved values (light → dark):
- `bg-surface-white` → `#fff` light / `#262b2b` (mushroom-950) dark — darkest layer
- `bg-surface-gray` → `mushroom-50` light / `#394141` (mushroom-900) dark
- `bg-surface-adaptive` → translucent mushroom-950 overlay light / translucent white overlay dark

→ Full bridge values in `references/bridge-dark-mode.md`

---

## Typography (quick reference)

Full class list in `references/typography.md`.

| Group | Classes |
|---|---|
| Body | `body` · `body-medium` · `body-md` · `body-md-medium` · `body-lg` · `body-lg-medium` |
| Label | `label-xs` · `label-xs-medium` · `label-sm` · `label-sm-medium` |
| Heading | `heading-xl` · `heading-lg` · `heading-md` · `heading-sm` · `heading-xs` |
| Subheading | `subheading-sm` · `subheading-xs` |
| Utility | `caption` · `caption-medium` · `overline` · `code` |
| Prose | `typography` (wrapper for long-form content) |

Default body: 14px (`text-300`). Always use component classes — never raw `text-{size}`.

---

## Max-Width Tokens

| Class | Value | Use for |
|---|---|---|
| `max-w-content-sm` | 640px | Narrow: forms, auth pages |
| `max-w-content-md` | 1000px | Standard: dashboards, settings |
| `max-w-content-lg` | 1320px | Wide: landing pages, full-width tables |
| `max-w-content-full` | 100% | Edge-to-edge: full-bleed sections |

---

## Decision Guide

**Backgrounds:**
1. Page / app shell → `bg-surface-gray`
2. Cards, panels, inputs → `bg-surface-adaptive`
3. Modal / overlay canvas → `bg-surface-white`
4. Semantic state → `bg-{family}` or `bg-{family}-subtle`
5. Never: ~~`bg-mushroom-100`~~ (primitive in component code)

**Text:**
1. Use component-only classes: `text-strong`, `text-base`, `text-weak`, etc.
2. Semantic state text: `text-{family}-text`
3. Never: ~~`text-kangkong-600`~~ (primitive in component code)

**Borders:**
1. `border border-base` — default
2. `border border-weak` — subtle divider
3. `border border-strong` — high emphasis / focus ring
4. Never: ~~`border-mushroom-300`~~ (primitive in component code)

**Choosing a semantic family:**
| Intent | Family |
|---|---|
| Primary actions, brand identity | `brand` |
| Positive outcome, saved, complete | `success` |
| Error, destructive action, delete | `danger` |
| Warning, needs attention | `caution` |
| Loading, in review, not yet complete | `pending` |
| Info, help, neutral notice | `information` |
| Highlights, secondary brand | `accent` |
