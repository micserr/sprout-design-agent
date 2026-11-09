---
name: toge:convert-to-v2
description: >
  Converts a legacy Sprout HR parity audit (the audit.json + shots folder made by the
  legacy-parity-audit skill) into a Sprout HR v2 prototype built with the Toge design system,
  then writes the After back into the same audit so PM, Design and engineering can check it
  against legacy. Strict parity on data and features: every user action, field, option, rule,
  state, permission, exit and message in the audit is kept, and nothing that isn't in the audit
  is added or invented. Only the UX and UI change: layout, flow, grouping, components and visual
  design are redesigned with Toge. Use whenever the user wants to turn an audit into a prototype,
  "convert to v2", "build the After", "redesign this legacy page", "migrate <page> to the new
  design system", or points at a folder under planning-artifacts/audit/ and asks for the new version.
---

# Convert to v2

Turns a **legacy parity audit** (steps 1–2 of the HR SPA process) into the **v2 prototype** (step 3) and the **Before and after** section the design review (step 4) and the legacy check (step 5) read.

**This is a parity migration.** The contract:

- **Same data, same features.** Every user action, field, option, value, rule, validation, message, state, permission and exit in the audit is in the prototype, with the same outcome.
- **Nothing extra.** No feature, field, option, column, filter, action, step, confirmation, message, helper text, tooltip, number or data the audit doesn't contain. If it isn't in `audit.json`, it isn't in the prototype.
- **Only the UX and UI change.** How the same things are laid out, grouped, reached and styled, using Toge.

```
audit/<module>/<page>/audit.json + shots/      (Before — PM + engineer, from legacy-parity-audit)
        │
        ▼  convert-to-v2
  1. Parity ledger      everything in the audit, numbered — the complete list of what the prototype may contain
  2. Redesign plan      v2 screens + Toge components + what changes in the UI  ── designer approves
  3. Prototype          a room in sprout-hr-prototype, built only from ledger rows
  4. Parity check       both ways: every ledger row is in the prototype, everything in the prototype is a ledger row
  5. After              after-* screenshots + before_after in audit.json, report rebuilt
```

Read `references/redesign-rules.md` before Step 2. It lists exactly what may change and what may not.

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
    - every ledger row has a status; none is "missing", "regressed" or "added"
    - every control, text, value and column on the v2 screens traces to a ledger row (no orphans)
    - npm run verify passes in the prototype repo
    - audit.json has before_after rows for every feature id, and the report rebuilds clean
