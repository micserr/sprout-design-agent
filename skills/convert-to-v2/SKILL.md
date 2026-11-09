---
name: toge:convert-to-v2
description: >
  Converts a legacy Sprout HR parity audit (the audit.json + shots folder made by the
  legacy-parity-audit skill) into a working Sprout HR v2 prototype built with the Toge design
  system, then writes the After back into the same audit so PM, Design and engineering can check
  it against legacy. Parity on features: every user action, field, option, rule, state,
  permission and exit in the audit survives. Freedom on experience: layout, flow, grouping,
  components and visual design are redesigned with Toge. Use whenever the user wants to turn an
  audit into a prototype, "convert to v2", "build the After", "redesign this legacy page",
  "migrate <page> to the new design system", "prototype the leave policy page from the audit",
  or points at a folder under planning-artifacts/audit/ and asks for the new version.
---

# Convert to v2

Turns a **legacy parity audit** (step 1–2 of the HR SPA process) into the **v2 prototype** (step 3) and the **Before and after** section the design review (step 4) and the legacy check (step 5) read.

The contract in one line: **nothing a user can do today is lost; how they do it can be better.**

```
audit/<module>/<page>/audit.json + shots/      (Before — PM + engineer, from legacy-parity-audit)
        │
        ▼  convert-to-v2
  1. Parity ledger      every obligation in the audit, numbered, with where it lands in v2
  2. Redesign plan      v2 screens + Toge components + what changes for the user  ── designer approves
  3. Prototype          a room in sprout-hr-prototype, all states reachable
  4. Parity check       every ledger row resolved; nothing missing or regressed
  5. After              after-* screenshots + before_after in audit.json, report rebuilt
```

---

## Contract

```yaml
contract:
  reads:
    - kind: legacy-parity-audit        # <audit folder>/audit.json (+ shots/, probe.json)
      required: true
    - kind: prototype-repo             # sprout-hr-prototype: CLAUDE.md, CONTRIBUTING.md, docs/learnings/
      required: true
    - kind: ux-learnings
      required: false
  writes:
    - kind: prototype                  # code: src/modules/<room>/ in the prototype repo
    - kind: prototype-manifest         # with the `parity` ledger (contracts/prototype-manifest.schema.yaml)
    - kind: legacy-parity-audit        # adds before_after + a history line, rebuilds the report
  preconditions:
    - audit.json exists and has mode "audit" and sections[].items[] with ids
    - every item and rule has a parity.decision (step 4 of the audit is done)
    - the prototype repo exists, has components.json with the @toge registry, and installs/builds
  postconditions:
    - every ledger row has a v2 status; none is "missing" or "regressed"
    - npm run verify passes in the prototype repo
    - audit.json has before_after rows for every feature id, and the report rebuilds clean
```

If a precondition fails, stop and say which one. Don't start the prototype on an audit that hasn't had parity decisions proposed: the PM layer is what tells you what to keep or fix.

---

## Inputs and where things live

| What | Default for Sprout HR v2 |
|---|---|
| Audit folder | `sprout-hr-aidlc/_bmad-output/planning-artifacts/audit/<module>/<page>/` (the user gives the path) |
| Prototype repo | sibling `sprout-hr-prototype/` (find it next to `sprout-hr-aidlc`; ask only if it isn't there) |
| Audit report builder | `~/.claude/skills/legacy-parity-audit/scripts/build_report.py` |
| Manifest | profile `artifact_locations.prototype_manifest` (BMAD: `_bmad-output/planning-artifacts/ux/prototype/prototype-manifest-{feature}.md`), `{feature}` = the audit slug with `/` → `-` |

**Read `audit.json`, not the HTML.** The `*-audit.html` / `*-page.html` files are several MB of embedded screenshots and say nothing the JSON doesn't. Look at screenshots in `shots/` only when you need to see a specific state (open them by name from the item's `shots`).

What the audit gives you, and what each part becomes:

