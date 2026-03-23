# Agent Improvements Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Fix the product design agent so it confirms the tech stack before wireframing, enforces design token usage in prototypes, and verifies project config before generating code.

**Architecture:** Three targeted file edits plus one new YAML file. No new abstractions — each change is a surgical addition to an existing file at a specific location. All changes are to documentation/instruction files (`.md`, `.yaml`), not runtime code.

**Tech Stack:** Markdown (agent/skill files), YAML (token mapping), Tailwind v4 token system (mushroom/surface/semantic)

**Spec:** `docs/superpowers/specs/2026-03-23-agent-improvements-design.md`

---

## File Map

| File | Action | What changes |
|---|---|---|
| `guide/toge-design-system/tokens/token-mapping.yaml` | **Create** | New file — full default Tailwind → Toge token substitution map |
| `agents/product-design.md` | **Modify** | Remove design system question from pre-Phase 1; add 4 stack questions at Phase 3→4 transition; update Phase 5 inputs block |
| `skills/prototype/SKILL.md` | **Modify** | Add Step 0 pre-flight; update Step 2 token rule + text-base warning; add stack context header to Step 3 |

---

## Task 1: Create `token-mapping.yaml`

**Files:**
- Create: `guide/toge-design-system/tokens/token-mapping.yaml`

This file is the authoritative substitution map the prototype skill reads before generating any component when `DESIGN_SYSTEM = Toge`. All token classes are derived from `guide/toge-design-system/tokens/style.css`.

Token class rules (from style.css):
- **Surface:** `@theme inline` with `--color-surface-*` → Tailwind generates `bg-surface`, `bg-surface-gray`, `bg-surface-white`, `bg-surface-adaptive`, `bg-surface-inverted`, `bg-surface-disabled`, etc.
- **Text:** `@layer components` component-only classes → `.text-strong`, `.text-base`, `.text-supporting`, `.text-weak`, `.text-disabled`, `.text-inverted`
- **Border:** `@layer components` component-only classes → `.border-strong`, `.border-base`, `.border-weak`, `.border-supporting`
- **Semantic families:** `@theme inline` with `--color-{family}` and `--color-{family}-*` → `bg-danger`, `bg-danger-subtle`, `bg-danger-text`, `text-danger-text`, `text-success-text`, `text-information-text`, etc.
- **Mushroom palette:** `@theme` with `--color-mushroom-*` → `bg-mushroom-50`, `bg-mushroom-200`, etc.

- [ ] **Step 1: Create the token mapping file**