```

If a precondition fails, stop and say which one.

---

## Inputs and where things live

| What | Default for Sprout HR v2 |
|---|---|
| Audit folder | `sprout-hr-aidlc/_bmad-output/planning-artifacts/audit/<module>/<page>/` (the user gives the path) |
| Prototype repo | sibling `sprout-hr-prototype/` (find it next to `sprout-hr-aidlc`; ask only if it isn't there) |
| Audit report builder | `~/.claude/skills/legacy-parity-audit/scripts/build_report.py` |
| Manifest | profile `artifact_locations.prototype_manifest` (BMAD: `_bmad-output/planning-artifacts/ux/prototype/prototype-manifest-{feature}.md`), `{feature}` = the audit slug with `/` → `-` |

**Read `audit.json`, not the HTML.** The `*-audit.html` / `*-page.html` files are several MB of embedded screenshots and say nothing the JSON doesn't. Open screenshots in `shots/` by name when you need to see exact labels, values or a state.

What the audit gives you:

| audit.json | Use it for |
|---|---|
| `meta`, `overview` | Who uses it, where it sits in the menu (`meta.where`), role, viewports |
| `sections[].items[]` (e.g. `lp-list`) | One feature each. `uses[]` = user actions to keep; `findings` = today's problems; `parity` = the agreed treatment (`carry`, `fix` with `parity.changes`, `drop`, `decide`) |
| `spec.fields[]` | Every control with its label, default, limits, validation and enabled-when |
| `spec.rules[]` (`R1`…) | Business rules and the exact validation messages |
| `spec.states[]` | Per widget: loading / loaded / empty / error / hidden, with the legacy text for each |
| `spec.interactions[]` | Control → what it does → endpoint. Becomes a function in `mocks.ts` |
| `spec.components[]` | Legacy UI building blocks → map each to Toge |
| `spec.permissions[]` | Role gates |
| `spec.dependencies.exits` | Where the page links out |
| `sections[].items[].data`, `load_calls` | The data the page shows — the only data the prototype may show |
| `gap_check.gaps[]`, `decide` | Open product calls: build legacy behaviour, mark `open` |
| `prototype_changes[]` | Changes since the audit was published. Each one is a requirement |
| `validation` | Empty = the decisions are still **proposals** (Draft). You may start, but see *Draft decisions* below |
| `unverified`, `not_covered`, values like "Not known" | Gaps in the audit. **Never fill them in yourself** (see Unknowns) |
| `before_after` | If it exists, this is a re-run: update rows, don't wipe them |

---

## Step 1 — Build the parity ledger

Turn the audit into a flat, numbered list. The ledger does two jobs: it is what the prototype **must** contain, and it is **everything** the prototype may contain.

One row per:
- **user action**: each `items[].uses[]` → `<item>.u<n>` (e.g. `lp-list.u3`)
- **rule**: each `spec.rules[].items[]` → its `R` id
- **field / control**: each `spec.fields[].rows[]` → `F:<form>/<field>`, with its legacy label, default, limits, value format (e.g. date 'M dd, yyyy') and enabled-when copied exactly
- **state**: each `spec.states[]` × {loading, loaded, empty, error, hidden} that the audit describes → `S:<widget>/<state>`, with the legacy text
- **interaction**: each `spec.interactions[]` → `I:<control>`
- **permission**: each `spec.permissions[]` → `P:<role>`
- **exit**: each `spec.dependencies.exits[]` → `X:<n>`
- **entry point**: each way a user arrives — the menu path (`meta.where`), links from other pages, and URL variants that change what opens (e.g. `LeavePolicy.aspx?action=update&from=activate`) → `E:<n>`. Each one must still land the user on the same content in v2
- **option list**: each dropdown, select, combobox, radio group, checkbox group, segmented control, filter or picker → `O:<form>/<field>`, with **every option exactly as the audit gives it, in the same order, and where it came from** (see *Option lists* below)
- **data shown**: each piece of data the audit says a feature displays (`items[].data`, column names, counts), with its format and the order records are listed in → `V:<item>/<name>`
- **message / copy**: each validation, confirmation, toast and on-screen text the audit quotes → `M:<n>`, verbatim
- **open item**: each `decide` and each `gap_check.gaps[]` with `priority: design` → `D:<n>`
- **prototype change**: each `prototype_changes[]` → its `p` id

Each row records `id`, the audit text, the `parity.decision`, and — filled in Step 2 — **where it lands in v2** (screen + component).

### Draft decisions

Design may start before the PM validates the audit, so a decision can still change. Build so that nothing is lost if a proposal is rejected:

| `parity.decision` | Audit validated (`validation.pm` and `date` filled) | Audit still Draft |
|---|---|---|
| `carry` | Build as legacy | Build as legacy |
| `fix` | Build exactly as `parity.changes` say → `improved` | Build as `parity.changes` say, mark the row `improved (proposed)`, and keep the legacy behaviour noted in code so it can be switched back |
| `drop` | Leave it out → `dropped` | **Keep it, built as legacy**, mark `open`. Never remove a feature on a proposal |
| `decide` | Build legacy behaviour → `open` | Build legacy behaviour → `open` |

Write the ledger into the manifest's `parity` block (schema: `contracts/prototype-manifest.schema.yaml`) and tell the designer the totals by kind.

### Option lists

Dummy options in dropdowns are the most common way invented data gets into a parity prototype. Every option list needs a source, found in this order:

1. The field row: `spec.fields[].rows[].limits`, `default`, `notes` (e.g. Tracking days: `calendar, working`)
2. A rule that lists the values (e.g. R13: Hiring Anniversary, Start of Year, Never, Custom)
3. The feature text: `items[].summary`, `uses`, `data`, `findings` (e.g. Employee Level: All, Rank and file, Manager, Officer)
4. The screenshot of that control open (`shots/`), read option by option
5. `probe.json` controls

Copy the options **word for word, in legacy order, with the legacy default and placeholder** ("Select…", "All", "Day"). Record the source on the `O:` row.

**When no source lists the options**, the list is **unknown**. This is common for lists that come from company data, like Department, Employment Status, Position or Location. Then:
- Don't fill it with plausible values ("Engineering", "Marketing", "Option 1", lorem ipsum), and don't borrow values from another room's mocks.
- Build the control with only what the audit shows. That's often just the default (e.g. "All"), or the one value visible in a screenshot.
- Mark it `// UNKNOWN: O:<form>/<field> — options not captured in the audit`, list it in the plan and the report, and suggest a re-audit to capture the options.
- If the designer needs a filled list to judge the layout, ask them for it. Don't make one up.