| audit.json | Use it for |
|---|---|
| `meta`, `overview`, `intro` | Who uses it, where it sits in the menu (`meta.where`), role, viewports to match |
| `sections[].items[]` (features, e.g. `lp-list`) | One feature each → screens/regions. `uses[]` are the user actions you must keep; `findings` are today's pain (`ux`, `bug`, `a11y`, `security`, `note`); `parity` is the agreed treatment |
| `spec.fields[]` | Every control: label, default, limits, validation, when it's enabled. Each row is a field the v2 form must have |
| `spec.rules[]` (`R1`…) | Business rules. The single biggest source of rebuild losses; quote validation messages from here |
| `spec.states[]` | Per widget: loading / loaded / empty / error / hidden. Every one must be reachable in the prototype |
| `spec.interactions[]` | Control → what it does → endpoint. Becomes a mock function in `mocks.ts` |
| `spec.components[]` | Legacy UI building blocks → map each to Toge |
| `spec.permissions[]` | Role gates → the prototype's "View as" scenario |
| `spec.dependencies` (`exits`, `endpoints`, `shared`) | Where the page links out, what it shares with other pages |
| `gap_check.gaps[]`, `parity.decision == "decide"` | Open product calls: build the legacy behaviour, mark the row `open` |
| `prototype_changes[]` | Changes made after the audit was published. Every one is a requirement; resolve each |
| `validation` | Empty = still Draft. You may start (Design starts as soon as the page is published), but say so in the report |
| `before_after` | If it already exists, this is a re-run: update rows, add After rounds, don't wipe them |

---

## Step 1 — Build the parity ledger

Before any design, turn the audit into a flat, numbered checklist of **obligations**. This is what makes "we will not delete any features" checkable instead of a promise.

One row per:
- **user action**: each `items[].uses[]` → id `<item>.u<n>` (e.g. `lp-list.u3`)
- **rule**: each `spec.rules[].items[]` → its `R` id
- **field / control**: each `spec.fields[].rows[]` → `F:<form>/<field>`
- **state**: each `spec.states[]` × {loading, loaded, empty, error, hidden} that isn't "Never" / "Not seen" → `S:<widget>/<state>`
- **interaction**: each `spec.interactions[]` → `I:<control>`
- **permission**: each `spec.permissions[]` → `P:<role>`
- **exit**: each `spec.dependencies.exits[]` → `X:<n>`
- **open item**: each `decide` and each `gap_check.gaps[]` with `priority: design` → `D:<n>`
- **prototype change**: each `prototype_changes[]` → its `p` id

Each row records: `id`, short text, legacy `parity.decision` (`carry` / `fix` / `drop` / `decide`), and — filled in Step 2 — **where it lands in v2** (screen + component) and **treatment** (`same`, `redesigned`, `fixed`, `dropped`, `open`).

Write the ledger into the manifest's `parity` block (schema: `contracts/prototype-manifest.schema.yaml`). Count the rows by kind and tell the designer the totals; that number is the parity bar for the rest of the run.

---

## Step 2 — Redesign plan (designer checkpoint)

Read `references/redesign-rules.md` before planning. It is the line between "redesign" (yes) and "delete or invent" (no).