```yaml
# Default Tailwind color class → Toge design token mapping.
# Source of truth for token values:  guide/toge-design-system/tokens/style.css
# Token names and structure:         guide/toge-design-system/tokens/design-tokens.yaml
# Derivation reference:              PROTOTYPE_LESSONS.md Quick Reference table
# Usage: read this file in prototype/SKILL.md Step 2 when DESIGN_SYSTEM = Toge.
# Every default Tailwind color class listed here is a violation in prototype code.
#
# Token class rules:
#   bg-surface-*         → @theme inline --color-surface-* (Tailwind utility)
#   text-strong/base/weak → @layer components (color-only; no bg-* / border-* generated)
#   border-strong/base/weak → @layer components (border-color only)
#   bg-danger / bg-success / etc. → @theme inline --color-{family} (Tailwind utility)
#   bg-mushroom-* → @theme --color-mushroom-* (Tailwind utility)

# ─── SURFACES ─────────────────────────────────────────────────────────────────
surfaces:
  # Page / canvas backgrounds
  bg-white:    bg-surface-white        # context-aware: light = #fff, dark = mushroom-50
  bg-gray-50:  bg-surface-gray         # main canvas — mushroom-50 light / mushroom-900 dark
  bg-gray-100: bg-surface              # alias for surface-gray; use for full-page bg
  bg-gray-200: bg-mushroom-200

  # Cards, panels, inputs (auto-adapts to background via color-mix overlay)
  # No direct gray equivalent — use bg-surface-adaptive whenever a container
  # needs elevation on top of bg-surface-gray.

  # Interactive surface states
  hover:bg-gray-50:  hover:bg-surface-hover
  hover:bg-gray-100: hover:bg-surface-hover
  hover:bg-gray-200: hover:bg-surface-pressed

  # Inverted (dark fills — primary buttons, active nav items)
  bg-gray-800:        bg-surface-inverted
  bg-gray-900:        bg-surface-inverted
  hover:bg-gray-700:  hover:bg-surface-inverted-hover
  hover:bg-gray-900:  hover:bg-surface-inverted-hover

  # Disabled
  bg-gray-200.text-gray-400: "bg-surface-disabled text-disabled"  # use both classes together

# ─── TEXT ─────────────────────────────────────────────────────────────────────
# These are @layer components classes (color only — no bg-strong or border-strong exist).
text:
  text-gray-950: text-strong
  text-gray-900: text-strong
  text-gray-800: text-strong
  text-gray-700: text-base
  text-gray-600: text-base
  text-gray-500: text-base            # text-supporting is also valid (mushroom-500)
  text-gray-400: text-weak
  text-gray-300: text-weak
  hover:text-gray-900: hover:text-strong

# ─── BORDERS ──────────────────────────────────────────────────────────────────
# These are @layer components classes (border-color only).
# Always pair with Tailwind's `border` utility for border-width.
borders:
  border-gray-100: border-weak        # mushroom-200
  border-gray-200: border-weak        # mushroom-200
  border-gray-300: border-base        # mushroom-300
  border-gray-400: border-supporting  # mushroom-400
  border-gray-500: border-strong      # mushroom-500

# ─── MUSHROOM PALETTE (direct) ────────────────────────────────────────────────
# Use when a specific shade is needed and no semantic token fits.
mushroom_direct:
  bg-gray-50:   bg-mushroom-50
  bg-gray-100:  bg-mushroom-100
  bg-gray-200:  bg-mushroom-200
  bg-gray-300:  bg-mushroom-300
  text-gray-400: text-weak            # mushroom-400
  bg-gray-800:  bg-mushroom-800
  bg-gray-900:  bg-mushroom-900
  bg-gray-950:  bg-mushroom-950
  hover:bg-gray-50:  hover:bg-mushroom-50
  hover:bg-gray-100: hover:bg-mushroom-100
  hover:bg-gray-700: hover:bg-mushroom-900

# ─── SEMANTIC — DANGER (tomato) ───────────────────────────────────────────────
semantic_danger:
  bg-red-50:       bg-danger-subtle      # tomato-100
  bg-red-100:      bg-danger-subtle      # tomato-100
  bg-red-400:      bg-danger             # tomato-600
  bg-red-500:      bg-danger             # tomato-600
  bg-red-600:      bg-danger             # tomato-600
  text-red-400:    text-danger           # uses --color-danger → tomato-600
  text-red-500:    text-danger
  text-red-600:    text-danger
  text-red-700:    text-danger-text      # uses --color-danger-text → tomato-700 (darker)
  border-red-100:  border-weak           # mushroom-200; use with Tailwind's `border` utility for width
  border-red-200:  border-danger-subtle  # Tailwind utility generated from --color-danger-subtle in @theme inline
  border-red-300:  border-danger-subtle
  border-red-400:  border-danger         # Tailwind utility generated from --color-danger in @theme inline
  border-red-500:  border-danger
  hover:bg-red-50: hover:bg-danger-subtle-hover

# ─── SEMANTIC — SUCCESS (kangkong) ────────────────────────────────────────────
semantic_success:
  bg-emerald-50:       bg-success-subtle      # kangkong-100
  bg-emerald-100:      bg-success-subtle
  bg-emerald-400:      bg-success             # kangkong-600
  bg-emerald-500:      bg-success
  text-emerald-600:    text-success-text      # kangkong-700
  text-emerald-700:    text-success-text
  border-emerald-100:  border-weak          # mushroom-200; use with Tailwind's `border` utility
  border-emerald-200:  border-success-subtle # Tailwind utility from --color-success-subtle in @theme inline
  hover:bg-emerald-50: hover:bg-success-subtle-hover

# ─── SEMANTIC — INFORMATION (blueberry) ───────────────────────────────────────
semantic_information:
  bg-blue-50:        bg-information-subtle    # blueberry-100
  bg-blue-100:       bg-information-subtle
  bg-blue-500:       bg-information           # blueberry-600
  bg-blue-600:       bg-information
  text-blue-600:     text-information-text    # blueberry-800
  text-blue-700:     text-information-text
  text-blue-800:     text-information-text
  border-blue-100:   border-information-subtle
  border-blue-200:   border-information-subtle
  hover:bg-blue-50:  hover:bg-information-subtle-hover

# ─── SEMANTIC — PENDING / CAUTION ─────────────────────────────────────────────
semantic_pending:
  bg-yellow-50:      bg-pending-subtle        # mango-100
  bg-yellow-100:     bg-pending-subtle
  bg-yellow-400:     bg-pending               # mango-500
  bg-yellow-500:     bg-pending
  text-yellow-600:   text-pending-text        # mango-800
  text-yellow-700:   text-pending-text
  border-yellow-200: border-pending-subtle

semantic_caution:
  bg-orange-50:      bg-caution-subtle        # carrot-100
  bg-orange-100:     bg-caution-subtle
  bg-orange-400:     bg-caution               # carrot-500
  bg-orange-500:     bg-caution
  text-orange-600:   text-caution-text        # carrot-800
  text-orange-700:   text-caution-text
  border-orange-200: border-caution-subtle

# ─── KNOWN NAMING COLLISION ───────────────────────────────────────────────────
# WARNING: text-base is defined in BOTH @layer components (color: var(--text-base))
# AND Tailwind's utilities layer (font-size: 1rem / text-base).
# The utilities layer wins for font-size, silently overriding any other font-size
# utility on the same element (e.g. text-xs text-base → font-size becomes 1rem).
# Rule: do NOT combine text-base with another font-size utility.
# Use text-base alone (1rem acceptable), or use text-strong / text-weak when a
# specific font-size is also needed.
```

