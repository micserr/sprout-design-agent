# Design tokens

This folder documents the design token structure used in this project. The **single source of truth** for token values is [`../style.css`](../style.css). This README and `design-tokens.yaml` describe the architecture and naming so humans and AI can understand or reimplement the system in another project.

---

## Architecture (3 layers)

### 1. Primitives

**Where:** `@theme { }` in CSS (no `inline`). Raw palette values (hex).

**Naming:** `--color-{palette}-{shade}` (e.g. `--color-mushroom-50`, `--color-kangkong-700`).

**Effect:** Tailwind generates utilities: `bg-mushroom-500`, `text-kangkong-700`, `border-tomato-300`.

**Palettes:**

| Palette      | Shades        | Usage |
|-------------|---------------|--------|
| white       | default       | Context-aware: light = #fff; dark = mushroom-50 (#eff1f1). The `--color-white` primitive is overridden in `.dark` so `bg-white` renders as a soft off-white rather than bright white. |
| neutral     | 50–950        | Disabled states, overlays, on-fill text. Do **not** use for primary UI surfaces/text/borders — use mushroom. |
| mushroom    | 50–950        | Primary UI gray: surfaces, text, borders, interactive states. Prefer over neutral for UI. |
| tomato      | 50–950        | Danger/semantic red. |
| carrot      | 50–950        | Caution. |
| mango       | 50–950        | Pending. |
| kangkong    | 50–950        | Brand, success (green). |
| wintermelon | 50–950        | Accent (teal). |
| blueberry   | 50–950        | Information. |
| ubas        | 50–950        | Purple; chart/data-viz only. No semantic mapping. Use directly: `bg-ubas-500`, etc. |

---

### 2. Bridge (semantic) variables

**Where:** `@layer base { :root { ... } }` and `.dark { ... }` in the same block.

**Naming:** Semantic names without a `color-` prefix: `--surface-adaptive`, `--text-strong`, `--border-strong`, `--brand`, `--success`, etc.

**Light mode:** Values reference primitives only (e.g. `--surface-adaptive: var(--color-mushroom-100)`). No semantic → semantic chains.

**Dark mode:** `.dark { }` overrides the same variable names with hex/oklch. When `.dark` is present on `<html>`, these overrides win. Keep `:root` and `.dark` in the same `@layer base` so source order is preserved in compiled CSS.

---

### 3. Theme vs component-only semantics

**In theme (`@theme inline`):** Surface, brand, success, information, danger, pending, caution, accent, control. Each is exposed as `--color-*` so Tailwind generates `bg-surface-base`, `bg-brand`, `text-brand-text`, etc. Surface is split into **surface-white** (context-aware: light = white, dark = mushroom-50), **surface-gray** (main gray canvas), and **surface-adaptive** (darker container on surface-gray — cards, panels, inputs). The rest of the gray scale: surface, surface-hover, surface-pressed, etc. **Accent** theme tokens map to bridge vars `--accent-fill`, `--accent-fill-hover`, etc. (to avoid clashing with shadcn’s `--accent`). Safe to use as background, text, or border because the intent is multi-purpose.

**Component-only (not in theme):** Text and border semantics. They are **not** added to `@theme inline`, so `bg-strong` and `text-border-base` do not exist. Instead, component classes in `@layer components` set only the relevant property:

- **Text:** `.text-strong`, `.text-base`, `.text-inverted`, etc. → `color: var(--text-strong);`
- **Border:** `.border-strong`, `.border-weak`, etc. → `border-color: var(--border-strong);`
- **Outline:** `.outline-strong`, `.outline-base`, etc. → `outline-color: var(--border-*);` (same values as border)

This avoids misusing text or border semantics as background or other properties.

---

## Dark mode

- **Trigger:** Single class `.dark` on `<html>` (e.g. `document.documentElement.classList.toggle('dark', true)`).
- **Custom variant:** `@custom-variant dark (&:where(.dark, .dark *));` so Tailwind’s `dark:` prefix matches.
- All semantic bridge vars are overridden in `.dark { }`; no separate media query. CSS custom properties resolve by cascade, so any rule using `var(--surface-adaptive)` gets the dark value when `.dark` is an ancestor.