---

## Step 2 — Redesign plan (designer checkpoint)

1. **Know the toolset.** In the prototype repo, follow its `CLAUDE.md`: list `src/design-system/components/ui/` and `src/components/`, read the `*.stories.ts` for every component you plan to use, read `src/design-system/styles.css` for tokens, read `docs/learnings/*` and the team UX learnings. Look at an existing HR room (`src/modules/navigation/`) and the reference room (`src/modules/dashboard/`); reuse the shell, don't rebuild it. Never call the Toge MCP server; it returns stale data.
2. **Map components.** For every `spec.components[]` entry and every distinct control in `spec.fields`, name the Toge component that does the same job (e.g. bootbox confirm → `TogeAlertDialog`, jqGrid with pager → `TogeDataTable`, collapse row → `TogeAccordion`, toastr → the Sonner toast). Only use names you saw in the folder. Pick the component whose **behaviour** matches the legacy control, not the richest one, and switch off what legacy didn't have:
   - A plain legacy select → `Select`, not a combobox (a combobox adds search).
   - A legacy grid → a table **without** sorting, filtering, column hiding, row selection or a rows-per-page selector unless the legacy grid had them; legacy paging (e.g. "10 a page") is kept as is.
   - A date field → a date picker with the legacy format, first allowed date and limits.
   - Replace every built-in string a component shows by default ("Select an option", "Pick a date", "No results found.", "Search…", "Showing 1–10 of 30", "Rows per page") with the legacy text for that spot, or remove it if legacy had none.
3. **Design the v2 UI.** Decide the screens, the flow between them, and the layout, using only ledger rows. Start from the user's job (`overview`, `uses`) and from the `ux` / `a11y` findings, and solve them with layout, grouping, order, disclosure and component choice — not with new content.
4. **Present the plan** in one message, then ask with `AskUserQuestion` whether to build it, adjust it, or see an alternative:
   - Screen list with route, and a 2–4 line description of each
   - The component map (legacy → Toge), as a table
   - **What changes in the UI**, one line each, citing ledger ids (e.g. "New Plan opens in a side panel instead of a new page — lp-list.u4")
   - **New structural labels** the layout needs (section headings, tab names, page title), each with the audit text it was taken from. No label without a source
   - `decide` items, built as legacy behaviour
   - **Unknowns** that affect the design (see below), with the question for the PM
   - Ledger totals

Don't write code until the designer answers.

---

## Step 3 — Build the prototype

Follow the prototype repo's `CLAUDE.md` and `CONTRIBUTING.md`; they win over anything here, **except** where they would add content: the repo's microcopy guide shapes how existing messages are laid out, it doesn't license new messages, empty states, success toasts or helper text.