- [ ] **Step 2: Verify token classes exist in style.css**

Open `guide/toge-design-system/tokens/style.css` and confirm:
- `bg-surface` → `--color-surface` in `@theme inline` at line ~198
- `text-strong` → `.text-strong { color: var(--text-strong); }` in `@layer components` at line ~720
- `border-weak` → `.border-weak { border-color: var(--border-weak); }` in `@layer components` at line ~737
- `bg-danger-subtle` → `--color-danger-subtle` in `@theme inline` at line ~253 (Tailwind generates `bg-danger-subtle`, `text-danger-subtle`, **and** `border-danger-subtle` from this one entry)
- `border-danger-subtle` → confirmed valid Tailwind utility (same `@theme inline` entry as above — NOT a component class)
- `bg-success-subtle` → `--color-success-subtle` in `@theme inline` at line ~231
- `bg-information-subtle` → `--color-information-subtle` in `@theme inline` at line ~242
- `bg-mushroom-50` through `bg-mushroom-950` → `--color-mushroom-*` in `@theme` at lines ~81-91

- [ ] **Step 3: Commit**

```bash
git add guide/toge-design-system/tokens/token-mapping.yaml
git commit -m "feat: add Toge token mapping YAML for prototype code generation"
```

---

## Task 2: Modify `agents/product-design.md`

**Files:**
- Modify: `agents/product-design.md`

Three changes in this file:
1. Remove the design system question from the pre-Phase 1 block (lines 70-77)
2. Add 4 stack questions at the Phase 3 check-in transition (after line 143)
3. Update the Phase 5 inputs block (lines 177-181)

- [ ] **Step 1: Remove design system question from pre-Phase 1 block**

First, read `agents/product-design.md` lines 68–80 and copy the exact text (including whitespace) before executing the replacement — the find string must match verbatim.

Find and remove this block (currently after the brief questions, before Phase 1):

```markdown
Then ask which design system the project uses via `AskUserQuestion`:
> "Which design system is this project on — **Sprout Legacy** (`design-system-next` via npm) or
> **Toge** (component registry via `npx shadcn-vue`)?"

Store the answer as `DESIGN_SYSTEM` and carry it forward into Phase 4. Read the matching guide
before writing any wireframe code:
- Sprout Legacy → `guide/sprout-legacy-design-system/README.md`
- Toge → `guide/toge-design-system/README.md`
```

- [ ] **Step 2: Verify pre-Phase 1 block no longer mentions design system**

Read `agents/product-design.md` lines 60–82. Confirm only brief questions remain (what, who, problem, constraints). No `DESIGN_SYSTEM` question.

- [ ] **Step 3: Add stack discovery block at Phase 3 check-in**

Find the Phase 3 check-in (currently ends with the `AskUserQuestion` about pain points). Replace:

```markdown
**Check-in**: Show the top 3 pain points and the screens you're planning to wireframe. Then use
`AskUserQuestion`: "Are these the right pain points to design for? Any flows I'm missing?"
```

With:

