---
name: toge:prototype
description: >
  Turns wireframes into a fully interactive Vue 3 prototype that users can feel, navigate, and
  experience. Use when converting wireframes to a clickable prototype, making screens interactive,
  building a prototype for user testing, or preparing frontend-ready code from a design workflow.
  Trigger phrases: "prototype", "make it interactive", "bring it to life", "clickable prototype",
  "wire the screens together", "add interactions", "turn wireframes into a prototype".
---

## Overview

This skill takes wireframe `.vue` files (from the wireframing skill) and produces a runnable,
interactive Vue 3 prototype. The output is a `prototype/` directory — multiple screens connected
by real navigation, with actual design system components, live state, and meaningful interactions.

**Input:** Wireframes in `wireframes/` + `DESIGN_SYSTEM` context + Phase 3 user flow diagram
**Output:** Runnable `prototype/` directory

**Scope:**
- Frontend only — no backend calls, no real APIs
- State via `ref`/`reactive` for local state, Pinia only if state is shared across screens
- Focus on experience: interactions, transitions, realistic content, edge states

---

## Step 0 — Pre-flight Check

Before reading wireframes or writing any code, verify the project environment using the confirmed `// Stack:` context. Run each check against the actual project files. If a check does not apply to the confirmed stack, skip it with a one-line note.

| # | Check | What to verify |
|---|---|---|
| 1 | **CSS pipeline consistency** | Does the build tool config match the CSS syntax in the project's stylesheet? Flag if a v3-style `tailwind.config.js` + postcss plugin exists alongside v4 `@import 'tailwindcss'` syntax, or vice versa. Fix before proceeding. |
| 2 | **Source scanning completeness** | Does the bundler scan every directory containing component files? Verify that `wireframes/`, `prototype/`, and any directory outside the default source root is included in `@source` directives (v4) or `content` globs (v3). Add missing entries before proceeding. |
| 3 | **Package compatibility** | Are all design system packages compatible with the confirmed framework and CSS version? Check for peer dependency conflicts (e.g. a design system that pins `tailwindcss@^3` installed alongside v4). Uninstall incompatible packages before proceeding. |
| 4 | **Explicit dependencies** | Are routing and state management packages explicitly declared in `package.json`? Never assume transitive dependencies — if the prototype needs `vue-router` or `pinia`, they must be listed directly. Install any missing explicit deps before proceeding. |

**If any check fails: stop immediately. Do not generate any files.**

**If a check reveals a potential concern but not a definitive failure** (e.g., both `tailwind.config.js` and v4 `@import 'tailwindcss'` exist but are not yet conflicting): surface it as a warning via `AskUserQuestion` — report what was found, explain the risk, and ask if the user wants to resolve it before continuing. Do not block on warnings, but document them at the top of the first generated file:
```js
// Pre-flight warning: [description of concern]
```

Surface the issue via `AskUserQuestion` with:
1. What was found (e.g., "Missing `@source` directive for `wireframes/` in your CSS config")
2. What the fix is (e.g., "Add `@source '../wireframes/**/*.vue'` to your `app.css`")
3. The question: "Should I apply this fix before continuing?"

Only proceed after the user confirms. When proceeding, add a comment at the top of the first generated file documenting what was changed:
```js
// Pre-flight fix applied: [description of what was changed]
```

Do not advance to Step 1 until all applicable checks pass and any fixes are confirmed.

---

## Step 1 — Read the Wireframes

Before writing a single line of prototype code, read every file in `wireframes/`.

For each wireframe extract:
- **Screen name and role** — what this screen does in the flow
- **Layout regions** — which sections are navigation, content, actions, sidebars
- **User actions** — buttons, links, form inputs, toggles — anything a user can interact with
- **Navigation triggers** — which actions should move to another screen

Then re-read the Phase 3 user flow diagram. Map every wireframe to a node in the flow. If a
wireframe doesn't appear in the flow, flag it — it may be a secondary state of an existing screen
(e.g., empty state, error state, confirmation) rather than a standalone route.

---

## Step 2 — Read the Design System Guide

Check the `DESIGN_SYSTEM` value carried forward from the design brief:

- **Toge v1** → read `guide/toge-design-system-v1/README.md`
  - Use `spr-` prefixed components: `<spr-button>`, `<spr-input>`, `<spr-modal>`
  - Use `spr-` Tailwind tokens for color, typography, border-radius
