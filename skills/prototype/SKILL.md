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

**Input:** Wireframes in `wireframes/` + `DESIGN_SYSTEM` context + screen spec flow
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
| 5 | **Toge sanity check** | This skill assumes Toge (shadcn-vue registry). Verify `components.json` exists and has `registries["@toge"]`. If missing or the registry is absent, surface a warning via `AskUserQuestion` before continuing. **Never call `mcp__design-system-toge__*` tools** — the MCP server returns stale, incorrect data for Toge. Use the CLI installer and installed files in `src/components/ui/` only. |
| 6 | **Full component catalog enumerated** | Before writing any prototype code OR hand-building any component, enumerate the **complete** Toge catalog from the registry's `items[].name` (see **Check 6 — enumeration detail** below) and verify which sources are already installed in `src/components/ui/`. Read each installed component's source for its real prop signatures, variants, sizes, and slot names. **A primitive that exists in the catalog must never be hand-built.** Discovery must happen before the first line of prototype code. |

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

**Interactive CLI scripts (readline/promises):** If a setup script uses Node's `readline/promises` and piped input (`printf "...\n" | node script.mjs`) fails silently after one attempt, stop immediately. Do not retry the same pipe pattern. Tell the user: "This script requires a TTY — run it interactively with `! node /path/to/script.mjs`."

### Check 6 — enumeration detail (do this exactly)

The authoritative source is the registry's top-level `items[].name` list. Enumerate it with:

```bash
curl -s https://toge-ds.azurewebsites.net/registry.json \
  | python3 -c "import sys,json;[print(i['name'],'—',i.get('description','')) for i in json.load(sys.stdin)['items']]"
```

This returns ~69 UI components (`ui/toge-*`) plus block components (`platform/*`, `fintech/*`, `sidekick/*`) — ~74 items total. Item paths are prefixed `toge-`: `https://toge-ds.azurewebsites.net/r/ui/toge-<name>.json`. The registry index is at `/registry.json` (**not** `/r/registry.json`).

**⚠️ Anti-pattern — do NOT do this.** Never derive the component list by grepping `registryDependencies` URLs (e.g. `grep -oE 'r/ui/toge-[a-z-]+\.json'`). Those arrays contain only components that happen to be *dependencies of other components* — roughly the ~29 transitively-referenced ones — and silently hide the rest, including `toge-sidebar`, `toge-sonner`, `toge-progress`, `toge-select`, `toge-switch`, `toge-radio-group`, `toge-alert`, `toge-alert-dialog`, `toge-data-table`, `toge-stepper`, `toge-combobox`, `toge-drawer`, `toge-dropdown-menu`, and `toge-breadcrumb`. **Always read `items[].name`.**

**Decision rule once the catalog is in hand:**
- **Primitive** (button, input, select, toast, progress, sidebar, dialog, table, switch, alert, tabs, tooltip…) → MUST be installed from the registry if it exists. Reimplementing one is a pre-flight failure.
- **Composed app component** (one that *combines* Toge primitives for app-specific logic — e.g. `EmployeeAvatar`, `StatusBadge`, `RatingScale`) → legitimately custom. Custom is fine when it **composes** primitives; never when it **reimplements** one.

If a primitive you need is missing from the catalog, only then compose from existing primitives, and flag it at check-in. The `guide/toge-design-system/README.md` catalog is for *selecting* a component (it states when to pick one over its sibling); `items[].name` is the source of truth for *what exists*.

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

This skill uses **Toge** (shadcn-vue registry). Read `guide/toge-design-system/README.md` before writing any component.

- Components are pulled via `npx shadcn-vue@latest add https://toge-ds.azurewebsites.net/r/ui/[component].json`
- Import from `@/components/ui/[component-name]`
- Do NOT call `mcp__design-system-toge__*` tools — the MCP server returns stale, incorrect data for Toge. Use only the installed files in `src/components/ui/` and `guide/toge-design-system/`.

**Hard rule:** Never use raw hex colors or grayscale placeholders from the wireframe.
Every color in the prototype must come from the design system.

