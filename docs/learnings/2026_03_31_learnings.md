# Agent Learnings

Gaps in agent behavior encountered during this session. Use these to improve skill prompts and agent defaults.

---

## 1. Toge v1 vs Toge v2 — agent called MCP tools for the wrong design system

**What happened:** When the user said "use Toge v2," the agent called `mcp__design-system-toge__get_tokens` and `mcp__design-system-toge__list_components`. The user rejected both calls and had to clarify.

**Root cause:** The agent treated MCP as the universal entry point for Toge regardless of version.

**Rule:** Check `package.json` before calling any design system MCP tool.
- `@toge-design-system/toge` or `design-system-next` → Toge v1 → MCP tools appropriate
- Toge v2 (shadcn-vue registry) → install via CLI only, do NOT call MCP

---

## 2. Phase 4 was treated as "add interactivity" — not "convert to high-fidelity"

**What happened:** The agent added event handlers and `defineEmits` to the existing grayscale wireframes and called it Phase 4. The user had to explicitly call this out.

**Root cause:** The agent interpreted "upgrade each wireframe in-place" as an additive pass. Gray placeholder divs and mock icon blocks were never replaced with real Toge components.

**Rule:** Phase 4 = full rewrite. Every wireframe placeholder (`bg-gray-*` class, `<div>` standing in for an icon, mock border box) must be replaced with a real design system component before any interaction wiring begins. If the file still contains gray utility classes or inline style hacks used as placeholders, Phase 4 is not done.

---

## 3. Interactive CLI scripts — piped stdin didn't work with `readline/promises`

**What happened:** The Toge bulk installer uses Node's `readline/promises`, which requires a TTY. Multiple attempts to pipe input with `printf "...\n" | node script.mjs` were all ignored.

**Root cause:** `readline/promises` in a non-TTY context doesn't flush buffered input the same way synchronous readline does.

**Rule:** When a CLI script uses `readline/promises` and piped input fails after one retry, stop and ask the user to run it interactively with `! node /tmp/script.mjs`. Don't keep retrying the same pipe pattern.

---

## 4. `components.json` — agent added an undocumented `"framework"` key

**What happened:** The agent wrote a `components.json` with `"framework": "vite"`. `npx shadcn-vue@latest add` rejected it with "Unrecognized key: framework."

**Root cause:** The agent inferred the key from project context. It doesn't exist in the shadcn-vue schema.

**Rule:** Never add undocumented keys to `components.json`. Valid top-level keys: `$schema`, `style`, `typescript`, `tailwind`, `aliases`. When unsure, run `npx shadcn-vue@latest init --defaults` and use the generated file as-is.

---

## 5. `tsconfig.json` vs `tsconfig.app.json` — shadcn-vue reads the root file

**What happened:** The `@/*` alias was added to `tsconfig.app.json`. `npx shadcn-vue@latest init` failed validation because it looks in `tsconfig.json` (root), not `tsconfig.app.json`.

**Rule:** In a Vite + Vue project, always add `compilerOptions.paths` to both files:
- `tsconfig.json` — for shadcn-vue's init validator
- `tsconfig.app.json` — for the TypeScript compiler

---

## 6. UIFork misused as a navigation router

**What happened:** The agent tried to drive sequential screen transitions (Download PDF → Loading → File Delivery) through UIFork's `ForkedComponent`, which required hacking localStorage and dispatching synthetic `StorageEvent`s. This broke down when the user asked for cumulative chat behavior.

**Root cause:** UIFork stores its active version in localStorage with no programmatic API. The agent tried to use it as a navigation driver, which it wasn't designed for.

**Rule:** UIFork is for switching between parallel design alternatives (e.g., two button layouts). It is not a navigation router. For sequential interaction flows, use state-driven rendering or a message-accumulation model. Only use UIFork for true design variants.

---

## 7. Apostrophes in single-quoted JS strings caused a Vue compiler error

**What happened:** Content strings like `'Here's your payslip'` and `'I couldn't find'` broke the Vue SFC compiler: `Unexpected token`.

**Root cause:** Single-quoted strings containing natural language with apostrophes close the string literal early.