---

## Usage in UI

| Intent           | How to use |
|------------------|------------|
| Surface (white)  | `bg-surface-white` — page/canvas layer. Light: #fff. Dark: mushroom-950 (#262b2b, the darkest canvas). |
| Surface (gray)  | `bg-surface-gray` — main gray canvas. Light: mushroom-50. Dark: mushroom-900 (#394141). |
| Surface (darker on gray) | `bg-surface-adaptive` — cards, panels, inputs. Uses `color-mix` translucent overlay so it works on any background. |
| Surface (rest) | `bg-surface`, `bg-surface-hover`, `bg-surface-pressed`, `bg-surface-inverted`, etc. |
| Text (semantic)  | `text-strong`, `text-base`, `text-weak`, `text-inverted` (component classes). |
| Border           | `border border-strong`, `border border-weak`, `border-base-hover` (component classes for color; add `border` for width). |
| Outline          | `outline outline-2 outline-offset-2 outline-strong` (component classes; same values as border). |
| Brand            | `bg-brand`, `text-brand-text`, `bg-brand-subtle`, etc. |
| Success / Danger / etc. | `bg-success`, `text-danger-text`, `bg-danger-subtle`, etc. |

**Surface token usage (source of truth):** Use `bg-surface-white` for the outermost page/canvas layer (hero, page bg). Use `bg-surface-gray` for the main gray canvas. Use `bg-surface-adaptive` for any container that needs elevation on top of surface-gray (cards, panels, inputs) — it uses a translucent overlay so it adapts to any background. Other surface tokens (hover, pressed, inverted, etc.) stay as documented.

---

## Typography

**Scale (in `@theme`):**

- **Font size:** `--text-100` … `--text-1000` (rem). Default body: 14px (`--text-300`). Avoid 10px/12px for primary UI.
- **Line height:** `--leading-100` … `--leading-1000`.
- **Letter spacing:** `--tracking-densest` … `--tracking-widest`.

**Component classes:** `.body`, `.body-medium`, `.body-md`, `.body-md-medium`, `.body-lg`, `.body-lg-medium`, `.heading-xl` … `.heading-xs`, `.subheading-sm`, `.subheading-xs`, `.label-xs`, `.label-sm`, `.caption`, `.caption-medium`, `.overline`, `.code`. Prose: `.typography` scope for `h1`–`h6`, `p`, `small`, `code`, `a`, etc.

---

## Implementation checklist (for another project)

1. **Primitives:** Define `@theme { --color-{palette}-{shade}: <hex>; }` for each palette and shade. Clear Tailwind defaults first if needed (`--color-*: initial`).
2. **Bridge vars:** Add `@layer base { :root { ... } .dark { ... } }` with semantic names (`--surface-adaptive`, `--text-strong`, `--border-strong`, `--brand`, …). Light: reference primitives only. Dark: override with hex/oklch.
3. **Theme semantics:** In `@theme inline`, add `--color-surface-white`, `--color-surface-gray`, `--color-surface-adaptive`, `--color-surface`, etc., and `--color-brand`, etc., pointing to the bridge vars. Omit text and border from theme.
4. **Component-only text/border/outline:** In `@layer components`, add classes that set only `color`, `border-color`, or `outline-color` using the bridge vars.
5. **Typography:** Add `@theme` font-size/leading/tracking scale; add component classes for body, label, heading, and `.typography` scope.
6. **Dark mode:** Toggle `.dark` on `<html>`. Use `@custom-variant dark` if you want Tailwind `dark:` utilities.

---

## File reference

- **Token values and CSS:** [`../style.css`](../style.css) — canonical source; this folder is documentation only.
- **Structure (names, groups):** [`design-tokens.yaml`](./design-tokens.yaml)