**Token enforcement:** Read `guide/toge-design-system/tokens/token-mapping.yaml` before writing any component. Every default Tailwind color class (`bg-gray-*`, `text-gray-*`, `bg-red-*`, `bg-emerald-*`, `bg-blue-*`, `bg-yellow-*`, `bg-orange-*`) is a violation — replace it with the mapped token before committing output. The design system clears all default Tailwind colors (`--color-*: initial`) so these classes silently render nothing at runtime.

**Known naming collision — read before writing any text class:** Do not combine `text-base` with another font-size utility on the same element. The design system defines `.text-base` as `color: var(--text-base)` in `@layer components`, but Tailwind also defines `text-base` as `font-size: 1rem` in `@layer utilities`. The utilities layer wins for `font-size`, so `text-xs text-base` silently becomes 1rem. Use `text-base` alone when 1rem font-size is acceptable, or use `text-strong` / `text-weak` when a specific font-size is also needed.

### Using Toge components

Toge components are installed in `src/components/ui/`. Before using one, **read its source file** (Step 0, check 6) to get the real variants, sizes, props, and sub-component names — never reconstruct the API from memory. The names below are illustrative; the installed source is authoritative.

#### Install discipline — per-component, continuously, read before write

Install Toge components **one at a time, only as the flow needs them** — never bulk-install the whole registry. The registry is **remote** (base URL `https://toge-ds.azurewebsites.net/r`); the CLI *pulls* from it *into this project* at `src/components/ui/toge-[name]/`. Nothing is ever written back to the registry, and components are not staged inside `toge-ds-components` — they land in *your* project.

1. **Enumerate the full catalog first.** Get the *authoritative* component list from the registry's `items[].name` per **Step 0 — Check 6 enumeration detail** (never from `registryDependencies` — that hides most of the catalog and is exactly how primitives like `toge-sidebar`, `toge-sonner`, and `toge-progress` get reinvented).
2. **Plan the set up front.** From the wireframes + flow (Step 1), list every Toge component the whole prototype needs — the *component manifest* — matching each UI need to a slug from the enumerated catalog (cross-check `guide/toge-design-system/README.md` for which component to pick over its sibling).
3. **Install the manifest in one batch**, then read each installed source before writing screens.
4. **Continuous gate — any screen, any time.** Before writing *any* `<Toge*>` tag, including on screens added later in the session, check `src/components/ui/`. If the component's source isn't there, install it from the registry (`npx shadcn-vue@latest add https://toge-ds.azurewebsites.net/r/ui/[component].json`, or the `@toge` alias: `npx shadcn-vue@latest add @toge/toge-[name]`) and read it *before* using it. The pre-flight check in Step 0 only covers the first pass — this gate covers everything after.
5. **Verify existence against the directory, not the README.** After installing, treat `src/components/ui/` as the source of truth for what exists. The README is for *selecting* a component; the installed directory is for *confirming* it is present.

**Hard rule — no read, no tag.** Never emit a `<Toge*>` tag whose installed source file you have not read **this session**. Props, variants, sizes, and sub-component names come from the source file — never from memory, and never from `mcp__design-system-toge__*` (stale, incorrect). If you have not read it, you may not write it.

**Hard rule — never reinvent a catalog component.** Before hand-building any *primitive* (button, input, select, toast, progress, sidebar, dialog, table, switch, alert, tabs, tooltip, stepper, combobox, drawer…), confirm it is absent from the *full* catalog (`items[].name`), not just from `src/components/ui/` — a primitive missing locally usually means it was never installed, not that it doesn't exist. If a matching primitive exists in the registry, install it; do not reimplement it. Hand-building is legitimate only for *composed app components* that combine Toge primitives for app-specific logic (e.g. an `EmployeeAvatar`, `StatusBadge`, `RatingScale`) — never for a primitive the registry already ships.

**Drive appearance through props, not utilities.**
- Style a component through its own `variant` and `size` props — `<TogeButton variant="destructive" size="sm">`, `<TogeBadge variant="outline">`. Do not reach for Tailwind utilities that fight the component's built-in styles (e.g., re-coloring a button with `bg-*` instead of choosing the right `variant`).
- Reserve utility classes for *layout around* the component — margin, width, grid placement — not for restyling its internals.
- For a legitimate one-off tweak, pass the component's `class` prop (Toge merges it via `cn`). Never wrap a component in extra `<div>`s to force a style, and never fork its internals inline.