**Rule:** Use double quotes for any string containing natural language. Reserve single quotes for identifiers, keys, and strings guaranteed not to contain apostrophes.

---

## 8. Phase 4 never reaches true high-fidelity

**What happened:** Phase 4 consistently stopped short — placeholders were partially replaced but colors, spacing, and component composition still fell back to Tailwind utilities instead of Toge tokens and real component props.

**Root cause:** The agent treated "replace placeholders" as a light pass rather than a full rewrite.

**Rule:** Phase 4 is done only when zero `bg-gray-*`, zero arbitrary hex values, and zero `<div>` placeholders remain. If any of these exist, Phase 4 is not complete.

---

## 9. Tab/wireframe switcher survives into Phase 4

**What happened:** The agent built Phase 3 as a tabbed multi-screen layout and never dismantled it when entering Phase 4. The result was a prototype that still looked like a wireframe navigator, not a real product experience.

**Root cause:** The agent treated Phase 4 as additive (layer on top of Phase 3) instead of a replacement.

**Rule:** At Phase 4 entry, delete the tab navigation entirely and rebuild as a single unified experience (e.g. cumulative chat canvas, single flow). Multi-screen tabs are a Phase 3 artifact — they must not survive into Phase 4.

---

## 10. Toge v1 installer called during Phase 4 setup

**What happened:** Even after being corrected in-session, the agent defaulted back to MCP or v1 install paths when setting up design system dependencies during Phase 4.

**Root cause:** The agent did not re-check `package.json` when resuming work in a new phase.

**Rule:** Before any `npx` or install command involving Toge, check `package.json`. If `design-system-next` or `@toge-design-system/toge` is absent, use the v2 bulk installer CLI only. Never call MCP tools for Toge v2 under any circumstances.

---

## 11. Phase 3 (wireframing) is optional — layout intent replaces it

**What happened:** Wireframing (Phase 3) generated artifacts that Phase 4 had to fully discard anyway — creating rework, hallucination surface, and tab navigation that had to be manually dismantled.

**Root cause:** The workflow treated Phase 3 as mandatory scaffolding, when it added friction without durable value.

**Rule:** Default to skipping Phase 3. Instead, ask the user one optional question before starting Phase 4: *"Do you have a desired layout in mind? Share an image or describe it — otherwise I'll decide."* If the user provides input, use it as the layout reference. If not, proceed immediately with a reasonable default. Never generate multi-screen wireframes as a blocking phase.

---

## 12. UI components not installed before prototyping begins

**What happened:** The agent started writing prototype component code before knowing what components were actually available in the installed design system. This caused hallucinated component names, wrong prop signatures, and fallback to raw HTML divs.

**Root cause:** The agent assumed component availability from memory rather than verifying the installed file tree.

**Rule:** Before writing any prototype code, run the bulk installer to install all base components. Then read the installed component files to understand the actual API surface (props, variants, slots). Component discovery must happen before the first line of prototype code is written. This gives the agent accurate context and eliminates hallucinated component APIs.

---

## Summary

| Priority | Gap | Rule |
|---|---|---|
| P0 | MCP called for Toge v2 | Gate on package.json — v2 = CLI only |
| P0 | Phase 4 not high-fidelity | Require full placeholder replacement before wiring |
| P0 | Tab nav survives into Phase 4 | Delete tab nav at Phase 4 entry; rebuild as single canvas |
| P0 | Toge v1 installer called in Phase 4 | Re-check package.json before any install command |
| P0 | Components not installed before prototyping | Bulk install + read component files before first prototype line |
| P1 | Interactive CLI pipe failures | Stop after one retry, hand off to user |
| P1 | UIFork misused as navigation router | Use state-driven rendering for sequential flows |
| P1 | Phase 3 creates rework | Ask for layout intent (optional), skip wireframing, go straight to Phase 4 |
| P2 | `components.json` undocumented keys | Use init-generated file only |
| P2 | tsconfig alias in wrong file | Always patch both tsconfig files |
| P2 | Apostrophes in single-quoted strings | Use double quotes for natural language content |