- **Toge v2** → read `guide/toge-design-system-v2/README.md`
  - Components were pulled via `npx shadcn-vue@latest add https://toge-ds.azurewebsites.net/r/ui/[component].json`
  - Import from `@/components/ui/[component-name]`

**Hard rule:** Never use raw hex colors or grayscale placeholders from the wireframe.
Every color in the prototype must come from the design system.

**Token enforcement (Toge v2):** If `DESIGN_SYSTEM` is **Toge v2**, read `guide/toge-design-system-v2/tokens/token-mapping.yaml` before writing any component. Every default Tailwind color class (`bg-gray-*`, `text-gray-*`, `bg-red-*`, `bg-emerald-*`, `bg-blue-*`, `bg-yellow-*`, `bg-orange-*`) is a violation — replace it with the mapped token before committing output. The design system clears all default Tailwind colors (`--color-*: initial`) so these classes silently render nothing at runtime.

**Known naming collision (Toge v2):** Do not combine `text-base` with another font-size utility on the same element. The design system defines `.text-base` as `color: var(--text-base)` in `@layer components`, but Tailwind also defines `text-base` as `font-size: 1rem` in `@layer utilities`. The utilities layer wins for `font-size`, so `text-xs text-base` silently becomes 1rem. Use `text-base` alone when 1rem font-size is acceptable, or use `text-strong` / `text-weak` when a specific font-size is also needed.

**Token enforcement (Toge v1):** If `DESIGN_SYSTEM` is **Toge v1**, tokens use the `spr-` prefix. Read `guide/toge-design-system-v1/README.md` for the token list. No separate mapping file needed.

---

## Step 3 — Scaffold the Prototype

**First action — write the stack context header.** Before creating any files, write the confirmed stack as a comment on the first line of the prototype entry file (`main.js` or equivalent):

```js
// Stack: {STACK_FRAMEWORK} · {STACK_TAILWIND_VERSION} · {DESIGN_SYSTEM} · entry: {STACK_ENTRY_POINT}
```

Example:
```js
// Stack: Vue 3 · Tailwind v4 · Toge · entry: prototype/main.js
```

Every subsequent code generation step in this session reads this header first. If a new file needs to be generated mid-session, check this header before writing any class. The header is the anchor that prevents silent stack assumption.

Create this directory structure:

```
prototype/
├── App.vue              ← router root + persistent layout shell (sidenav, topbar if needed)
├── router.js            ← vue-router config; one named route per screen
├── stores/              ← Pinia stores (only if state is shared across 2+ screens)
│   └── use[Feature]Store.js
├── composables/         ← all mock data and reusable logic lives here
│   └── use[Feature].js
├── components/          ← shared UI pieces used in 2+ screens
│   └── [ComponentName].vue
└── screens/             ← one file per screen
    ├── 01-[screen-name].vue
    ├── 02-[screen-name].vue
    └── ...
```

**router.js pattern:**
```js
import { createRouter, createWebHashHistory } from 'vue-router'

const routes = [
  { path: '/', redirect: '/[first-screen]' },
  { path: '/[screen]', name: '[Screen]', component: () => import('./screens/01-[screen].vue') },
]

export default createRouter({ history: createWebHashHistory(), routes })
```

**App.vue pattern:**
```vue
<script setup>
import { RouterView } from 'vue-router'
</script>

<template>
  <!-- Persistent shell: sidenav, topbar, etc. -->
  <RouterView />
</template>
```

---

## Step 4 — Implement Each Screen

Work through screens in flow order (start → end). For each screen:

### Replace wireframe placeholders
- ALL CAPS labels → real product-specific text
- Grayscale placeholder blocks → actual design system components
- `bg-gray-*` color blocks → design system token classes
- Dashed border boxes → real content (charts can stay as styled placeholders if complex)

### Add interactions
Every user action identified in Step 1 must do something:
- **Navigation actions** → `router.push({ name: '...' })` or `<router-link>`
- **Form inputs** → bound to reactive state with `v-model`
- **Toggles, tabs, accordions** → local `ref` state
- **Destructive actions** → confirmation modal before executing
- **Submit / save** → show loading state (150ms min) then success feedback

