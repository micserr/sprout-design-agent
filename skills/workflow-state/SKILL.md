---
name: workflow-state
description: >
  Internal helper skill used by other Sprout skills to read and update the
  feature-scoped workflow-state ledger. Not invoked by humans directly.
  Reads the active profile to resolve the ledger path; on profiles where
  the ledger is disabled (e.g., vanilla), all operations become no-ops.
  Provides three operations — init, record, detect-drift — consumed by every
  Sprout skill that produces an artifact.
---

## Overview

The workflow-state ledger is the mesh's shared memory: which Sprout artifacts exist for a feature, when they were produced, what their source hashes were, and what should run next. This skill is the **only** thing that writes to the ledger — every other Sprout skill calls this helper rather than managing the ledger directly.

**This skill is not for humans to invoke.** It's invoked by other skills. If a human calls it directly, it'll report ledger state for the requested feature, which is harmless but not the intended use.

See [`../../contracts/workflow-state.schema.yaml`](../../contracts/workflow-state.schema.yaml) for the ledger format.

---

## Profile-awareness

The ledger's path is declared by the active profile at `artifact_locations.workflow_state`:

| Profile | Ledger path | Behavior |
|---|---|---|
| `bmad` | `_bmad-output/state/ux-workflow-{feature}.yaml` | Full ledger maintained |
| `vanilla` | `null` | All operations become no-ops |
| custom | per-profile | Check profile file |

When the profile sets `workflow_state: null`, every operation in this skill returns success with no side effect. Calling skills don't need to branch on profile — they always call the helper.

---

## Operations

### `init`

Called by the first Sprout skill that runs for a feature. Creates the ledger file if it doesn't exist, populated with:

```yaml
schema_version: "1"
feature: <kebab-case feature slug>
bolt: <integer or null>              # from PRD front-matter if present
source_prd: <path or null>
source_prd_hash: <sha256 or null>
source_ux_design: <path or null>
source_ux_design_hash: <sha256 or null>
artifacts: []
next_recommended: []
blocked: []
drift: []
```

If the file already exists, `init` updates the `source_*` fields if they changed and leaves `artifacts` alone.

**Invocation:**
1. Read active profile. If `workflow_state` is null → return `{status: skipped, reason: "ledger disabled"}`.
2. Resolve `{feature}` in the profile's ledger path template.
3. If file exists, load it. Else create the skeleton above.
4. If `source_prd` was provided by caller: compute SHA-256 of the PRD, store both path and hash. Repeat for `source_ux_design`.
5. Write the file. Return `{status: ok, ledger_path: <path>}`.

### `record`

Called by every Sprout skill after it writes an artifact. Appends an entry to `artifacts[]`:

```yaml
- kind: <artifact kind from contracts/>
  skill: <skill slug>
  path: <where the artifact was written>
  produced: <ISO date>
  agent: sprout-design-agent
  verdict: <optional — the artifact's reported status>
  source_hashes:
    <kind>: <sha256 at time of production>
    ...
```

**Invocation args:**
- `kind` (required)
- `skill` (required)
- `path` (required)
- `verdict` (optional)
- `source_hashes` (optional map): the caller computed these at read time; the helper just stores them

**Invocation:**
1. Read active profile. If ledger disabled → return skipped.
2. Load the ledger (call `init` if absent).
3. Look for an existing entry with the same `kind` + `skill`. If found, update it (don't duplicate). Else append.
4. Update `next_recommended:` based on a small decision table:
   - After `ux-screen-spec` → recommend `prototype`.
   - After `user-journey` (optional) → recommend `prototype`.
   - After `prototype-manifest` → recommend `design-qa`, `animations`.
   - After `ux-qa` handoff_status=ready → recommend `animations` (optional) or `handoff`.
   - After `handoff` status=ready → no next; downstream agents take over.
5. Write the file. Return `{status: ok}`.

### `detect-drift`

Called by any skill that wants to verify its upstream inputs haven't changed since a downstream artifact was produced. Recomputes hashes of source files and compares against the ledger's recorded `source_hashes` for each artifact.

**Invocation:**
1. Read active profile. If ledger disabled → return `{status: skipped}`.
2. Load the ledger.
3. For each artifact in `artifacts[]`, for each entry in its `source_hashes`:
   - Read the source file at the kind's resolved path.
   - Compute SHA-256.
   - Compare to stored hash.
   - If different, record a drift entry in `drift[]` with `upstream_kind`, `upstream_path`, `affected_artifacts` (artifact kinds that used this source), and `recommended_action: "Re-run <skill>"`.
4. Write ledger. Return `{status: ok, drift_count: N}`.

---

## Rules

- **Never write outside the ledger path.** This skill only touches `{profile.artifact_locations.workflow_state}`.
- **Never block on YAML parse errors.** If the ledger file is malformed, rename it with a `.broken-{date}` suffix and create a fresh one. Report the rename in the return value.
- **Always preserve unknown fields.** When updating, round-trip the file — don't drop fields this skill doesn't recognize. Teams may add custom fields.
- **Atomic writes.** Write to a temp file + rename, to avoid torn writes if invocation is interrupted.
- **Resolve `{feature}` consistently.** The helper takes `{feature}` as an explicit argument from the caller; it doesn't re-derive.

---

## Related

- [`format.md`](format.md) — ledger file structure, real examples.
- [`../../contracts/workflow-state.schema.yaml`](../../contracts/workflow-state.schema.yaml) — authoritative schema.
- [`../../profiles/bmad.yaml`](../../profiles/bmad.yaml) — declares the ledger path.
- Other Sprout skills call this helper at the end of their process — see `prd-gap-analyzer/SKILL.md` for the first one to do this.
