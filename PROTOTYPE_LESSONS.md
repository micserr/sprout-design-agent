# Prototype Dev Lessons — Phase 0 to Phase 5

> **Purpose:** This document captures infrastructure and tooling issues encountered during a full product design workflow (Phase 0 research → Phase 5 prototype) on this project. Include this file as context when running the prototype phase of the product-design agent to avoid repeating the same setup issues.

---

## Root Cause: Tech Stack Was Never Declared Early Enough

> **The single biggest source of friction** across this workflow was that the agent never confirmed the tech stack before generating code. Wireframes used generic Tailwind, then prototype generation assumed defaults — which silently broke because the project had a custom design system. All of Issues 1–7 below are downstream effects of this one gap.

### Tech Stack Discovery — Ask This Before Phase 3 (Wireframing)

The agent MUST ask the user to confirm these 4 things during the brief/orientation phase, **before any wireframes are drawn**. Record the answers in the design brief and carry them forward to every subsequent phase.

| Question | Options |
|---|---|
| **1. Framework** | Vue 3 / React / other |
| **2. Tailwind version** | v3 (`tailwind.config.js` + postcss plugin) vs v4 (`@tailwindcss/vite`, `@theme` in CSS, no config file) |
| **3. Design system** | See table below |
| **4. Prototype entry point** | Separate `prototype/main.js` outside `src/` vs embedded in `src/` — affects `@source` paths and CSS import paths |

**Design system options and their implications:**

| Design system | Tailwind requirement | Token syntax | Component prefix |
|---|---|---|---|
| `@toge-design-system/toge` | v3 only (peer dep) | `spr-` Tailwind classes | `<TogeButton>`, `<TogeInput>` |
| Raw `style.css` tokens (this project) | v4 required | `bg-surface`, `text-strong`, `bg-mushroom-*` | None — plain HTML + Tailwind |
| None (vanilla) | v3 or v4 | Default Tailwind palette | None |

**Once confirmed, the agent must:**
- Never generate prototype code using default Tailwind color classes (`bg-gray-*`, `text-gray-*`, etc.) if a custom design system is in use
- Reference the correct token names from the confirmed design system when generating any component
- Pass the confirmed stack as a header comment in the first prototype file generated, e.g.:
  ```
  // Stack: Vue 3 · Tailwind v4 · Raw style.css tokens (no Toge)
  ```

---

## Issues Encountered

### Issue 1 — Tailwind v3/v4 Version Conflict

**What happened:** The starter repo shipped with Tailwind v3, but `src/style.css` used Tailwind v4 syntax (`@import 'tailwindcss'`, `@theme`, `@source`). PostCSS failed on startup.

**Fix:**
```bash
npm install tailwindcss@latest @tailwindcss/vite tw-animate-css
```
- Remove `tailwindcss` from `postcss.config.js` plugins (Vite handles it now)
- Replace `tailwind.config.js` with the `@tailwindcss/vite` Vite plugin

`vite.config.js`:
```js
import tailwindcss from '@tailwindcss/vite'
export default defineConfig({
  plugins: [tailwindcss(), vue()],
})
```

`postcss.config.js`:
```js
export default { plugins: { autoprefixer: {} } }
```

---

### Issue 2 — Vite Processes `tailwindcss/index.css` as a Standalone Module

**What happened:** After installing Tailwind v4, Vite tried to resolve `tailwindcss/index.css` as a standalone CSS module and ran the Oxide engine on it directly, producing:
```
Error: `@layer base` is not allowed here
```

**Fix:** Add a guard plugin in `vite.config.js` that short-circuits that module:
```js
const skipTailwindIndexPlugin = {
  name: 'skip-tailwindcss-index',
  enforce: 'pre',
  load(id) {
    if (id.endsWith('/tailwindcss/index.css')) return ''
  },
}

export default defineConfig({
  plugins: [skipTailwindIndexPlugin, tailwindcss(), vue()],
})
```

---

### Issue 3 — Toge Design System Incompatible with Tailwind v4

**What happened:** `@toge-design-system/toge` declares `tailwindcss@^3.0.0` as a peer dependency. Installing it alongside Tailwind v4 causes peer dep conflicts and style collisions.

**Fix:** Uninstall Toge entirely and use the raw design system tokens from `src/style.css` directly.
```bash
npm uninstall @toge-design-system/toge @toge-design-system/mcp-design-system-toge
```
Remove all Toge imports from `main.js`:
```js
// Remove these:
// import Toge from '@toge-design-system/toge'
// import '@toge-design-system/toge/style.css'
// import FloatingVue from 'floating-vue'
// app.use(FloatingVue)
// app.use(Toge)
```

---

### Issue 4 — Transitive Dependencies Lost After Toge Uninstall

**What happened:** `pinia` and `floating-vue` were transitive dependencies of Toge. Uninstalling Toge removed them from `node_modules`, breaking the prototype at runtime.

