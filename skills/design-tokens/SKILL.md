---
name: design-tokens
description: >
  Use when applying design tokens, choosing colors, typography, spacing, or surface styles
  for a product UI. Trigger phrases: "what token should I use", "design token", "color token",
  "apply tokens", "which color for", "semantic color", "dark mode token", "typography token",
  "surface token", "what class for", "token for danger", "token for success".
---

## Overview

This skill maps design intent to the correct token class. The system uses a **three-layer architecture** — never skip layers or reach into primitives from component code.

---

## Layer Architecture

```
Layer 1 — Primitives       --color-{palette}-{shade}         CSS vars only. Never use in components.
Layer 2 — Bridge (semantic) @layer base :root / .dark         Maps primitives to semantic meaning.
Layer 3 — Utilities        bg-{token}, .text-{token}, .border-{token}   Use these in components.
```

**Rule:** Components always use Layer 3. Layer 1 exists only in `style.css`.

---

## Palette Reference

Food-themed palette names map to semantic intent:

| Palette | Shades | Intent |
|---|---|---|
| `white` | default | Context-aware: `#fff` in light, `mushroom-50` in dark |
| `neutral` | 50–950 | Disabled states, overlays |
| `mushroom` | 50–950 | Primary UI gray — most common |
| `tomato` | 50–950 | Danger / destructive / errors |
| `carrot` | 50–950 | Caution / warnings |
| `mango` | 50–950 | Pending / in-progress |
| `kangkong` | 50–950 | Brand / success (green) |
| `wintermelon` | 50–950 | Accent (teal) |
| `blueberry` | 50–950 | Information |
| `ubas` | 50–950 | Charts / data-viz **ONLY** — never for UI states |

---

## Surface Tokens

Use surface tokens for backgrounds of pages, cards, panels, and inputs. These are in-theme and generate `bg-*` utilities.

| Class | Use when |
|---|---|
| `bg-surface-white` | Page or canvas background (topmost layer) |
| `bg-surface-gray` | Main gray canvas / app shell background |
| `bg-surface-adaptive` | Cards, panels, inputs — uses translucent overlay for elevation |
| `bg-surface-hover` | Hover state on any surface |
| `bg-surface-pressed` | Pressed / mousedown state |
| `bg-surface-disabled` | Disabled container background |
| `bg-surface-inverted` | Dark surface in light mode (e.g. tooltips, dark modals) |
| `bg-surface-active` | Selected / currently active item |
| `bg-surface-active-soft` | Soft selected state (lighter than active) |

---

## Semantic Color Families

These are in-theme tokens. Each family shares the same modifier pattern.

**Families:** `brand` · `success` · `information` · `danger` · `pending` · `caution` · `accent`

| Modifier pattern | Class example | Use when |
|---|---|---|
| `bg-{family}` | `bg-danger` | Filled background for this semantic state |
| `bg-{family}-hover` | `bg-brand-hover` | Hover state on filled background |
| `bg-{family}-pressed` | `bg-success-pressed` | Pressed state on filled background |
| `bg-{family}-subtle` | `bg-caution-subtle` | Tinted/subtle background for soft indicators |
| `bg-{family}-subtle-hover` | `bg-information-subtle-hover` | Hover on subtle background |
| `text-{family}-text` | `text-danger-text` | Text color for this semantic state |
| `text-{family}-text-subtle` | `text-brand-text-subtle` | Muted text color variant |

**Control tokens** (interactive form controls):
`bg-control` · `bg-control-hover` · `bg-control-pressed`

---

## Component-Only Tokens (Text & Border)

These do **not** generate Tailwind `bg-*` or `text-*` utilities. Use them as component classes directly.

### Text classes

| Class | Use when |
|---|---|
| `.text-strong` | Primary content, headings |
| `.text-base` | Default body text |
| `.text-supporting` | Secondary / supporting copy |
| `.text-weak` | Tertiary / hint text |
| `.text-disabled` | Disabled text |
| `.text-on-fill-disabled` | Disabled text on filled backgrounds |
| `.text-inverted` | Text on dark/inverted surfaces |
| `.text-inverted-weak` | Muted text on dark/inverted surfaces |

### Border classes

Always pair with `border` (for border-width) + the color class:

```html
<div class="border border-base">...</div>
```

| Class | Use when |
|---|---|
| `.border-strong` | High-emphasis borders, focus rings |
| `.border-supporting` | Secondary border emphasis |
| `.border-base` | Default border (most common) |
| `.border-base-hover` | Border on hover |
| `.border-base-pressed` | Border on press |
| `.border-weak` | Subtle dividers, hairlines |
| `.border-disabled` | Disabled element border |
| `.border-on-fill-disabled` | Disabled border on filled background |

---

## Dark Mode

Toggle the `.dark` class on `<html>`. The CSS cascade resolves all bridge variables automatically.

```html
<!-- Light -->
<html>...</html>

<!-- Dark -->
<html class="dark">...</html>
```

**Never use media queries for dark mode.** Never hardcode dark-mode colors in components. All tokens adapt automatically.

Examples of what changes in `.dark`:
- `bg-surface-white` → `mushroom-50` instead of `#fff`
- `bg-surface-gray` → `mushroom-900` instead of `mushroom-50`
- `bg-surface-adaptive` → 6% white overlay instead of 6% mushroom-950 overlay

---

## Typography Tokens

**Scale:** `text-100` through `text-1000` (rem values, 14px default at `text-300`)

**Component classes** — use these instead of raw `text-{size}`:

| Class | Use for |
|---|---|
| `.heading-xl` | Page-level hero titles |
| `.heading-lg` | Section headings |
| `.heading-md` | Card/panel titles |
| `.heading-sm` | Sub-section titles |
| `.heading-xs` | Compact headings |
| `.subheading` | Supporting headings |
| `.body` | Default body text (14px) |
| `.body-medium` | Medium-weight body |
| `.label-xs` | Labels, tags, overlines |
| `.caption` | Small supporting text |
| `.overline` | ALL CAPS label above content |
| `.code` | Monospace code blocks |
| `.typography` | Prose scope wrapper for long-form content |

---

## Max-Width Tokens

| Class | Value | Use for |
|---|---|---|
| `max-w-content-sm` | 640px | Narrow forms, modals |
| `max-w-content-md` | 1000px | Standard content pages |
| `max-w-content-lg` | 1320px | Wide layouts, dashboards |
| `max-w-content-full` | 100% | Full-width containers |

---

## Decision Guide

Use this to pick the right token for any UI element:

**Backgrounds:**
1. Page/app shell → `bg-surface-gray`
2. Cards, panels, inputs → `bg-surface-adaptive`
3. Page canvas (modal, overlay) → `bg-surface-white`
4. Semantic state (error, success, etc.) → `bg-{family}` or `bg-{family}-subtle`
5. Never use `bg-{primitive}` (e.g. ~~`bg-mushroom-100`~~) in component code

**Text:**
1. Always use component classes (`.text-strong`, `.text-base`, etc.)
2. Never use `text-{primitive}` (e.g. ~~`text-kangkong-600`~~)
3. For semantic state text → `text-{family}-text` (e.g. `text-danger-text`)

**Borders:**
1. Always pair: `border` (width) + `.border-{modifier}` (color)
2. Default → `border border-base`
3. Subtle divider → `border border-weak`
4. High emphasis → `border border-strong`
5. Never use `border-{primitive}` in component code

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