- **Branch.** Find the active bolt (`git ls-remote --heads origin 'sprout-hr/bolt-*'`, highest number), branch from it as `<module>/feat/<slug>` (e.g. `maintenance/feat/leave-policy-v2`). Never work on a bolt branch, `dev` or `main`. Commit and open a PR only when the user asks.
- **Room.** `src/modules/<room>/` with `views/ components/ composables/ routes.ts mocks.ts`. Register routes in `src/router/index.ts` and the nav entry in `src/shell/nav.config.ts` at the menu path from `meta.where`.
- **Text is copied, not written.** Every label, option, button, heading, message and placeholder comes from the audit (or the screenshots) word for word. Only change wording where a `fix` decision's `parity.changes` says so, or to correct an obvious typo or casing inconsistency that an audit finding points out — and record each one as a change row in Step 5.
- **Formats and order are copied.** Dates, numbers, units, casing of values and the order records are listed in match legacy (unless a `fix` changes them).
- **Enabled-when is copied.** A control is enabled, disabled, shown or hidden under exactly the conditions in its `F:` row. Don't disable Save until the form is valid, hide actions behind hover, or reveal things earlier than legacy does.
- **Errors stay where the user can see them.** If the new layout splits a form into sections or tabs, the legacy error output (marked fields and the legacy toast/message) must still reach the user, e.g. by opening the section that holds the first error. Don't add an error summary, banner or count that legacy doesn't have.
- **Entry points still work.** Every `E:` row lands on the same content: the nav entry at `meta.where`, and a route or query for each legacy URL variant (e.g. Activate opening the default plan with every employee ticked).
- **Data is copied, not made up.** `mocks.ts` holds only the data the audit shows: the same entities, fields, enum values, counts and examples (e.g. the 9 leave types with Vacation the only active one, one plan each, 3 employees). Don't add records, fields or variety the audit doesn't show. For people, reuse the prototype's existing demo people (`src/stores/user`, other rooms' mocks) for **names only**, as many as the audit shows. Show only the attributes the audit shows for them (not their department, position or photo unless the audit does). Never invent new personas, and never copy real names from screenshots. Every mock function is named after the legacy action with the legacy endpoint in a comment (`// legacy: LeaveTypesAndPolicies.aspx/DeactivateLeaveType`).
- **Option lists exactly as the ledger has them.** Every dropdown, select, radio group, checkbox group and filter in `mocks.ts` or the template uses the `O:` row's options, order, default and placeholder, and nothing else. Never type an option list from memory or from what such a field "usually" contains.
- **Rules exactly as written.** Put rule logic in composables and cite the rule at the line: `// R13 — Never is only offered with upfront or both`. Validate at the same moment legacy does (e.g. on Save) unless the designer approved a timing change in Step 2. Same conditions, same messages.
- **Every audit state reachable.** States from `spec.states`, role differences from `spec.permissions`, and the data cases the rules depend on (e.g. a type with a pending CTO application) are switchable from the prototype's scenario flask (`PrototypeScenarioPicker.vue` pattern), never as controls in the product UI. Build only the states the audit describes; a state the audit says legacy doesn't have (e.g. "error: Not handled") is not invented.
- **Toge only.** No raw `<input>`, `<button>`, `<select>`; semantic tokens only; type scale from `styles.css`; banner comment on every non-trivial file; ~300 lines per file before splitting.
- **Responsive** at the viewports in `meta.viewports`.
- Run `npm run verify` and fix what it reports.

### Unknowns

When the audit doesn't say something — `unverified`, `not_covered`, a field limit "Not known", a server message never captured — **don't fill the gap with a likely answer.** Build only what the audit confirms, leave the unknown part out or plain, mark it in code with `// UNKNOWN: <ledger id> — <what the audit says>`, and list it in the report as a question for the PM. If an unknown blocks the layout, ask the designer.

---

## Step 4 — Parity check (both directions)

Run the dev server (port 6699) and check in Claude in Chrome.

**A. Ledger → prototype.** Walk every ledger row and give it a status:

| Status | Meaning |
|---|---|
| `parity` | Same data and outcome as legacy (the UI may look completely different) |
| `improved` | A `fix` decision done exactly as its `parity.changes` say (`improved (proposed)` while the audit is Draft) |
| `dropped` | Only when the audit's `parity.decision` is `drop` **and the audit is validated**. Never your call |
| `open` | A `decide` item or design-priority gap: legacy behaviour is built; the call is with product |
| `missing` / `regressed` | **Not allowed at the end of a run.** Go back and build it |

How to check: for each `F:` row, find the control and confirm label, options, default, limits and enabled-when match; for each `R` row, put the prototype in the triggering state and see the rule and its message; for each `O:` row, open the control and compare every option, its order, the default and the placeholder against the row; for each `S:` row, switch the scenario and see the state. A row only reachable by editing code fails.

