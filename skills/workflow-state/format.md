# Workflow-state Ledger Format

Reference examples of the ledger at various points in a feature's life. The authoritative schema is [`../../contracts/workflow-state.schema.yaml`](../../contracts/workflow-state.schema.yaml).

---

## Fresh ledger (after `init` only)

Just after `prd-gap-analyzer` runs on a new PRD, before it records its artifact:

```yaml
schema_version: "1"
feature: policy-prep-tool
bolt: 1
source_prd: _bmad-output/planning-artifacts/prd/prd-policy-prep-tool.md
source_prd_hash: 4f8d9c3a2b1e5f6d7c8b9a0e1f2d3c4b5a6e7f8d9c3a2b1e5f6d7c8b9a0e1f2d
source_ux_design: _bmad-output/planning-artifacts/ux/ux-design-policy-prep-tool.md
source_ux_design_hash: 9a0e1f2d3c4b5a6e7f8d9c3a2b1e5f6d7c8b9a0e1f2d3c4b5a6e7f8d9c3a2b1e
artifacts: []
next_recommended: []
blocked: []
drift: []
```

## After Phase 0 (screen spec) records

```yaml
schema_version: "1"
feature: policy-prep-tool
bolt: 1
source_prd: _bmad-output/planning-artifacts/prd/prd-policy-prep-tool.md
source_prd_hash: 4f8d9c3a2b1e5f6d7c8b9a0e1f2d3c4b5a6e7f8d9c3a2b1e5f6d7c8b9a0e1f2d
source_ux_design: _bmad-output/planning-artifacts/ux/ux-design-policy-prep-tool.md
source_ux_design_hash: 9a0e1f2d3c4b5a6e7f8d9c3a2b1e5f6d7c8b9a0e1f2d3c4b5a6e7f8d9c3a2b1e
artifacts:
  - kind: ux-screen-spec
    skill: product-design
    path: _bmad-output/planning-artifacts/ux/ux-screen-spec-policy-prep-tool.md
    produced: 2026-04-17
    agent: sprout-design-agent
    source_hashes:
      prd: 4f8d9c3a2b1e5f6d7c8b9a0e1f2d3c4b5a6e7f8d9c3a2b1e5f6d7c8b9a0e1f2d
next_recommended:
  - prototype
blocked: []
drift: []
```

## Mid-workflow (spec, prototype, QA all done)

```yaml
schema_version: "1"
feature: policy-prep-tool
bolt: 1
source_prd: _bmad-output/planning-artifacts/prd/prd-policy-prep-tool.md
source_prd_hash: 4f8d9c3a2b1e5f6d7c8b9a0e1f2d3c4b5a6e7f8d9c3a2b1e5f6d7c8b9a0e1f2d
source_ux_design: _bmad-output/planning-artifacts/ux/ux-design-policy-prep-tool.md
source_ux_design_hash: 9a0e1f2d3c4b5a6e7f8d9c3a2b1e5f6d7c8b9a0e1f2d3c4b5a6e7f8d9c3a2b1e
artifacts:
  - kind: ux-screen-spec
    skill: product-design
    path: _bmad-output/planning-artifacts/ux/ux-screen-spec-policy-prep-tool.md
    produced: 2026-04-17
    agent: sprout-design-agent
    source_hashes:
      prd: 4f8d9c3a2b1e5f6d7c8b9a0e1f2d3c4b5a6e7f8d9c3a2b1e5f6d7c8b9a0e1f2d
  - kind: prototype-manifest
    skill: prototype
    path: _bmad-output/planning-artifacts/ux/prototype/prototype-manifest-policy-prep-tool.md
    produced: 2026-04-18
    agent: sprout-design-agent
    source_hashes:
      prd: 4f8d9c3a2b1e5f6d7c8b9a0e1f2d3c4b5a6e7f8d9c3a2b1e5f6d7c8b9a0e1f2d
      ux-design: 9a0e1f2d3c4b5a6e7f8d9c3a2b1e5f6d7c8b9a0e1f2d3c4b5a6e7f8d9c3a2b1e
  - kind: ux-qa
    skill: design-qa
    path: _bmad-output/planning-artifacts/ux/ux-qa-policy-prep-tool-2026-04-18.md
    produced: 2026-04-18
    agent: sprout-design-agent
    verdict: conditionally-ready
next_recommended:
  - animations
  - handoff
blocked: []
drift: []
```

## Drift detected (John edited the PRD)

After `detect-drift` runs and finds the PRD hash no longer matches:

```yaml
# ...earlier fields unchanged...
drift:
  - upstream_kind: prd
    upstream_path: _bmad-output/planning-artifacts/prd/prd-policy-prep-tool.md
    affected_artifacts:
      - ux-screen-spec
      - prototype-manifest
    detected_at: 2026-04-19
    recommended_action: "Re-run Phase 0 screen spec translation and prototype"
```

The ledger doesn't automatically re-run anything. It surfaces the drift so the human (or design-audit skill) can decide.

## Vanilla profile

When the active profile sets `artifact_locations.workflow_state: null`, no ledger file is written. `workflow-state` operations return `{status: skipped, reason: "ledger disabled"}` and every Sprout skill proceeds without any ledger-keeping.

---

## Atomic-write discipline

To avoid torn writes (incomplete ledger files if invocation is interrupted):

1. Write full new content to `<ledger>.tmp`.
2. Rename `<ledger>.tmp` → `<ledger>`.
3. Never edit the ledger in-place.

This matters because multiple Sprout skills may write the ledger in the same session and an interruption mid-write would leave the file in a half-valid state.

---

## Recovery

If the ledger becomes malformed (e.g., YAML parse error):

1. `workflow-state init` renames the broken file to `<ledger>.broken-{date}.yaml`.
2. Creates a fresh ledger skeleton.
3. Reports the rename in its return value so calling skills can warn the user.

Artifacts on disk are preserved — the ledger is derived state and can be regenerated if lost (though drift detection is lost for artifacts produced before the rebuild).
