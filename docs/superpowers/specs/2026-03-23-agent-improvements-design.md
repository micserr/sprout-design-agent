# Agent Improvements Design Spec
**Date:** 2026-03-23
**Status:** Approved

---

## Problem

Seven issues were encountered during a full Phase 0→5 product design workflow, all caused by one root cause: the agent never confirmed the tech stack before generating code. Wireframes used generic Tailwind classes, and prototype generation silently assumed defaults that broke because the project used a custom design system. All fixes below are downstream corrections of this one gap.

---

## Scope

Three files change. One file is created.

| File | Change type |
|---|---|
| `agents/product-design.md` | Modify — remove design system question from pre-Phase 1, add all 4 stack questions at Phase 3→4 transition, update Phase 5 inputs block |
| `skills/prototype/SKILL.md` | Modify — add Step 0 pre-flight, update Step 2 token rule (including text-base warning), add stack context header in Step 3 |
| `guide/toge-design-system/tokens/token-mapping.yaml` | Create — default Tailwind → Toge token substitution map, derived from `guide/toge-design-system/tokens/style.css` and `design-tokens.yaml` |

---

## Section 1: Stack Discovery (`agents/product-design.md`)

### What changes

**Remove** the design system question from the pre-Phase 1 setup block.

**Add** all 4 stack questions to the **Phase 3 → Phase 4 transition** — after the journey map check-in confirms pain points and screens, but before any wireframe code is written. This satisfies Phase 4's dependency on `DESIGN_SYSTEM` being confirmed: the questions are answered at the end of Phase 3, and Phase 4 reads the confirmed value before writing its first line of wireframe code.

Each question runs through `AskUserQuestion` one at a time.

### The 4 stack questions

| Variable | Question | How to ask |
|---|---|---|
| `DESIGN_SYSTEM` | Sprout Legacy or Toge? | Auto-detect first (see detection logic below); ask only if ambiguous |
| `STACK_FRAMEWORK` | Vue 3, React, or other? | `AskUserQuestion` |
| `STACK_TAILWIND_VERSION` | Tailwind v3 or v4? | `AskUserQuestion` |
| `STACK_ENTRY_POINT` | Where does the prototype entry file live relative to `src/`? | `AskUserQuestion` |

### Design system auto-detection

Before asking `DESIGN_SYSTEM`, the agent checks the project:

| Condition | Action |
|---|---|
| `package.json` has `design-system-next` | Auto-select **Sprout Legacy**, read `guide/sprout-legacy-design-system/README.md` |
| `components.json` has `registries["@toge"]` | Auto-select **Toge**, read `guide/toge-design-system/README.md` |
| Both found | Auto-select **Toge** (prefer Toge for new code per `guide/README.md`), note this to the user |
| Neither found | Ask via `AskUserQuestion` |

Reference: `guide/README.md` for detection rules and what each system implies.

### Where in the agent flow

The Phase 3 check-in currently ends with: "Are these the right pain points to design for? Any flows I'm missing?" Immediately after that confirmation, before advancing to Phase 4:

> "Before we wireframe, I need to confirm your tech stack — I'll ask four quick questions."

Ask the 4 questions in sequence via `AskUserQuestion`. Store all 4 vars. Then advance to Phase 4.

### Updated Phase 5 inputs block

Replace the current Phase 5 "Inputs carried forward" block with:

```
**Inputs carried forward:**
- Wireframes from `wireframes/` (Phase 4)
- User flow diagram (Phase 3) — to map screen-to-screen navigation
- `DESIGN_SYSTEM` — to pick the correct component library and token set
- `STACK_FRAMEWORK` — to confirm the component model (Vue 3, React, etc.)
- `STACK_TAILWIND_VERSION` — to confirm CSS utility syntax (v3 vs v4)
- `STACK_ENTRY_POINT` — to determine where `prototype/main.js` lives and what `@source` paths to use
```

---

## Section 2: Stack Context Header (`skills/prototype/SKILL.md`)

### What changes

**Step 3 — Scaffold** gets a new first action: before creating any files, write the confirmed stack as a comment header in the prototype entry file (`main.js` or equivalent).

### Header format

```js
// Stack: {STACK_FRAMEWORK} · {STACK_TAILWIND_VERSION} · {DESIGN_SYSTEM} · entry: {STACK_ENTRY_POINT}
```

Example:
```js
// Stack: Vue 3 · Tailwind v4 · Toge · entry: prototype/main.js
```

### How it is used

Every subsequent code generation step reads this comment first. If the agent generates a new file mid-session, it checks this header before writing any class. The header is the anchor that prevents silent stack assumption.

### Step 2 — Token rule addition (Toge)

Add to Step 2 (Read the Design System Guide):

> "If `DESIGN_SYSTEM` is **Toge**, read `guide/toge-design-system/tokens/token-mapping.yaml` before writing any component. Every default Tailwind color class (`bg-gray-*`, `text-gray-*`, `bg-red-*`, etc.) is a violation — replace it with the mapped token before committing the output.
>
> **Known naming collision:** Do not combine `text-base` with another font-size utility on the same element. The design system defines `.text-base` as a color class (`color: var(--text-base)`); Tailwind also has `text-base` as a font-size utility. The utilities layer wins for `font-size`, silently overriding the size. Use `text-base` alone when 1rem is acceptable, or use `text-strong` / `text-weak` when a specific font-size is also needed.
>
> If `DESIGN_SYSTEM` is **Sprout Legacy**, tokens use the `spr-` prefix — no separate mapping file needed."

---

## Section 3: Agnostic Pre-flight (`skills/prototype/SKILL.md`)

### What changes

Add **Step 0 — Pre-flight Check** as the first step in the skill, before Step 1 (Read Wireframes).