**Use the full compound component, not a monolith.** Toge components ship as a set of sub-components meant to be used together — don't dump everything into the root element:
- `Card` → `CardHeader` / `CardTitle` / `CardDescription` / `CardContent` / `CardFooter`
- `Dialog` → `DialogTrigger` / `DialogContent` / `DialogHeader` / `DialogTitle` / `DialogDescription` / `DialogFooter`
- `Form` → `FormField` / `FormItem` / `FormLabel` / `FormControl` / `FormMessage`
- `Select` → `SelectTrigger` / `SelectValue` / `SelectContent` / `SelectItem`

Put content in the documented slot rather than bypassing it with raw markup. For triggers, wrap the opener in the `*Trigger` and use `asChild` to pass your own `<TogeButton>` instead of nesting a button inside a button. Import each sub-component using the exact export names from the installed module's index.

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

**Sidebar rule:** whenever the prototype has a persistent app navigation shell — whether you're building it from scratch or replacing/overriding an existing layout — the sidenav is always `Sidebar` (`toge-sidebar`), never a hand-built nav rail. It is the app shell's primary navigation (`TogeSidebarProvider` + `TogeSidebarInset` for main content → `TogeSidebar collapsible="icon"` → Header / Content with `TogeSidebarGroup` > `TogeSidebarMenuButton` / Footer). Read the installed source for its real sub-component names before wiring it.

---

## Step 4 — Implement Each Screen

### Teardown before building

Before touching any screen code:

1. **Delete the tab/screen switcher** — any `<select>`, tabbed `<nav>`, or conditional render used to flip between wireframe screens is a Phase 3 debugging aid, not a product nav pattern. Remove it entirely.
2. Rebuild navigation as `vue-router` named routes. Every screen gets its own route.

If any tab navigation component survives into Step 4, Phase 4 is not done.

---

Work through screens in flow order (start → end). For each screen:

### Replace wireframe placeholders
- ALL CAPS labels → real product-specific text
- Grayscale placeholder blocks → actual design system components
- `bg-gray-*` color blocks → design system token classes
- Dashed border boxes → real content (charts can stay as styled placeholders if complex)

**Reach for an installed Toge primitive before hand-building.** Match each placeholder to the component that already solves it:

| UI need | Toge component |
|---|---|
| Confirm a destructive action | `Alert Dialog` |
| Modal / focused task overlay | `Dialog` |
| Side panel that slides in from an edge | `Sheet` (`toge-sheet`) — never hand-build a sliding panel; use `Drawer` only for touch-first/bottom sheets |
| App navigation / persistent left nav rail | `Sidebar` (`toge-sidebar`) — the app shell; never hand-build a sidenav |
| Menu of actions from a trigger | `Dropdown Menu` |
| Pick one option from a list | `Select` (or `Combobox` when searchable) |
| Static tabular data (no interaction) | `Table` |
| Table with search, filters, sorting, or pagination | `Data Table` **with its built-in toolbar** — never hand-build a search box + filter dropdowns floating above a plain `Table` |
| On/off setting | `Switch` |
| User or company/entity avatar | `Avatar` (`toge-avatar`) — never hand-build an initials circle or `<img>` wrapper |
| Status / category label | `Badge` |
| Inline contextual message | `Alert` |
| Transient notification | `Sonner` (toast) |
| Loading placeholder | `Skeleton` or `Progress` |
| Expand/collapse stacked sections | `Accordion` (`toge-accordion`) — never hand-build; a single show/hide region is `Collapsible` |
| Hover / focus info | `Tooltip` or `Hover Card` |

**Table rule:** if a table is placed as the primary content of a page (a page-level table, not a small inline/embedded summary), always use `Data Table` **with its toolbar** — even before it obviously needs filtering. Reserve plain `Table` for small, static, embedded tables (e.g. a few rows inside a card). Never hand-build a search box + filter dropdowns floating above a plain `Table`.

