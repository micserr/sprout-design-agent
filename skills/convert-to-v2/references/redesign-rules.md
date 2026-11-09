# Redesign rules: what may change and what may not

This is a **parity migration**. The data and the features are fixed by the audit; only the UX and UI are redesigned.

Test for every decision:
1. *Can every user still do everything in the ledger, with the same data, rules, messages and outcome?* If no, it's a **deletion**: not allowed.
2. *Does the screen now show or do anything that isn't a ledger row?* If yes, it's an **addition**: not allowed.
3. If both answers pass, it's a **redesign**: allowed.

## May change (UX and UI)

| Area | Examples |
|---|---|
| Layout | Where things sit on the page, columns vs stacked, spacing, density, alignment |
| Grouping and order of presentation | Group related existing fields into sections, cards or tabs; put the main action first. Order that carries meaning (e.g. a ranked list, Active before Inactive) stays |
| Navigation between the same steps | A separate page becomes a side panel, dialog, tab or inline edit, reaching the same fields and actions. Every legacy way in (menu, links from other pages, URL variants) still lands on the same content |
| Disclosure | Show dependent questions only when their trigger is chosen — the same trigger legacy uses — and keep every branch reachable |
| Component choice | The Toge component that does the same job: text link → button or row menu item; jqGrid → `TogeDataTable`; bootbox → `TogeAlertDialog`; collapse row → accordion. Turn off any default behaviour legacy didn't have |
| Visual design | Typography, color (semantic tokens), icons beside an existing label or status (the text stays), borders, surfaces, dark mode |
| Responsive behaviour | How the same content reflows at 820 and 390 |
| Accessibility | Labels wired to inputs, focus order, keyboard access, contrast, touch targets, aria attributes. These don't add visible content |
| Loading indicators | A spinner or skeleton while an existing call runs, with no new text |
| Structural labels | A section heading, tab name or page title the new layout needs, **taken from words already in the audit** (the legacy section names, question text, page title) and approved in the plan |

Every one of these is recorded as a `changes` row in the After, so the PM can see it.

## May not change

**Features and behaviour**
- Removing or hiding any user action, field, option, enum value, state, permission gate or exit.
- Changing a rule's condition or outcome, a default, a limit, a calculation, or who can see what.
- Changing when a control is enabled, disabled, shown or hidden (e.g. disabling Save until the form is valid).
- Changing value formats (dates, numbers, units) or the order records are listed in.
- Removing a feature on a `drop` proposal before the audit is validated.
- Merging options that lead to different outcomes ("Hiring Anniversary" and "Start of Year" can't become one "Annual").
- Hiding something where users can't find it. Disclosure must open from the same choice legacy uses.
- Fixing a bug whose decision is `carry`. Only `fix` decisions change behaviour, and only as their `parity.changes` say.
- Deciding a `decide` item. Build legacy behaviour and mark it `open`.

**Data**
- Showing data the legacy page doesn't show, even if it loads it.
- New columns, counts, totals, badges, status labels, dates, avatars or summaries.
- Mock records, values or variety beyond what the audit shows.
- Dropdown, select, radio, checkbox-group or filter options the audit doesn't list. That includes lists filled from company data (Department, Employment Status, Position) that the audit didn't capture. Show what the audit shows (often just "All") and mark the rest unknown.

**Content**
- New messages of any kind: confirmations, warnings, success toasts, empty-state text, error text, inline hints, helper text, tooltips, placeholders, onboarding, descriptions.
- Rewording legacy labels or messages, except a `fix` change or a typo/casing problem an audit finding points out.

**New capability**
- Search, filters, sorting, bulk actions, duplicate/"copy from", export, undo, unsaved-changes warnings, keyboard shortcuts, new confirmations, new settings.

Ideas in any of these categories go in the report under **Ideas outside parity**. They are not built and not written into the audit.

## Calls on common grey areas

| Situation | Call |
|---|---|
| Legacy has a confirm before Deactivate | Keep it, as a Toge alert dialog with the legacy text |
| Legacy deletes without confirming | No confirmation. Note it under Ideas outside parity |
| Legacy validates only on Save | Validate on Save. Earlier (inline) validation only if the designer approves it as a timing change in the plan; same rule, same message |
| Legacy shows an error state as "Not handled" | Don't design an error state for it. It's in the ledger as `S:…/error` = not handled |
| Toge table shows "Showing 1–10 of 30" by default | Remove it unless legacy shows the same; legacy "10 a page" paging is kept |
| A legacy control never worked (dead button, hidden picker) | Keep its ledger row with the audit's finding; build it the way the audit says it behaves, or leave it `open` if the audit says it's a `decide` |
| A count legacy shows in one place, needed in another place by the new layout | Allowed only if it's the same value moved, not shown twice; record it as a UI change |
| An icon for a text label | The legacy text stays visible; an icon may sit beside it. No tooltip |
| A filter dropdown (Department, Employment Status…) whose values the audit didn't capture | Keep the control with only the default the audit shows ("All"). Mark it `// UNKNOWN`, list it for a re-audit, and don't fill it with sample departments |
| The audit lists the options but not their order | Use the order in the screenshot; if there's no screenshot, the order the audit lists them in, and note it |
| A plain legacy dropdown | Toge `Select`, not a combobox: a combobox adds search |
| Toge table defaults (sort arrows, rows-per-page selector, "Showing 1–10 of 30", row checkboxes) | Off, unless the legacy grid had the same |
| Toge default strings ("Select an option", "Pick a date", "No results found.") | Replace with the legacy text for that spot, or remove |
| Marking required fields with an asterisk | Allowed when the audit says the field is required. It's a visual cue for an existing rule; record it as a UI change |
| A form split into tabs, with an error on a tab that isn't open | Open the tab with the first error. No error summary or count |
| A Toge dialog needs a title or description and legacy had none | Use the legacy dialog's own heading text; leave the description out (or screen-reader-only with legacy text). Don't write one |
| Prototype shell (sidebar, ⌘K, Ask Sidekick) | Not part of this page and not your addition. Only add the page's nav entry at `meta.where` |
