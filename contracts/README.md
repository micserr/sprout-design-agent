# Contracts

YAML schemas describing the shape of every artifact that crosses an agent boundary in the Sprout mesh. Schemas are **framework-neutral** — they describe the body of an artifact, not where it lives. Location is declared in [`../profiles/`](../profiles/).

## Why contracts?

Sprout skills can be invoked standalone or chained. When a human (or another agent) runs a skill in isolation, the skill needs to know:

- What shape of input to expect (a PRD, a UX spec, a feedback doc, etc.)
- What shape of output to produce
- What's required vs. optional

Contracts formalize this. Every skill's `SKILL.md` declares the kinds of input it reads and the kind of output it writes. Kinds resolve to schemas here; paths resolve to the active profile.

## The kinds

| Kind | Schema | Produced by | Consumed by |
|---|---|---|---|
| `prd` | [`prd.schema.yaml`](prd.schema.yaml) | PM agent (John in BMAD; any PM elsewhere) | design agent Phase 0, fallback for many skills |
| `ux-design` | [`ux-design.schema.yaml`](ux-design.schema.yaml) | BMAD's Sally (`bmad-create-ux-design`) — optional input for Sprout skills | design agent Phase 0, `prototype`, `design-qa`, `handoff` |
| `ux-screen-spec` | [`ux-screen-spec.schema.yaml`](ux-screen-spec.schema.yaml) | design agent Phase 0 — translates product outcome + product unit into screens, states, flow, and open design decisions | `prototype`, `design-qa`, `handoff` |
| `ux-journey` | [`ux-journey.schema.yaml`](ux-journey.schema.yaml) | `user-journey` (optional) | `prototype`, `design-audit` |
| `prototype-manifest` | [`prototype-manifest.schema.yaml`](prototype-manifest.schema.yaml) | `prototype` | `design-qa`, `design-audit`, `handoff`, `design-feedback` |
| `ux-qa` | [`ux-qa.schema.yaml`](ux-qa.schema.yaml) | `design-qa` | `handoff`, `design-audit` |
| `ui-feedback` | [`ui-feedback.schema.yaml`](ui-feedback.schema.yaml) | design agent — on-demand, triggered when anyone submits UI feedback | prototype (applies changes), human review |
| `ux-handoff` | [`ux-handoff.schema.yaml`](ux-handoff.schema.yaml) | `handoff` | downstream agents (architect, dev) |
| `ux-audit` | [`ux-audit.schema.yaml`](ux-audit.schema.yaml) | `design-audit` (future) | human review |
| `workflow-state` | [`workflow-state.schema.yaml`](workflow-state.schema.yaml) | `workflow-state` helper skill | every Sprout skill |
| `profile` | [`profile.schema.yaml`](profile.schema.yaml) | profile author | Sprout core at skill invocation |

## How schemas are written

Each schema file:

1. Starts with `$schema:`, `title:`, and `description:` at the top.
2. Declares required and optional fields with types and examples.
3. Documents which skill reads/writes it.
4. Keeps paths out — paths belong to profiles.
5. Tolerates variation at the edges (e.g., a PRD schema matches the BMAD 11-section shape by default but accepts shorter/looser PRDs too). The goal is to accept any reasonable input, not reject non-conforming docs.

## How skills use schemas

A skill's `Contract:` block references kinds, not schemas directly:

```yaml
contract:
  reads:
    - kind: ux-design
      required: false
      preferred_when_present: true
    - kind: prd
      required: true
      fallback_for: ux-design
  writes:
    - kind: ux-readiness
```

At invocation, Sprout resolves:

1. The active **profile** from `.sprout/profile.yaml` (repo) or `~/.claude/sprout-profile.yaml` (user).
2. The profile's `input_sources` entry for each `kind` → gives the skill the path pattern + required flag.
3. The profile's `artifact_locations` entry for the `writes.kind` → gives the skill where to put its output.

Same skill. Different profile = different paths. Same rigor.

## Extending contracts

New artifact types land here with:

1. A new `*.schema.yaml` file following the pattern above.
2. A row in the kinds table above.
3. Profile entries in `profiles/bmad.yaml` and `profiles/vanilla.yaml` for the new kind's `input_sources` or `artifact_locations`.

Custom profiles (teams authoring their own) get the new kind automatically if they inherit from a shipped profile.