### Add edge states
For each screen, implement the states the journey map flagged as pain points:
- **Empty state** — what the screen looks like before any data exists
- **Loading state** — skeleton or spinner while "fetching"
- **Error state** — what happens when something goes wrong
- **Success feedback** — snackbar, banner, or inline confirmation

### Form Handling

Every form in the prototype follows these patterns:

- **Validation**: Show inline errors on blur (field loses focus), not on submit. Place error message directly below the field.
- **Submission feedback**: Disable the submit button and show a spinner during the pending state. Minimum 300ms simulated delay so the state is visible.
- **Error display**: Always use text + color + icon together — never color alone (accessibility requirement).
- **Success**: Either navigate away OR show inline confirmation — never both. If navigating, pass a success flag via router state to show a toast on the destination screen.

```vue
<!-- Example: form submission pattern -->
<script setup>
const isSubmitting = ref(false)
const error = ref(null)

async function handleSubmit() {
  isSubmitting.value = true
  error.value = null
  await new Promise(r => setTimeout(r, 500)) // simulate async
  // success: navigate away
  router.push({ name: 'SuccessScreen' })
  // or error:
  // error.value = 'Something went wrong. Please try again.'
  // isSubmitting.value = false
}
</script>

<template>
  <button :disabled="isSubmitting" @click="handleSubmit">
    <span v-if="isSubmitting">
      <SpinnerIcon class="animate-spin" /> Saving…
    </span>
    <span v-else>Save</span>
  </button>
  <p v-if="error" class="text-danger-text flex items-center gap-1">
    <ErrorIcon /> {{ error }}
  </p>
</template>
```

### Transitions
Use `<Transition>` for:
- Modal/drawer open and close
- Panel slide-in (detail panels, side panels)
- Page-level route transitions (optional — `fade` is enough)

Do NOT add transitions to every element. Only where they communicate state change.

### Navigation
```vue
<!-- Correct -->
<router-link :to="{ name: 'ScreenName' }">Go to screen</router-link>
<button @click="router.push({ name: 'ScreenName' })">Continue</button>

<!-- Wrong -->
<a href="/screen">Go to screen</a>
```

---

## Code Quality Rules

These apply to every file in `prototype/`. The output must be clean enough for a Frontend Agent
to read and build production code from.

| Rule | Detail |
|---|---|
| Single responsibility | If a component exceeds ~80 lines of template, extract a child component |
| Props typed | `defineProps` with JSDoc types or TypeScript interface |
| Events declared | `defineEmits(['event-name'])` for every custom event |
| No inline styles | Tailwind classes + design system tokens only |
| No hardcoded data | Mock data lives in composables, never inline in templates |
| Composables return reactive state | `return { items, isLoading, selectedItem }` — not raw arrays |
| Stores are lean | Pinia stores hold only **cross-screen state** — any value read or written by 2+ screens. Local UI state (open/closed, selected tab, form field value) stays in the screen component as `ref`. When in doubt, keep it local until a second screen needs it. |

**Composable pattern:**
```js
// composables/useEmployees.js
import { ref } from 'vue'

const MOCK_EMPLOYEES = [
  { id: 1, name: 'Maria Santos', department: 'Engineering', status: 'active' },
  { id: 2, name: 'Juan dela Cruz', department: 'Design', status: 'on-leave' },
]

export function useEmployees() {
  const employees = ref(MOCK_EMPLOYEES)
  const selected = ref(null)
  const isLoading = ref(false)

  function select(employee) {
    selected.value = employee
  }

  return { employees, selected, isLoading, select }
}
```

---

## Prototype Conventions

- **Realistic content** — use plausible names, dates, amounts, and statuses. Not "John Doe", "01/01/2024", or "Lorem Ipsum".
- **No backend** — mock all data in composables. Simulate async with `setTimeout` (300–800ms) where latency would be visible.
- **Accessible markup** — `<button>` for actions, `<a>` or `<router-link>` for navigation, every `<input>` has a `<label>`.
- **Desktop-first** — design for 1280px+. No need to be fully responsive unless the brief specifies mobile.
- **Design tokens only** — no raw hex, no arbitrary Tailwind values (`text-[#333]` is a violation).

---

## Check-in

After all screens are implemented, list the output files with a one-line description of each.
Then use `AskUserQuestion`:

> "All [N] screens are wired up and interactive. Want to walk through any screen, adjust an
> interaction, or add a missing state before this is ready for frontend handoff?"