**Avatar rule:** any avatar — a user *or* a company/entity — is always `Avatar` (`toge-avatar`), using its built-in initials fallback (and optional status dot). Never hand-build an initials circle (`<div class="rounded-full">`) or a bare `<img>` wrapper.

**Sheet rule:** any side panel that slides in from a screen edge (filters, detail panel, contextual editor) is always `Sheet` (`toge-sheet`) — never a hand-built sliding `<div>` with translate transitions. Use `Drawer` only for touch-first/bottom sheets, and `Dialog` for a centered modal.

**Form fields rule:** whenever you build a form — on a page, in a panel, or in a card — every field is a Toge form-family primitive. Never hand-build an `<input>`, `<select>`, `<textarea>`, checkbox, or radio with raw HTML or styled `<div>`s. For multi-field forms wrap them in `toge-form` (`TogeForm` + `TogeFormField`/`Item`/`Label`/`Control`/`Description`/`Message`) so validation, `aria-invalid`, and error copy are wired automatically; pair every field with `toge-label`. Match each field to the primitive:

| Field captures | Toge component |
|---|---|
| Short free-form text (name, title) | `toge-input` |
| Multi-line text / notes | `toge-textarea` |
| Email address | `toge-email-input` |
| URL | `toge-url-input` |
| Phone number (with country code) | `toge-phone-number-input` |
| Bounded number with steppers | `toge-number-field` |
| Fixed-length code (OTP, 2FA, PIN) | `toge-pin-input` |
| Text field with icons/prefix/suffix/inline buttons | `toge-input-group` |
| Live in-page search field | `toge-search-input` |
| Command palette (⌘K) | `toge-command` |
| Pick one from a static list (~3–25) | `toge-select` |
| Native/mobile-rendered select | `toge-native-select` |
| Searchable single-select (10+/async, typeahead) | `toge-combobox` |
| Free-form multi-value chips (emails, tags) | `toge-tags-input` |
| One of 2–5 visible options | `toge-radio-group` |
| Binary choice / multi-select list | `toge-checkbox` |
| Instant on/off setting | `toge-switch` |
| Single date | `toge-date-picker` |
| Time (HH MM AM/PM) | `toge-time-picker` |
| File upload (drag-and-drop) | `toge-file-upload` |
| Field label | `toge-label` |

(See the **Form Handling** subsection below for validation, submission, and error-display patterns once the fields are in place.)

**Accordion rule:** any expand/collapse UI made of stacked sections (FAQs, grouped settings, disclosure lists) is always `Accordion` (`toge-accordion`) — never a hand-built toggle with `v-if`/`v-show` and rotating chevrons. For a *single* standalone show/hide region, use `Collapsible` (`toge-collapsible`).

**Every other UI need maps to a primitive too — never hand-build these.** The tables above cover the most common needs; the groups below cover the rest of the registry by usage. If your need matches a row, install and use that component. Sibling hints (→) point to the component to pick instead when the need is slightly different.

*Actions & triggers*

| UI need | Toge component |
|---|---|
| Trigger an action or submit | `Button` (`toge-button`) — style via its `variant`/`size` props, not utilities |
| Joined set of related buttons (split button, connected toolbar) | `Button Group` (`toge-button-group`) |
| Single two-state toolbar toggle (bold, mute) | `Toggle` (`toge-toggle`) → on/off *setting* = `Switch` |
| Set of toggle buttons (alignment, view density) | `Toggle Group` (`toge-toggle-group`) → swap *views* = `Tabs` |
| Persistent action docked to a screen edge | `Floating Action` (`toge-floating-action`) |

*Navigation*

| UI need | Toge component |
|---|---|
| Switch between sibling views/panels in place | `Tabs` (`toge-tabs`) |
| Location trail in a hierarchy | `Breadcrumb` (`toge-breadcrumb`) |
| Top-level site/app nav with flyout panels | `Navigation Menu` (`toge-navigation-menu`) |
| App menu bar with cascading menus (File / Edit / View) | `Menubar` (`toge-menubar`) |
| Split a long list across pages | `Pagination` (`toge-pagination`) |
| App-shell ⌘K spotlight search | `Global Search` (`platform/global-search`) — composes Dialog + Command |