1. **Know the toolset.** In the prototype repo, follow its `CLAUDE.md`: list `src/design-system/components/ui/` and `src/components/`, read the `*.stories.ts` for every component you plan to use, read `src/design-system/styles.css` for tokens, read `docs/learnings/*` and the team UX learnings. Look at how an existing HR room (e.g. `src/modules/navigation/`) and the reference room (`src/modules/dashboard/`) are built, and reuse the shell (sidebar, top bar, ⌘K) rather than rebuilding chrome. Never call the Toge MCP server; it returns stale data.
2. **Map components.** For every `spec.components[]` entry and every distinct control in `spec.fields`, name the Toge component (e.g. legacy "bootbox confirm" → `TogeAlertDialog`; "jqGrid with pager" → `TogeDataTable`; "Bootstrap collapse row" → `TogeAccordion` or a table with expandable rows; "toastr" → the Sonner toast). Only use names you saw in the folder. If nothing fits, write `needs component` and compose from primitives; never hand-roll a primitive Toge has.
3. **Design the v2 experience.** Decide the screens, the flow between them, and the layout of each. Start from the user's job (`overview`, `uses`) and from what hurts today (`findings` of type `ux`, `a11y`, `bug`), not from the legacy page's shape. Typical moves: long single forms → sectioned forms with a sticky summary/save bar; branching questions → progressive disclosure that keeps every branch; dialog-heavy flows → side sheets or inline editing; text-link actions → buttons and row menus; separate pages for one record → tabs or a detail view.
4. **Present the plan** to the designer in one message, then ask with `AskUserQuestion` whether to build it as proposed, adjust, or see an alternative. Keep it short:
   - Screen list with route, and a 2–4 line description of each
   - The component map (legacy → Toge), as a table
   - **What changes for the user**, one line each, citing ledger ids (e.g. "Activate opens a side sheet with the default plan instead of a new page — lp-activate.u1, R2")
   - Anything you propose to **add** (see the rules: flagged, never silent)
   - `decide` items and how you'll show them (legacy behaviour by default)
   - Ledger totals and any row you can't place yet

Don't start code until the designer answers. If they change direction, update the ledger's "where it lands" column first.

---

## Step 3 — Build the prototype

Follow the prototype repo's `CLAUDE.md` and `CONTRIBUTING.md` exactly; they win over anything here.

- **Branch.** Find the active bolt (`git ls-remote --heads origin 'sprout-hr/bolt-*'`, highest number), branch from it as `<module>/feat/<slug>` (e.g. `maintenance/feat/leave-policy-v2`). Never work on a bolt branch, `dev` or `main`. Commit and open a PR only when the user asks; the PR adds one `CHANGELOG.md` entry.
- **Room.** `src/modules/<room>/` with `views/ components/ composables/ routes.ts mocks.ts`. Register routes in `src/router/index.ts` and the entry in `src/shell/nav.config.ts` at the menu path from `meta.where`. If the room already exists (another page in the same module), add to it.
- **mocks.ts is the seam.** All fake data and every `spec.interactions[]` endpoint become functions in `mocks.ts`, named after the legacy action, with a comment naming the legacy endpoint (`// legacy: LeaveTypesAndPolicies.aspx/DeactivateLeaveType`). Seed data mirrors the audit's test data in shape and variety (e.g. 9 leave types, 1 active, statutory types with their own plan forms) but uses fake names; never copy real employee names from screenshots.
- **Rules live in code where engineers will find them.** Put rule logic in composables, and cite the rule id at the line: `// R13 — Never is only offered with upfront or both`. Validation messages: same meaning as the audit's quoted text, rewritten to the repo's microcopy rules when they read badly (record the rewrite as a change row in Step 5).
- **Every state reachable.** Loading, empty, error and hidden states from `spec.states`, role differences from `spec.permissions`, and data scenarios the rules depend on (e.g. a type with a pending CTO application, a plan with 0 employees) must be switchable in the browser. Add them to the prototype's scenario flask (`src/modules/navigation/components/PrototypeScenarioPicker.vue` pattern: a section per scenario), never as controls in the product UI.
- **Toge only.** No raw `<input>`, `<button>`, `<select>`; semantic tokens only; type scale from `styles.css`; banner comment on every non-trivial file; ~300 lines per file before splitting.
- **Responsive.** Build for the viewports in `meta.viewports` (Sprout audits use 1920, 820, 390).
- Run `npm run verify` and fix what it reports. Run the dev server (port 6699) and click through every ledger row's path in Claude in Chrome.

---

## Step 4 — Parity check

Walk the ledger row by row in the running prototype and give each a **status** (the same set the audit report understands):