```markdown
**Check-in**: Show the top 3 pain points and the screens you're planning to wireframe. Then use
`AskUserQuestion`: "Are these the right pain points to design for? Any flows I'm missing?"

**Stack discovery** — before advancing to Phase 4, confirm the tech stack via `AskUserQuestion` one question at a time:

1. **Design system** — auto-detect first:
   - Check `package.json`: if `design-system-next` is a dependency → `DESIGN_SYSTEM = Sprout Legacy`
   - Check `components.json`: if `registries["@toge"]` is present → `DESIGN_SYSTEM = Toge`
   - If both found → `DESIGN_SYSTEM = Toge` (prefer Toge for new code; note this to the user)
   - If neither found → ask: "Which design system does this project use — **Sprout Legacy** (`design-system-next`) or **Toge** (shadcn-vue registry)?"
   - Read the matching guide: Sprout Legacy → `guide/sprout-legacy-design-system/README.md` · Toge → `guide/toge-design-system/README.md`

2. **Framework**: `AskUserQuestion` → "What framework is this project on — Vue 3, React, or something else?" → store as `STACK_FRAMEWORK`

3. **Tailwind version**: `AskUserQuestion` → "Which Tailwind version — v3 (tailwind.config.js + postcss) or v4 (@tailwindcss/vite, no config file)?" → store as `STACK_TAILWIND_VERSION`

4. **Prototype entry point**: `AskUserQuestion` → "Where will the prototype entry file live — inside `src/` or in a separate `prototype/` directory outside `src/`?" → store as `STACK_ENTRY_POINT`

Store all 4 vars and carry them forward explicitly into Phase 5.
```

- [ ] **Step 4: Verify stack discovery block appears correctly**

Read `agents/product-design.md` around the Phase 3 section. Confirm:
- Stack discovery block appears after the pain points `AskUserQuestion`
- Auto-detection table has all 4 cases (Legacy, Toge, both, neither)
- All 4 vars (`DESIGN_SYSTEM`, `STACK_FRAMEWORK`, `STACK_TAILWIND_VERSION`, `STACK_ENTRY_POINT`) are named

- [ ] **Step 5: Update Phase 5 inputs block**

Find the current Phase 5 inputs block:

```markdown
**Inputs carried forward:**
- Wireframes from `wireframes/` (Phase 4)
- User flow diagram (Phase 3) — to map screen-to-screen navigation
- `DESIGN_SYSTEM` — to pick the correct component library
```

Replace with:

```markdown
**Inputs carried forward:**
- Wireframes from `wireframes/` (Phase 4)
- User flow diagram (Phase 3) — to map screen-to-screen navigation
- `DESIGN_SYSTEM` — to pick the correct component library and token set
- `STACK_FRAMEWORK` — to confirm the component model (Vue 3, React, etc.)
- `STACK_TAILWIND_VERSION` — to confirm CSS utility syntax (v3 vs v4)
- `STACK_ENTRY_POINT` — to determine where `prototype/main.js` lives and what `@source` paths to use
```

- [ ] **Step 6: Verify Phase 5 inputs block**

Read `agents/product-design.md` Phase 5 section. Confirm all 6 inputs are listed with their purpose annotations.

- [ ] **Step 7: Commit**

```bash
git add agents/product-design.md
git commit -m "feat: add stack discovery at Phase 3→4 transition in product design agent"
```

---

## Task 3: Modify `skills/prototype/SKILL.md`

**Files:**
- Modify: `skills/prototype/SKILL.md`

Three changes in this file:
1. Add Step 0 pre-flight before the existing Step 1
2. Update Step 2 with token rule + text-base collision warning
3. Add stack context header to Step 3

- [ ] **Step 1: Add Step 0 pre-flight**

Insert before the existing `## Step 1 — Read the Wireframes` heading:

```markdown
## Step 0 — Pre-flight Check

Before reading wireframes or writing any code, verify the project environment using the confirmed `// Stack:` context. Run each check against the actual project files. If a check does not apply to the confirmed stack, skip it with a one-line note.

| # | Check | What to verify |
|---|---|---|
| 1 | **CSS pipeline consistency** | Does the build tool config match the CSS syntax in the project's stylesheet? Flag if a v3-style `tailwind.config.js` + postcss plugin exists alongside v4 `@import 'tailwindcss'` syntax, or vice versa. Fix before proceeding. |
| 2 | **Source scanning completeness** | Does the bundler scan every directory containing component files? Verify that `wireframes/`, `prototype/`, and any directory outside the default source root is included in `@source` directives (v4) or `content` globs (v3). Add missing entries before proceeding. |
| 3 | **Package compatibility** | Are all design system packages compatible with the confirmed framework and CSS version? Check for peer dependency conflicts (e.g. a design system that pins `tailwindcss@^3` installed alongside v4). Uninstall incompatible packages before proceeding. |
| 4 | **Explicit dependencies** | Are routing and state management packages explicitly declared in `package.json`? Never assume transitive dependencies — if the prototype needs `vue-router` or `pinia`, they must be listed directly. Install any missing explicit deps before proceeding. |

