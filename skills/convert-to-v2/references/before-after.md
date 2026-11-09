# The After: `before_after` in audit.json

The audit report builder (`legacy-parity-audit/scripts/build_report.py`) already renders this block as the **Before and after** section, links each feature card to its row, and shows a status pill. Model: `audit/navigation/top-navigation/audit.json` in `sprout-hr-aidlc`, the first page converted this way.

## Shape

```jsonc
"before_after": {
  "intro": "Before is the legacy page as the audit captured it (<role> on <site>, <date>). After is the Sprout HR v2 prototype on <date> (sprout-hr-prototype, branch <branch>), using the demo account <name> (<role>), switched with the prototype's flask, which is a demo control only. In every After shot the mouse pointer marks the item the part is about. Each part says whether the prototype matches legacy, fixes it, differs, or adds something. The last rows list what the prototype adds.",
  "before_label": "Legacy <page names> (<site>)",
  "after_label": "Sprout HR v2 prototype, <room / view names> (sprout-hr-prototype, <branch or PR>)",
  "captured": "9 Nov 2026",
  "rows": [
    {
      "part": "lp-list",                       // a sections[].items[].id
      "status": "improved",                    // parity | improved | open | added | dropped (never missing/regressed at handoff)
      "before": [{"file": "lp-list-default.jpg", "caption": "Before: ..."}],
      "after":  [{"file": "after-lp-list-default.png", "caption": "After: ... (pointer on ...)"}],
      "changes": [
        ["What", "Before (legacy, plain words)", "After (prototype, plain words)"],
        ["Activate and Deactivate", "Green and red text links on the row", "A row menu with Activate / Deactivate; Deactivate asks to confirm (R3, R4 kept)"]
      ],
      "note": "Every action from the audit is here: 1.1–1.5. Rules R1, R3 kept. Plan name casing fixed (finding 1)."
    },
    {
      "part": "add-bulk-assign",               // approved additions: add-<slug>, no matching item
      "title": "Not in legacy: assign a plan to many employees at once",
      "status": "added",
      "before": [],
      "after": [{"file": "after-bulk-assign.png", "caption": "After: ..."}],
      "note": "Feasibility: medium. Needs a bulk endpoint; legacy assigns one plan at a time."
    }
  ]
}
```

## Writing rules

- Plain words, for a PM who never saw either page. No component names, file names, class names or pixel values in `changes` or `note`. "A side panel" not "TogeSheet".
- `changes` covers every difference a user would notice, including copy rewrites. Cite rule ids and action numbers in brackets when it helps the check (`R13`, `1.3`).
- `note` must say, for that part, that every ledger row is accounted for — or name the ones that are `open` and why.
- Status of a part = the worst of its ledger rows: `open` > `added` > `improved` > `parity`. A part whose parity decision is `drop` and is gone is `dropped`.
- Captions start with "Before:" / "After:" and say what the shot shows and where the pointer is.
- Every `file` must exist in `shots/`; the builder lists missing and unused files — fix both.
- On a re-run (After [2]), keep existing rows, replace their `after` shots, update `changes`/`note`, set `captured` to the new date, and add a `history` line saying what changed.

## Manifest `parity` block

The prototype manifest carries the full ledger (the `before_after` rows only roll it up per feature):

```yaml
parity:
  audit: _bmad-output/planning-artifacts/audit/maintenance/company/leave-policy/audit.json
  totals: { rows: 62, parity: 41, improved: 14, open: 4, added: 3, dropped: 0, missing: 0, regressed: 0 }
  rows:
    - { id: "lp-list.u3", kind: use, text: "Open a plan from its name", decision: carry,
        lands: "LeavePolicyView › plan row", treatment: redesigned, status: parity }
    - { id: "R13", kind: rule, text: "Never renewal only with upfront or both", decision: carry,
        lands: "PlanCreditsSection (useRenewalOptions.ts)", treatment: same, status: parity }
    - { id: "R18", kind: rule, decision: decide, status: open,
        note: "Built as legacy: question hidden, since nothing turns convert to cash on." }
```