| Status | Meaning |
|---|---|
| `parity` | Same capability and outcome as legacy (the UI may look completely different) |
| `improved` | A `fix` decision done, or a `ux`/`a11y` finding resolved, without removing anything |
| `dropped` | Only when the audit's parity decision is `drop` (agreed by the PM). Never your call |
| `open` | A `decide` item or design-priority gap: legacy behaviour is built; the call is still with product |
| `added` | Something legacy doesn't have. Allowed only if the designer approved it in Step 2, with a feasibility note |
| `missing` / `regressed` | **Not allowed at the end of a run.** Go back and build it |

How to check, not eyeball: for each `F:` row, find the control and confirm its options, default, limits and enabled-when; for each `R` row, put the prototype into the triggering state and see the rule hold; for each `S:` row, switch the scenario and see the state. A row that can only be reached by editing code fails.

Report the totals ("62 rows: 41 parity, 14 improved, 4 open, 3 added, 0 missing").

---

## Step 5 — Write the After into the audit

Read `references/before-after.md` for the exact shape and wording.

1. **Screenshots.** With the dev server running, capture each feature's After in Claude in Chrome at the same viewport, role and data as its Before shot. Save into the audit's `shots/` folder as `after-<legacy shot name>` (same name, `after-` prefix; `.png` or `.jpg` matching the folder). Put the mouse pointer on the part the row is about, as the legacy shots do.
2. **`before_after` in audit.json.** One row per feature id (`part`), status from Step 4 rolled up (worst wins: `open` > `added` > `improved` > `parity`), `before` and `after` shots, `changes` as `[what, before, after]` triples in plain words, and a `note`. Then one row per approved addition (`part: "add-<slug>"`, a `title` starting "Not in legacy:", feasibility in the note). On a re-run, update rows in place and keep earlier After shots.
3. **History.** Append `{"date", "step": "3 Prototype", "who", "what"}` to `history`. Don't touch `validation`, `gap_check` or `prototype_changes` (the designer ticks those on the published page).
4. **Rebuild the report** from the audit folder: `python3 ~/.claude/skills/legacy-parity-audit/scripts/build_report.py audit.json --shots shots --out <slug>-audit.html --page <slug>-page.html` (use the file names already in the folder). Fix every missing-shot warning it prints.
5. **Manifest.** Write the prototype manifest (screens, routes, components, states covered, and the `parity` ledger with final statuses) to the profile's location. Call `toge:workflow-state` to record it.

Publishing the audit page, pushing the audit to `sprout-hr-aidlc`, and opening the prototype PR are separate asks: offer them, don't do them unprompted.

---

## Step 6 — Report back

Keep it short:
- Branch and route to open the prototype (`http://localhost:6699/<route>`)
- Ledger totals by status
- The 3–6 biggest UX changes, each with its ledger ids
- Everything `open` and `added` (these go to the design review)
- Anything the audit couldn't tell you that you had to assume (and where it's marked in code with `// ASSUMPTION:`)
- Next step: "Review the prototype, then run `toge:design-qa` on the room."

Then call `toge:learnings` with any non-obvious pattern this conversion established (a reusable legacy → Toge mapping, a form pattern that worked), so the next page benefits.

---

## Never

- Remove or hide a user action, field, option, enum value, rule, validation, state, permission gate or exit because it seems unused, rare, odd or "probably dead". If it looks dead, keep it and say so in the row's note; dropping is the PM's call through `parity.decision: drop`.
- Merge two options that mean different things, or change a rule's outcome, a default, a limit or a calculation.
- Add a business capability (new options, bulk actions, new statuses, new settings) without the designer's approval in Step 2. Flagged additions only.
- Ship a state, role or scenario that is only reachable by editing code.
- Edit files under `src/design-system/`, the synced shell files, or `src/components/` vendored blocks.
- Push, publish, open PRs or write to the legacy site.