*Overlays & menus*

| UI need | Toge component |
|---|---|
| Click-triggered floating panel (mini-form, picker) | `Popover` (`toge-popover`) → hover-only preview = `Hover Card` |
| Right-click / long-press menu | `Context Menu` (`toge-context-menu`) |
| Layered side panels (drill-down / sub-nav) | `Stacked Sheet` (`toge-stacked-sheet`) → single panel = `Sheet` |

*Selection & dates* (text/number/choice fields are in the **Form fields rule** above)

| UI need | Toge component |
|---|---|
| Grid of selectable option cards (label + description) | `Choicebox` (`toge-choicebox`) |
| Drag-to-set a number along a track | `Slider` (`toge-slider`) → typed bounded number = `Number Field` |
| Always-visible inline single-date grid | `Calendar` (`toge-calendar`) → compact trigger+popover = `Date Picker` |
| Always-visible inline start–end range grid | `Range Calendar` (`toge-range-calendar`) |

*Layout & containers*

| UI need | Toge component |
|---|---|
| Group related content into a surface | `Card` (`toge-card`) — use header/content/footer slots |
| Swipeable set of slides | `Carousel` (`toge-carousel`) |
| Lock media to a fixed width:height ratio | `Aspect Ratio` (`toge-aspect-ratio`) |
| Divider line between content | `Separator` (`toge-separator`) → draggable split = `Resizable` |
| Resizable split panes | `Resizable` (`toge-resizable`) |
| Custom styled scroll region | `Scroll Area` (`toge-scroll-area`) |
| Multi-step flow / wizard indicator | `Stepper` (`toge-stepper`) → simple completion = `Progress` |

*Feedback & AI surfaces*

| UI need | Toge component |
|---|---|
| AI/agent-styled banner (glowing halo) | `Agent Banner` (`toge-agent-banner`) → standard notice = `Alert` |
| Conversational / AI message thread | `Chat` (`toge-chat`) + composer `Chat Input` (`toge-chat-input`) |
| Show an AI agent's reasoning steps | `Chat Thought Process` (`toge-chat-thought-process`) |

See the full component list in `guide/toge-design-system/README.md`. If no primitive fits, compose one from existing components; only hand-build from raw markup as a last resort, and flag it at check-in. Never rebuild a primitive that already exists in `src/components/ui/`.

**Phase 4 is not complete if any of these exist:**
- Any `bg-gray-*` class used as a placeholder fill
- Any arbitrary hex value (`text-[#333]`, `bg-[#F5F6F6]`, etc.)
- Any `<div>` or `<span>` standing in for a real component (icon blocks, card skeletons, mock borders)

Run a final scan before check-in: search for `bg-gray-`, `[#`, and placeholder-pattern divs. If found, replace before declaring done.

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

- **Validation**: Show inline errors on blur (field loses focus), not on submit. Place error message directly below the field. **Exception:** dependent fields (e.g., "confirm password") should only validate after the primary field has a value — not on first blur of the dependent field alone.
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
| Components via props, not utilities | Style Toge components through their `variant`/`size` props and `class` prop (merged via `cn`) — never restyle internals with conflicting utilities, and never rebuild a primitive that exists in `src/components/ui/`. Use the full compound component (e.g. `CardHeader`/`CardContent`), not the root element alone. |
| No hardcoded data | Mock data lives in composables, never inline in templates |
| Composables return reactive state | `return { items, isLoading, selectedItem }` — not raw arrays |
| Stores are lean | Pinia stores hold only **cross-screen state** — any value read or written by 2+ screens. Local UI state (open/closed, selected tab, form field value) stays in the screen component as `ref`. When in doubt, keep it local until a second screen needs it. |
| Double quotes for natural language | Use double quotes for any string containing natural language: `"Here's your payslip"`. Reserve single quotes for identifiers and keys guaranteed not to contain apostrophes. Single-quoted strings with apostrophes (`'Here's your...'`) close the string literal early and cause Vue SFC compiler errors. |
| `components.json` — no undocumented keys | Valid top-level keys: `$schema`, `style`, `typescript`, `tailwind`, `aliases`. Never add inferred keys (e.g., `"framework"`). If unsure, run `npx shadcn-vue@latest init --defaults` and use the generated file as-is. |
| tsconfig alias — patch both files | When adding `@/*` path aliases in a Vite + Vue project, add `compilerOptions.paths` to both `tsconfig.json` (for shadcn-vue init validator) and `tsconfig.app.json` (for the TypeScript compiler). Patching only one causes silent shadcn-vue init failures. |

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