**Fix:** Explicitly reinstall the packages the prototype actually needs:
```bash
npm install vue-router pinia
```

---

### Issue 5 — Prototype and Wireframe Directories Not Scanned by Tailwind

**What happened:** `src/style.css` only had `@source` pointing at `./src/**`. The `prototype/` and `wireframes/` directories lived outside `src/`, so Tailwind never scanned them — all utility classes in those files were purged and silently became no-ops.

**Fix:** Add explicit `@source` directives to `src/style.css`:
```css
@source '../wireframes/**/*.vue';
@source '../prototype/**/*.vue';
@source '../prototype/**/*.js';
```

---

### Issue 6 — Custom Design System Clears ALL Default Tailwind Colors

**What happened:** `src/style.css` includes this block near the top of `@theme`:
```css
@theme {
  --color-*: initial;
}
```
This wipes every default Tailwind color. Any class using default palette colors (`bg-gray-*`, `text-gray-*`, `bg-red-*`, `bg-emerald-*`, `bg-blue-*`, etc.) silently renders nothing.

The AI-generated prototype screens used default Tailwind colors throughout, so buttons, backgrounds, and text all appeared unstyled.

**Fix:** Never use default Tailwind color classes in prototype files. Use only design system tokens. See the mapping table below.

---

### Issue 7 — `text-base` Naming Collision (Known Limitation)

**What happened:** The design system defines `.text-base` in `@layer components` as a text color:
```css
.text-base { color: var(--text-base); }
```
Tailwind also has `text-base` as a font-size utility (`font-size: 1rem`) in `@layer utilities`. When both appear on the same element — e.g. `class="text-xs text-base"` — the utilities layer wins for `font-size`, so `text-xs` (0.75rem) is overridden by `text-base` (1rem).

**Status:** Known design system naming limitation. The IDE will show `cssConflict` warnings. The color IS applied correctly; only the font-size is affected.

**Workaround:** Do not combine `text-base` with another font-size utility on the same element. Use `text-base` alone when 1rem font-size is acceptable, or use `text-strong` / `text-weak` instead when a specific font-size is also needed.

---

## Quick Reference — Color Token Mapping

When the AI generates prototype code using default Tailwind colors, replace them using this table:

| Default Tailwind class | Design system token |
|---|---|
| `bg-gray-100`, `min-h-screen bg-gray-100` | `bg-surface` |
| `bg-gray-50` | `bg-mushroom-50` |
| `bg-gray-200` | `bg-mushroom-200` |
| `bg-white` | `bg-white` ✓ (still works) |
| `text-gray-900`, `text-gray-800` | `text-strong` |
| `text-gray-600`, `text-gray-500`, `text-gray-700` | `text-base` |
| `text-gray-400` | `text-weak` |
| `border-gray-200` | `border-mushroom-200` |
| `border-gray-100` | `border-mushroom-100` |
| `border-gray-300` | `border-mushroom-300` |
| `bg-gray-800` (primary buttons) | `bg-surface-inverted` |
| `hover:bg-gray-700` | `hover:bg-mushroom-900` |
| `hover:bg-gray-50` | `hover:bg-mushroom-50` |
| `hover:bg-gray-100` | `hover:bg-mushroom-100` |
| `hover:text-gray-900` | `hover:text-strong` |
| `bg-red-50`, `bg-red-100` | `bg-danger-subtle` |
| `border-red-200`, `border-red-300` | `border-danger-subtle` |
| `border-red-400`, `border-red-500` | `border-danger` |
| `text-red-400`, `text-red-500`, `text-red-600`, `text-red-700` | `text-danger` |
| `bg-red-400`, `bg-red-500` | `bg-danger` |
| `bg-emerald-50`, `bg-emerald-100` | `bg-success-subtle` |
| `text-emerald-600`, `text-emerald-700` | `text-success-text` |
| `border-emerald-200` | `border-success-subtle` |
| `bg-blue-50`, `bg-blue-100` | `bg-information-subtle` |
| `text-blue-600`, `text-blue-700`, `text-blue-800` | `text-information-text` |
| `border-blue-100`, `border-blue-200` | `border-information-subtle` |
| `bg-gray-200 text-gray-400` (disabled) | `bg-surface-disabled text-disabled` |

---

## Config Files to Verify Before Each Prototype Session

- [ ] **`vite.config.js`** — has `skipTailwindIndexPlugin` + `tailwindcss()` (no `tailwind.config.js`)
- [ ] **`postcss.config.js`** — only `autoprefixer`, no `tailwindcss` plugin
- [ ] **`src/style.css`** — has `@source` directives for `prototype/` and `wireframes/`
- [ ] **`package.json`** — `tailwindcss` is v4+, `pinia` and `vue-router` are explicit deps (not transitive)
- [ ] **`prototype/main.js`** — no Toge imports; imports `../src/style.css`, `pinia`, `vue-router`
