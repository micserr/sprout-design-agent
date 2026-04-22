---
name: learnings
description: >
  Reads and writes the team-wide UX Learnings file — the agent's institutional
  memory. Accumulates patterns, anti-patterns, component preferences, conventions,
  and recurring QA findings across features so each new design benefits from
  everything the team has already learned.
  Called by design-qa and handoff after completing their passes.
  Human-callable for manual entries: "remember this", "add to learnings",
  "that worked well — save it", "what have we learned".
---

## Overview

The UX Learnings file is Sprout's institutional memory. It is **team-wide and shared** — one file per repo that grows across all features. Each new prototype, QA pass, and handoff adds entries; the agent reads this file at session start and applies relevant entries during design, silently and without ceremony.

**This is not a per-feature artifact.** The path has no `{feature}` placeholder — it is the same file for every feature. Old entries don't expire; they accumulate confidence.

---

## Contract

```yaml
reads:
  - kind: ux-qa
    required: false
    note: "Source for extracting qa-recurring and token-violation entries."
  - kind: ux-handoff
    required: false
    note: "Source for extracting pattern and convention entries."
  - kind: ui-feedback
    required: false
    note: "Source for extracting pattern and anti-pattern entries."
writes:
  - kind: ux-learnings
preconditions:
  - "Active profile declares ux_learnings (not null)"
postconditions:
  - "File at ux_learnings path is updated with new or reinforced entries"
  - "version is incremented"
  - "entry_count reflects current active entry count"
```

---

## File Format

The learnings file is a **markdown document with YAML front-matter** — not a raw YAML file. This makes it human-readable AND consumable by the agent as plain prose context.

```markdown
---
version: 4
last_updated: 2026-04-22
entry_count: 4
---

# Sprout UX Learnings

Team-wide design knowledge accumulated across features. Read at session start.

---

## Patterns

### LRN-001 · Use Table + Drawer for dense data + detail view
**Category:** pattern · **Applies to:** prototype · **Confidence:** 3×
**Last seen:** policy-prep-tool (design-qa, 2026-03-15)

Use a full-width data Table with a slide-in Drawer for detail. Never two-column
side-by-side layouts for dense datasets — at medium viewports the left column
becomes too narrow to read comfortably.

---

## Anti-Patterns

### LRN-002 · Never use Dialog for multi-step flows
**Category:** anti-pattern · **Applies to:** prototype · **Confidence:** 2×
**Last seen:** employee-profile (handoff, 2026-04-01)

Multi-step flows in a Dialog create focus trap and back-button problems.
Use a full page or a Drawer with a step indicator instead.

---

## Component Preferences

### LRN-003 · Use Select not RadioGroup for ≥4 options
**Category:** component-preference · **Applies to:** prototype · **Confidence:** 1×
**Last seen:** payslip-prep (design-qa, 2026-04-10)

When an option set has 4 or more choices, RadioGroup crowds the layout.
Use Select (dropdown) instead — it scales to any option count.

---

## QA Recurring

### LRN-004 · Focus states missing on icon-only buttons
**Category:** qa-recurring · **Applies to:** design-qa, prototype · **Confidence:** 4×
**Last seen:** payslip-detail (design-qa, 2026-04-18)

Icon-only buttons (e.g., close, sort, filter) consistently arrive at QA without
visible focus rings. Add `focus-visible:ring-2 focus-visible:ring-brand` to every
icon-only Button variant at prototype time — don't wait for QA to catch it.
```

---

## Operations

### `read`

Called at session start by the agent. Returns the full file content as context.

- If the profile's `ux_learnings` path is `null`: return empty (no-op profile).
- If the file doesn't exist yet: return empty — no learnings accumulated yet.
- Otherwise: read and return the full file.

The agent holds this as passive context. No user-facing message needed unless the user asks "what have we learned".

---

### `extract` — called after design-qa, handoff, or ui-feedback

Analyze the source artifact and identify learnings to capture:

**Extraction rules by source:**

| Source | Extract when | Category |
|---|---|---|
| design-qa | A finding is 🔴 Critical or 🟡 Major AND it describes a structural design decision (not a one-off typo fix) | `qa-recurring`, `anti-pattern` |
| design-qa | A finding appears more than once across the Findings Table (same root issue in multiple locations) | `qa-recurring` |
| design-qa | A token violation involves a primitive used instead of a semantic token | `token-violation` |
| handoff | A component splitting decision revealed a recurring structural pattern | `pattern`, `convention` |
| handoff | A composable was extracted from inline script — reveals a data pattern | `pattern` |
| ui-feedback | A `ui` feedback item reveals something about the design system's use | `component-preference` |

**Do NOT extract:**
- One-off formatting fixes (typo, label copy, a single color tweak)
- Findings that are feature-specific business logic — not generalizable design knowledge
- Anything already in the learnings file as-is

---

### `append` — write new or reinforce existing entries

After extraction, for each candidate learning:

1. **Check for duplicates.** Scan existing entries for semantic similarity (same rule, same component, same pillar). If a match exists:
   - Increment `reinforced_count`
   - Add the current feature + date to the `evidence` array
   - Update `last_seen` in the rendered body
   - Do NOT create a new entry

2. **If new:** Assign the next ID (`LRN-NNN`), write the entry into the correct section, increment `version` and `entry_count`, update `last_updated`.

3. **Report what was written:**
   - "Added 2 new learnings: LRN-008 (use Drawer for detail), LRN-009 (focus state missing on icon buttons)."
   - "Reinforced LRN-004 (focus states on icon buttons) — now seen 5 times."

---

### `list` — human-callable summary

When a human says "what have we learned", "show me the learnings", or "review our design patterns":

Produce a brief summary grouped by category:
- How many entries per category
- Top 3 by `reinforced_count` (most repeatedly seen)
- Any entries added or reinforced in this session

---

## Manual Entry Trigger

When a human says "remember this", "add this to learnings", "that worked well — save it", or "save this as a rule":

1. Ask (inline, not via AskUserQuestion): "Got it. What category — pattern, anti-pattern, component preference, convention, or QA recurring?"
2. If the user answers or the category is obvious from context: write the entry directly.
3. Assign the next ID, write, report: "Saved as LRN-NNN."

---

## Writing Rules

1. **Entries are written as decision rules**, not observations. Bad: "The team noticed focus states were missing." Good: "Add `focus-visible:ring-2` to every icon-only Button at prototype time."
2. **Body is 2–5 sentences max.** Longer entries get ignored. If it needs more explanation, break it into two entries.
3. **Evidence is factual.** Feature slug + phase + date. No editorial commentary in the evidence block.
4. **Status = active by default.** Only change to `superseded` or `reverted` when explicitly told to.
5. **Never delete entries.** Mark as `superseded` or `reverted` instead. The history is valuable.
6. **Deduplication beats proliferation.** Reinforcing an existing entry is always preferred over creating a near-duplicate.

---

## After Writing

- Report the file path (resolved from `active profile.artifact_locations.ux_learnings`)
- List what was added / reinforced
- No workflow-state ledger call needed — learnings is not a per-feature artifact

---

## Related

- [`../../contracts/ux-learnings.schema.yaml`](../../contracts/ux-learnings.schema.yaml) — output schema
- [`../../contracts/profile.schema.yaml`](../../contracts/profile.schema.yaml) — `ux_learnings` path declaration
- [`../design-qa/SKILL.md`](../design-qa/SKILL.md) — primary source of qa-recurring entries
- [`../handoff/SKILL.md`](../handoff/SKILL.md) — primary source of pattern and convention entries