## UIFork Usage

UIFork (`uifork-vue`) is a **component-level design exploration tool** — it lets you switch between parallel versions of a single component without reloads. Each version is a separate file (`Button.v1.vue`, `Button.v2.vue`); a generated wrapper renders the active version controlled by the UIFork widget.

**Install:** `npm install uifork-vue@github:maaraquel08/design-fork`

**Mount the widget once at root:**
```vue
<!-- App.vue -->
<script setup>
import { UIFork } from "uifork-vue"
const isDev = import.meta.env.DEV
</script>
<template>
  <RouterView />
  <UIFork v-if="isDev" />
</template>
```

**Initialize a component for versioning:**
```bash
npx uifork-vue src/components/PayslipCard.vue
# Creates PayslipCard.v1.vue, PayslipCard.versions.ts, PayslipCard.vue (wrapper)
```

**Promote the winning version when done:**
```bash
npx uifork-vue promote PayslipCard v2
# Replaces PayslipCard.vue with v2 content, removes all version files
```

**Use UIFork for:**
- Exploring 2–3 layout alternatives for the same component
- Comparing interaction models side-by-side with real app state
- Gathering stakeholder feedback on UI variants before committing

**Do NOT use UIFork for:**
- Sequential screen transitions or flow navigation — use `vue-router` named routes
- Chat-style message accumulation — use reactive state (`ref`/`reactive`)
- Any pattern where screens build on each other's output

The widget stores the active version in localStorage. It has no programmatic API for sequential advancement — attempting to drive a multi-step flow through `ForkedComponent` will break cumulative UI patterns and has no reset path.

---

## Prototype Conventions

- **Realistic content** — use plausible names, dates, amounts, and statuses. Not "John Doe", "01/01/2024", or "Lorem Ipsum".
- **No backend** — mock all data in composables. Simulate async with `setTimeout` (300–800ms) where latency would be visible.
- **Accessible markup** — `<button>` for actions, `<a>` or `<router-link>` for navigation, every `<input>` has a `<label>`.
- **Desktop-first** — design for 1280px+. No need to be fully responsive unless the brief specifies mobile.
- **Design tokens only** — no raw hex, no arbitrary Tailwind values (`text-[#333]` is a violation).

### Typography (always applied — not optional)

Apply these to every screen during Step 4. They are baseline quality, not a polish pass.

- Add `-webkit-font-smoothing: antialiased` to the root element if not already present
- Apply `text-wrap: balance` to all headings and short labels (≤6 lines)
- Apply `text-wrap: pretty` to body paragraphs and descriptions
- Add `tabular-nums` to any number that updates dynamically (counters, prices, timers)

### Surfaces (always applied — not optional)

Apply these to every screen during Step 4. They are baseline quality, not a polish pass.

- Audit every nested card/container pair — verify `outerRadius = innerRadius + padding`
- **Flat surfaces and cards** — use `border` and `border-weak` (no shadow)
- **Elevated surfaces** (popover, modal, dropdown panels, etc.) — same `border` and `border-weak`, plus layered `box-shadow` for lift
- Add `outline outline-1 -outline-offset-1 outline-black/10` to any `<img>` element
- Ensure every small interactive element (icon buttons, checkboxes) has a minimum 40×40px hit area

---

## Check-in

After all screens are implemented, list the output files with a one-line description of each.
Then use `AskUserQuestion`:

> "All [N] screens are wired up and interactive. Want to walk through any screen, adjust an
> interaction, or add a missing state before this is ready for frontend handoff?"