### The 4 checks

These are stack-agnostic patterns. The agent derives what specifically to check from the confirmed `// Stack:` header.

| # | Check | What to verify |
|---|---|---|
| 1 | **CSS pipeline consistency** | Does the build tool config match the CSS syntax in the project's stylesheet? Flag if a v3-style config exists alongside v4 syntax, or vice versa. |
| 2 | **Source scanning completeness** | Does the bundler scan every directory containing component files? Verify `wireframes/`, `prototype/`, and any directory outside the default source root is included. |
| 3 | **Package compatibility** | Are all design system packages compatible with the confirmed framework and CSS version? Flag peer dependency conflicts before writing any code. |
| 4 | **Explicit dependencies** | Are routing and state management packages explicitly declared in `package.json`? Never assume transitive dependencies. |

### Execution rule

- If a check **fails** → fix it before proceeding to Step 1.
- If a check **does not apply** to the confirmed stack → skip it with a one-line note.
- Do not proceed to Step 1 until all applicable checks pass.

---

## Section 4: Token Mapping File (`guide/toge-design-system/tokens/token-mapping.yaml`)

### What changes

Create a new file: `guide/toge-design-system/tokens/token-mapping.yaml`

### Purpose

A structured substitution map the agent reads before generating any component when `DESIGN_SYSTEM` is Toge. Derived from `guide/toge-design-system/tokens/style.css` (authoritative token values) and `guide/toge-design-system/tokens/design-tokens.yaml` (token names and structure).

### Format

The YAML uses Toge's actual token vocabulary — mushroom palette, surface semantics, and semantic color families — not shadcn defaults. All mappings are derived from `guide/toge-design-system/tokens/style.css` and the PROTOTYPE_LESSONS Quick Reference table.

```yaml
# Default Tailwind color class → Toge design token mapping.
# Source of truth for token values:  guide/toge-design-system/tokens/style.css
# Token names and structure:         guide/toge-design-system/tokens/design-tokens.yaml
# Derivation reference:              PROTOTYPE_LESSONS.md Quick Reference table
# Usage: read this file in prototype/SKILL.md Step 2 when DESIGN_SYSTEM = Toge.
# Every default Tailwind color class listed here is a violation in prototype code.

surfaces:
  bg-gray-100:  bg-surface
  bg-gray-50:   bg-mushroom-50
  bg-gray-200:  bg-mushroom-200
  bg-white:     bg-white            # bg-white still works (white primitive is preserved)

text:
  text-gray-900: text-strong
  text-gray-800: text-strong
  text-gray-700: text-base
  text-gray-600: text-base
  text-gray-500: text-base
  text-gray-400: text-weak

borders:
  border-gray-100: border-mushroom-100
  border-gray-200: border-mushroom-200
  border-gray-300: border-mushroom-300

interactive:
  bg-gray-800:       bg-surface-inverted
  hover:bg-gray-700: hover:bg-mushroom-900
  hover:bg-gray-50:  hover:bg-mushroom-50
  hover:bg-gray-100: hover:bg-mushroom-100
  hover:text-gray-900: hover:text-strong

disabled:
  bg-gray-200 text-gray-400: bg-surface-disabled text-disabled

semantic_danger:
  bg-red-50:       bg-danger-subtle
  bg-red-100:      bg-danger-subtle
  bg-red-400:      bg-danger
  bg-red-500:      bg-danger
  text-red-400:    text-danger
  text-red-500:    text-danger
  text-red-600:    text-danger
  text-red-700:    text-danger
  border-red-200:  border-danger-subtle
  border-red-300:  border-danger-subtle
  border-red-400:  border-danger
  border-red-500:  border-danger

semantic_success:
  bg-emerald-50:      bg-success-subtle
  bg-emerald-100:     bg-success-subtle
  text-emerald-600:   text-success-text
  text-emerald-700:   text-success-text
  border-emerald-200: border-success-subtle

semantic_information:
  bg-blue-50:       bg-information-subtle
  bg-blue-100:      bg-information-subtle
  text-blue-600:    text-information-text
  text-blue-700:    text-information-text
  text-blue-800:    text-information-text
  border-blue-100:  border-information-subtle
  border-blue-200:  border-information-subtle
```

---

## What Does NOT Change

- `skills/wireframing/SKILL.md` — no changes; wireframes remain grayscale structure only
- `guide/toge-design-system/tokens/style.css` — source of truth, read-only
- `guide/toge-design-system/tokens/design-tokens.yaml` — existing structure doc, unchanged
- `PROTOTYPE_LESSONS.md` — remains as a historical reference and example; no longer the primary enforcement mechanism

---

## Success Criteria

| # | Criterion | How to verify |
|---|---|---|
| 1 | The agent never asks for design system twice (auto-detect first, ask only if ambiguous) | Inspect the Phase 3 check-in transcript — `DESIGN_SYSTEM` confirmation appears only once, at the Phase 3→4 transition |
| 2 | The stack context header is the first line written in every prototype session | Inspect `prototype/main.js` — line 1 must be the `// Stack:` comment before any import |
| 3 | No default Tailwind color class appears in any Toge prototype output | Search generated `.vue` files for `bg-gray-`, `text-gray-`, `bg-red-`, `bg-emerald-`, `bg-blue-` — zero matches expected |
| 4 | Pre-flight runs and resolves all applicable checks before any `.vue` file is created | Inspect the Step 0 output transcript — all 4 checks appear before the first screen file is scaffolded |
| 5 | All 4 pre-flight checks are stack-agnostic — the same Step 0 wording applies for Vue/React, v3/v4, Toge/Sprout/vanilla | Read Step 0 text — no framework-specific commands or filenames are hardcoded in the check descriptions |