Do not advance to Step 1 until all applicable checks pass.

---
```

- [ ] **Step 2: Verify Step 0 appears before Step 1**

Read `skills/prototype/SKILL.md` lines 1–50. Confirm `## Step 0` heading appears before `## Step 1`.

- [ ] **Step 3: Update Step 2 with token rule and text-base warning**

Find Step 2's hard rule:

```markdown
**Hard rule:** Never use raw hex colors or grayscale placeholders from the wireframe.
Every color in the prototype must come from the design system.
```

Replace with:

```markdown
**Hard rule:** Never use raw hex colors or grayscale placeholders from the wireframe.
Every color in the prototype must come from the design system.

**Token enforcement (Toge):** If `DESIGN_SYSTEM` is **Toge**, read `guide/toge-design-system/tokens/token-mapping.yaml` before writing any component. Every default Tailwind color class (`bg-gray-*`, `text-gray-*`, `bg-red-*`, `bg-emerald-*`, `bg-blue-*`, `bg-yellow-*`, `bg-orange-*`) is a violation — replace it with the mapped token before committing output. The design system clears all default Tailwind colors (`--color-*: initial`) so these classes silently render nothing at runtime.

**Known naming collision (Toge):** Do not combine `text-base` with another font-size utility on the same element. The design system defines `.text-base` as `color: var(--text-base)` in `@layer components`, but Tailwind also defines `text-base` as `font-size: 1rem` in `@layer utilities`. The utilities layer wins for `font-size`, so `text-xs text-base` silently becomes 1rem. Use `text-base` alone when 1rem font-size is acceptable, or use `text-strong` / `text-weak` when a specific font-size is also needed.

**Token enforcement (Sprout Legacy):** If `DESIGN_SYSTEM` is **Sprout Legacy**, tokens use the `spr-` prefix. Read `guide/sprout-legacy-design-system/README.md` for the token list. No separate mapping file needed.
```

- [ ] **Step 4: Verify updated Step 2 rule**

Read `skills/prototype/SKILL.md` Step 2 section. Confirm:
- Token enforcement block references `token-mapping.yaml`
- text-base collision warning is present with the exact workaround
- Sprout Legacy rule is present

- [ ] **Step 5: Add stack context header to Step 3**

Find the opening of Step 3:

```markdown
## Step 3 — Scaffold the Prototype

Create this directory structure:
```

Replace with:

```markdown
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

- [ ] **Step 6: Verify stack context header in Step 3**

Read `skills/prototype/SKILL.md` Step 3 section. Confirm:
- Stack context header instruction appears before the directory structure block
- Example comment shows all 4 vars
- "Every subsequent step reads this header first" instruction is present

- [ ] **Step 7: Commit**

```bash
git add skills/prototype/SKILL.md
git commit -m "feat: add pre-flight check, token enforcement, and stack context header to prototype skill"
```

---

## Verification Checklist

After all three tasks are complete, verify the 5 success criteria from the spec:

- [ ] **SC1** — Open `agents/product-design.md`. Search for `DESIGN_SYSTEM`. It should appear only once — in the Phase 3 stack discovery block (not in the pre-Phase 1 setup).
- [ ] **SC2** — Open `skills/prototype/SKILL.md` Step 3. Confirm the first instruction is writing the `// Stack:` comment before any directory structure is created.
- [ ] **SC3** — Open `guide/toge-design-system/tokens/token-mapping.yaml`. Search for `bg-gray-`. Confirm all gray surface classes map to `bg-surface`, `bg-mushroom-*`, or `bg-surface-inverted`. No shadcn tokens (`bg-muted`, `bg-background`) appear.
- [ ] **SC4** — Open `skills/prototype/SKILL.md`. Confirm `## Step 0` appears before `## Step 1` and contains all 4 checks.
- [ ] **SC5** — Read the Step 0 check descriptions. Confirm no Vue-specific, React-specific, or Tailwind-version-specific commands are hardcoded — only generic descriptions of what to verify.

- [ ] **Final commit**

```bash
git add docs/superpowers/plans/2026-03-23-agent-improvements.md
git commit -m "docs: add agent improvements implementation plan"
```
