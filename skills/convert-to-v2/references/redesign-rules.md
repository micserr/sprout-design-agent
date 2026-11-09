# Redesign rules: what may change and what may not

The audit's parity notes are **strict** (no new controls, options, steps or copy) because PM and engineering read them as requirements. This skill relaxes exactly one thing: **the experience**. The feature set stays strict.

Test for every decision: *After this change, can every user still do everything the ledger says, with the same outcome, under the same rules and permissions?* If yes, it's a redesign. If no, it's a deletion. If they can now do something they couldn't, it's an addition.

## Free to change (redesign)

| Area | Examples |
|---|---|
| Layout and information architecture | Split one long page into sections or tabs; join two legacy pages into a list + detail view; move actions into a page header or row menu |
| Flow | Page → side sheet or dialog; full-page form → stepped form; inline editing instead of a separate edit page; fewer clicks to the same outcome |
| Disclosure | Show branching questions progressively, collapse advanced settings — as long as every branch is still reachable and its answers kept |
| Components | Any Toge component that does the job: text links → buttons or menu items; jqGrid → `TogeDataTable`; bootbox → `TogeAlertDialog`; collapse rows → accordion or expandable table rows |
| Visual design | Typography, spacing, color (semantic tokens), icons, density, empty/loading illustrations, dark mode |
| Microcopy | Labels, headings, helper text, toasts and errors rewritten to the prototype repo's voice and four-part structures, **keeping the meaning**. Title-case inconsistencies, typos and jargon get fixed |
| Feedback for actions that already exist | Loading spinners on existing saves, success toasts for existing saves, inline validation of existing rules, disabled states that explain an existing gate |
| Accessibility | Labels, focus order, keyboard access, contrast, touch targets — always allowed |
| Responsive behaviour | Reflow for 820 and 390 in whatever way serves the content |

These are recorded as `changes` rows in the After, so the PM sees each one; they don't need approval up front unless they're big (a flow change across pages goes in the Step 2 plan).

## Not allowed (deletion)

- Dropping a user action, field, option, enum value, state, permission gate or exit.
- Changing a rule's outcome, a default value, a limit, an order that carries meaning, or which roles see what.
- Merging options that lead to different outcomes ("Hiring Anniversary" and "Start of Year" can't become one "Annual").
- Hiding something behind a path the user can't find. Progressive disclosure must be discoverable from the place the legacy page showed it.
- "Fixing" a bug whose parity decision is `carry`. Legacy behaviour wins until the PM marks it `fix`; mention the bug in the row's note.
- Deciding a `decide` item. Build the legacy behaviour, mark the row `open`; you may show an alternative as a UIFork variant if the designer asks.

## Allowed only with approval (addition)

Anything that gives users a new capability or new data: bulk actions, new filters or sorts on data legacy didn't let you filter, duplicate/"copy from", new statuses, search where there was none, new confirmations that change what the user must do, new settings, cross-page shortcuts.

Process: list it in the Step 2 plan under "Additions", the designer approves or cuts it, and an approved addition gets its own `before_after` row (`status: added`, title "Not in legacy: …", note with feasibility: low / medium / high and what it would need from the backend). Shell features the prototype already has (⌘K, Ask Sidekick, the sidebar) are not your additions; reuse them, and note on the row if the page now appears in them.

## Grey areas — how to call them

| Situation | Call |
|---|---|
| A confirm dialog before a destructive action legacy did without one | Addition (it adds a step). Propose it; it's usually approved |
| Unsaved-changes warning | Addition |
| Showing a count or status legacy computed but only showed elsewhere on the page | Redesign (same data, new place) |
| Showing data legacy loaded but never displayed | Addition |
| Inline validation of a rule legacy only checked on Save | Redesign (same rule, earlier feedback), as long as Save still enforces it |
| Replacing a free-text date with a date picker with the same limits | Redesign |
| A legacy control that never worked (dead button, hidden picker) | Keep it in the ledger as `open` with the audit's finding; don't build a working version unless the parity decision says `fix` |
