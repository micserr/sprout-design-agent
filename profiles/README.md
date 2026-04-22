# Profiles

A profile tells Sprout skills where to write, what front-matter to use, which other agents exist, and where prototype code lives. The same skill can run under different profiles and produce outputs that fit each team's SDLC.

## Shipped profiles

| File | For |
|---|---|
| [`bmad.yaml`](bmad.yaml) | Teams using BMAD. Full mesh with Sally/John/Winston coexistence. Outputs under `_bmad-output/planning-artifacts/ux/`. Feature-scoped ledger. Prototype code in sibling repo. |
| [`vanilla.yaml`](vanilla.yaml) | Teams with no framework. Outputs under `docs/design/`. Minimal front-matter. No ledger. Prototype code in-repo under `prototype/`. |

## Profile resolution order

At skill invocation, Sprout looks for the active profile in this order — first match wins:

1. `$REPO/.sprout/profile.yaml` — repo override (checked in, team-specific)
2. `$REPO/sprout-profile.yaml` — repo alternate location
3. `~/.claude/sprout-profile.yaml` — user default (written by install adapter)
4. `profiles/vanilla.yaml` — fallback

This means any team can override their user-level default on a per-repo basis without reinstalling.

## What a profile declares

See [`../contracts/profile.schema.yaml`](../contracts/profile.schema.yaml) for the full schema. The top-level sections are:

| Section | Purpose |
|---|---|
| `artifact_locations` | Path template for each artifact kind the profile produces. Uses `{feature}` and `{date}` placeholders. |
| `input_sources` | Where the profile expects to find PRDs, optional UX specs, etc. |
| `front_matter` | Front-matter style for outputs (`bmad`, `minimal`, or `custom`). |
| `coexistence_agents` | Other agents whose artifacts Sprout may read (enables Sally-preferred-over-PRD pattern). |
| `prototype.code_target` | Where `prototype` skill writes Vue/React code. Sibling repo or in-repo. |
| `naming` | Case, date format, and how to derive the `{feature}` slug. |

## Authoring a custom profile

Most teams won't need a fully custom profile. Easiest path is to extend a shipped one:

```yaml
# profiles/my-team.yaml
profile: my-team
display_name: "My Team (Linear + custom paths)"
extends: vanilla

artifact_locations:
  # Override just the paths that differ — everything else inherits from vanilla
  ux_screen_spec: "design-docs/{feature}/screen-spec.md"
  ux_qa: "design-docs/{feature}/qa-{date}.md"

coexistence_agents:
  - name: PM-agent
    role: Product Manager via Linear
    produces: [prd]
```

Save this file anywhere — `profiles/` if you want to contribute it upstream, `$REPO/.sprout/profile.yaml` if it's team-private. Point the profile resolver at it and the skills adapt.

## When to author a full profile

Write a full profile (without `extends`) when:

- Your SDLC has conventions that don't match either shipped profile.
- You need different front-matter (e.g., Notion-compatible, Linear-shaped).
- You have multiple partner agents (besides John and Sally) and the coexistence logic needs custom preference rules.

The schema at `contracts/profile.schema.yaml` is authoritative — any valid profile is one that passes schema validation.

## Relationship to install adapters

Install adapters (`adapters/claude.sh`, `adapters/bmad.sh`, etc.) ask which profile to use at install time and write the selection to `~/.claude/sprout-profile.yaml` (or the BMAD module equivalent). The `adapters/bmad.sh` adapter auto-selects `bmad` since it's a BMAD install by definition. Other adapters default to `vanilla` unless the user picks otherwise.

## Relationship to the Sprout core

Skills never reference paths directly. They reference **kinds** (e.g., `kind: ux-screen-spec`). At invocation, Sprout resolves `kind → profile.artifact_locations[kind] → path`. This is what makes skills portable across teams.