**B. Prototype → ledger (no orphans).** Go through every v2 screen, dialog and state and list every visible text, control, column, value, badge and message, **and open every dropdown, select, combobox and filter to list its options**. Each must match a ledger row, or be a structural label approved in Step 2. Anything else is an addition: **remove it.** This includes things a Toge component adds by default (sort arrows, filters, pagination text, counters, empty-state copy) when legacy didn't have them.

Do it mechanically, not by eye:
- **In the browser:** for each screen, dialog and scenario state, run a script in Claude in Chrome that collects every visible text node, `placeholder`, `aria-label`, `title`, button label and every option of every select, combobox, radio and checkbox group. Compare the set with the ledger's strings (labels, options, messages, data values, approved structural labels).
- **In the code:** list every user-facing string literal in the room (`src/modules/<room>/**`, including `mocks.ts`) and match each one to a ledger row.
- Every string with no match is an orphan. Remove it, or if it's legacy text you missed in Step 1, add its ledger row with its audit source. A string that isn't in the audit at all is never kept.

Report the totals ("62 rows: 48 parity, 10 improved, 4 open, 0 missing · 0 orphans").

---

## Step 5 — Write the After into the audit

Read `references/before-after.md` for the exact shape and wording.

1. **Screenshots.** Capture each feature's After at the same viewport, role and data as its Before shot. Save into the audit's `shots/` folder as `after-<legacy shot name>`. Put the mouse pointer on the part the row is about.
2. **`before_after` in audit.json.** One row per feature id (`part`), status rolled up from Step 4 (worst wins: `open` > `improved` > `parity`), `before` and `after` shots, `changes` as `[what, before, after]` triples describing **UI changes only**, and a `note` confirming every ledger row for that part is accounted for. No "Not in legacy" rows. On a re-run, update rows in place and keep earlier After shots.
3. **History.** Append `{"date", "step": "3 Prototype", "who", "what"}`. Don't touch `validation`, `gap_check` or `prototype_changes`.
4. **Rebuild the report** from the audit folder: `python3 ~/.claude/skills/legacy-parity-audit/scripts/build_report.py audit.json --shots shots --out <slug>-audit.html --page <slug>-page.html` (use the file names already there). Fix every missing-shot warning.
5. **Manifest.** Write the prototype manifest with the final `parity` ledger to the profile's location. Call `toge:workflow-state` to record it.

Publishing the audit page, pushing the audit, and opening the prototype PR are separate asks: offer them, don't do them unprompted.

---

## Step 6 — Report back

Keep it short:
- Branch and route (`http://localhost:6699/<route>`)
- Ledger totals by status, and orphans removed (should end at 0)
- The 3–6 biggest UI changes, with ledger ids
- Everything `open`, and every `// UNKNOWN` with its question for the PM
- **Ideas outside parity** (optional): improvements you noticed that would need new content or features. They are **not built** and not written into the audit; they're for the PM to raise as separate requests
- Next step: "Review the prototype, then run `toge:design-qa` on the room."

Then call `toge:learnings` with any reusable legacy → Toge mapping this conversion established.

---

## Never

- Add a feature, field, option, column, filter, sort, search, bulk action, step, confirmation, warning, message, helper text, tooltip, empty-state copy, success toast, badge, count, chart or data the audit doesn't contain — even if it would help. Put it under "Ideas outside parity" in the report instead.
- Invent data: records, values, dropdown/select/radio/filter options, limits, defaults, placeholders, dates, names or numbers the audit doesn't show. An option list without a source stays unknown.
- Fill an audit gap (`unverified`, `not_covered`, "Not known") with a guess.
- Reword copy beyond `fix` changes and audit-flagged typos/casing.
- Remove or hide anything in the ledger because it seems unused, rare or dead. Dropping is the PM's call through `parity.decision: drop`.
- "Fix" a bug whose decision is `carry`; legacy behaviour wins and the bug stays noted.
- Merge options that mean different things, or change a rule's outcome, a default, a limit or a calculation.
- Edit files under `src/design-system/`, the synced shell files, or vendored `src/components/` blocks.
- Push, publish, open PRs or write to the legacy site.
