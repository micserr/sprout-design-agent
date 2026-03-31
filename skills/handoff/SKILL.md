---
name: handoff
description: >
  Developer handoff pass — cleans and restructures prototype code for production readiness.
  Splits oversized components, extracts composables, types all props/emits, removes prototype
  artifacts (mock delays, console.logs, placeholder comments), and verifies file structure.
  Trigger phrases: "ready for handoff", "clean up the code", "handoff pass", "production ready",
  "prepare for dev", "clean for frontend".
---

# Developer Handoff

This skill turns a working prototype into clean, modular, handoff-ready code that a frontend developer can build production features from without needing to untangle prototype shortcuts.

**Input:** A completed `prototype/` directory
**Output:** The same directory, refactored — no behavior changes, no new features

---

## What This Pass Does NOT Do

- Change behavior or interactions
- Add new screens or states
- Fix design decisions
- Replace mock data with real API calls (that's the developer's job)

If something needs to be redesigned, surface it as a comment — don't fix it here.

---

## Step 1 — Read Every File First

Before changing anything, read all files in `prototype/`. Build a mental map of:
- Which components are doing too much
- Where state lives vs. where it's used
- What's prototype-only code (timeouts, fake data inline, console.logs)
- What props/emits are untyped

---

## Step 2 — Component Splitting

Split any component where **any** of these is true:

| Signal | Action |
|---|---|
| Template exceeds ~80 lines | Extract the largest independent section into a child component |
| Component handles both data orchestration AND rendering | Separate into a container + presentational pair |
| A template block is repeated 2+ times | Extract into a shared component |
| A screen has 3+ distinct UI sections | Each section gets its own component |

**Route/screen-level components** (files in `screens/`) must stay thin — app shell, layout, and feature composition only. Full feature implementations belong in child components.

**Naming:** PascalCase for components, one clear responsibility per name (`PayslipCard`, not `PayslipCardAndActions`).

**After splitting**, verify the parent passes props down and receives events up. No side effects in presentational components.

---

## Step 3 — Composable Extraction

Extract into a composable when:
- The same state or logic is read/written by 2+ components
- A component has side-effect logic (simulated async, filtering, sorting) mixed into its `<script setup>`
- Mock data is defined inline in the template or script — move it to a composable

**Composable rules:**
- File: `composables/use[Feature].js` (or `.ts` if the project uses TypeScript)
- Always return named reactive state: `return { items, isLoading, selectedItem, select }`
- Never return raw arrays or plain values — wrap in `ref`
- Keep composable APIs small: one feature domain per composable

**Example extraction:**
```js
// Before: inline in screen component
const employees = ref([{ id: 1, name: 'Maria Santos' }])
const isLoading = ref(false)
async function loadEmployees() { ... }

// After: composables/useEmployees.js
export function useEmployees() {
  const employees = ref([{ id: 1, name: 'Maria Santos' }])
  const isLoading = ref(false)
  async function load() { ... }
  return { employees, isLoading, load }
}
```

---

## Step 4 — Type Props and Emits

Every component that receives props or emits events must declare them explicitly.

**Props:**
```vue
<script setup>
// Typed with JSDoc (JS projects)
const props = defineProps({
  employee: { type: Object, required: true },
  isSelected: { type: Boolean, default: false }
})

// Or TypeScript interface (TS projects)
const props = defineProps<{
  employee: Employee
  isSelected?: boolean
}>()
</script>
```

**Emits:**
```vue
<script setup>
const emit = defineEmits(['select', 'dismiss'])
// or TypeScript:
const emit = defineEmits<{
  select: [employee: Employee]
  dismiss: []
}>()
</script>
```

Flag any `defineProps` without types, any `$emit` calls without a matching `defineEmits`, and any prop passed via `v-bind="$attrs"` without `inheritAttrs: false`.

---

## Step 5 — Remove Prototype Artifacts

Scan every file and remove or flag:

| Artifact | What to do |
|---|---|
| `console.log(...)` | Remove |
| `// TODO`, `// FIXME`, `// HACK` comments | Remove or resolve — none should survive handoff |
| `setTimeout` used only to simulate latency | Keep if it controls a visible loading state; remove if it serves no UX purpose |
| Hardcoded magic numbers (e.g. `setTimeout(fn, 500)`) | Extract to a named constant at the top of the file: `const SUBMIT_DELAY_MS = 500` |
| Commented-out code blocks | Remove |
| Unused `import` statements | Remove |
| Unused `ref`/`reactive` declarations | Remove |
| Inline style hacks (`style="..."`) | Replace with Tailwind classes or token classes |

---

## Step 6 — Verify File Structure

The final `prototype/` directory must follow this structure. Rename or move files that don't fit.

```
prototype/
├── main.js               ← Stack context comment on line 1
├── App.vue               ← Router root + persistent layout only
├── router.js             ← Named routes, one per screen
├── stores/               ← Pinia stores for cross-screen state only
│   └── use[Feature]Store.js
├── composables/          ← All mock data + reusable logic
│   └── use[Feature].js
├── components/           ← Shared UI used in 2+ screens
│   └── [Feature]/        ← Group by feature, not by type
│       └── [ComponentName].vue
└── screens/              ← One file per route, thin composition surfaces
    ├── 01-[screen].vue
    └── ...
```

**Checks:**
- `App.vue` contains no feature logic — only `<RouterView>` and persistent shell
- `router.js` uses named routes with lazy-loaded screen imports
- No screen file contains inline mock data — it lives in composables
- No component is imported but not used

---

## Step 7 — Reactivity Audit

- Every value that drives the UI must be a `ref` or `computed` — not a plain variable
- Derived values (filtered lists, formatted strings, computed totals) must use `computed`, not manual watchers
- No `watch` where `computed` would do the same job
- No `reactive` on a single primitive — use `ref`

---

## Step 8 — Final Checklist

Run through this before declaring handoff done:

- [ ] No component template exceeds ~80 lines
- [ ] No screen component owns both state orchestration and multi-section rendering
- [ ] All repeated template blocks are extracted
- [ ] All mock data lives in composables, not inline
- [ ] All `defineProps` are typed
- [ ] All `defineEmits` are declared
- [ ] No `console.log`, no commented-out blocks, no `// TODO`
- [ ] No unused imports or refs
- [ ] No inline `style="..."` hacks
- [ ] `App.vue` is a thin shell
- [ ] `router.js` uses named lazy routes
- [ ] File structure matches the spec above

---

## Check-in

After the pass, list:
- Files changed and what was done (split / extracted / typed / cleaned)
- Any design issues found that should go back to the designer before dev picks this up

Then use `AskUserQuestion`:
> "Handoff pass complete. Here's what was refactored: [list]. Any of these changes need a second look before this goes to the dev team?"
