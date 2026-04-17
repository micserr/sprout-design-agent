# Profiles Guide

How Sprout skills adapt to different SDLC frameworks (BMAD, Linear, Notion, vanilla, or anything custom) without rewriting any skill logic.

---

## The problem profiles solve

Sprout skills do universal work: check a PRD for design-readiness, map a journey, build a prototype, run QA, apply feedback. But **where** those outputs land and **what shape** of front-matter they carry is framework-specific. A BMAD team expects artifacts in `_bmad-output/planning-artifacts/ux/` with `stepsCompleted` and `classification` front-matter. A Linear team expects artifacts organized by ticket. A team with no framework wants a single `docs/design/` folder and minimal metadata.

Without profiles, every skill would hardcode one team's conventions. Profiles let the same skill serve all teams.

---

## How it works

Every Sprout skill has a `Contract:` block that references artifact **kinds**, not paths:

```yaml
contract:
  reads:
    - kind: prd
      required: true
    - kind: ux-design
      required: false
      preferred_when_present: true
  writes:
    - kind: ux-readiness
```

At invocation, Sprout:

1. Resolves the **active profile** (see resolution order below).
2. Looks up each kind in the profile's `input_sources` or `artifact_locations` to get a path.
3. Passes those resolved paths to the skill.

Same skill + different profile = different paths, different front-matter, different coexistence behavior.

---

## Profile resolution order

Checked in order, first match wins:

1. **`$REPO/.sprout/profile.yaml`** — repo override. Checked in. Team-specific.
2. **`$REPO/sprout-profile.yaml`** — repo alternate. Some teams prefer this location.
3. **`~/.claude/sprout-profile.yaml`** — user-level default. Written by install adapter.
4. **`profiles/vanilla.yaml`** — fallback. Always works.

A BMAD team typically sets repo-level override to `extends: bmad`. A team not using any framework leaves everything at default — the vanilla profile kicks in.

---

## What a profile declares

See `contracts/profile.schema.yaml` for the authoritative schema. The top-level sections:

### `artifact_locations`

Path template for each artifact kind the profile produces. Placeholders:
- `{feature}` — kebab-case feature slug.
- `{date}` — ISO date (YYYY-MM-DD) at write time.

Example (BMAD profile):
```yaml
artifact_locations:
  ux_readiness:  "_bmad-output/planning-artifacts/ux/ux-readiness-{feature}.md"
  ux_qa:         "_bmad-output/planning-artifacts/ux/ux-qa-{feature}-{date}.md"
```

### `input_sources`

Where to find expected input artifacts. Each entry specifies a `kind` (matching a schema in `contracts/`), a `path_pattern` (or `null` if the input is inline), `required`, and optionally `preferred_when_present` (for coexistence fallback patterns).

### `front_matter`

Style and required fields for output artifacts:

- `style: bmad` — full BMAD front-matter (`stepsCompleted`, `inputDocuments`, `classification`, `editHistory`).
- `style: minimal` — `title`, `date`, `inputs` only.
- `style: custom` — defined by `required_fields` array.

### `coexistence_agents`

Other agents producing artifacts Sprout may read. Under BMAD, this includes Sally (UX Designer) and John (PM). The profile declaration is how skills learn to **prefer Sally's UX spec over the PRD** — it's driven entirely by profile, not skill logic.

### `prototype.code_target`

Where `prototype` skill writes Vue/React code. In BMAD, a sibling repo (`../implem-prototype/`). In vanilla, in-repo (`prototype/`). The manifest lives separately at `artifact_locations.prototype_manifest`.

### `naming`

Case, date format, and how `{feature}` is derived (from PRD filename, front-matter, user input, or ticket ID).

---

## Authoring a custom profile

### Option A: extend a shipped profile

Most teams only need to override a few fields. Use `extends:`:

```yaml
# profiles/linear.yaml (or .sprout/profile.yaml in a repo)
profile: linear
display_name: "Linear (ticket-per-design)"
extends: vanilla

artifact_locations:
  ux_readiness:  "design-docs/{feature}/readiness.md"
  ux_qa:         "design-docs/{feature}/qa-{date}.md"
  # everything else inherits from vanilla

coexistence_agents:
  - name: PM-bot
    role: Product Manager via Linear
    produces: [prd]

naming:
  feature_source: ticket-id    # e.g., HR-380 from Linear
```

Save as `profiles/<name>.yaml` to contribute upstream, or as `$REPO/.sprout/profile.yaml` to keep team-private.

### Option B: full profile

When your SDLC is different enough that `extends` doesn't help, author a full profile without `extends`. The schema at `contracts/profile.schema.yaml` is authoritative — any valid profile is one that passes schema validation. Start from `profiles/bmad.yaml` or `profiles/vanilla.yaml` as a template.

---

## Common patterns

### Per-ticket artifacts (Linear, Jira)

```yaml
artifact_locations:
  ux_readiness:  "design/{ticket}/readiness.md"
  ux_journey:    "design/{ticket}/journey.md"

naming:
  feature_source: ticket-id
```

### Per-epic organization

```yaml
artifact_locations:
  ux_readiness:  "docs/design/epics/{epic}/{feature}/readiness.md"

naming:
  feature_source: user-input    # ask for both epic and feature slugs at invocation
```

### No coexistence (solo workflow)

```yaml
coexistence_agents: []

input_sources:
  - kind: prd
    path_pattern: null           # no fixed location
    required: false
    accepts_inline: true         # user pastes PRD content at invocation
```

### Inline-first input (no PRD document)

Some teams don't produce formal PRDs — product intent comes through conversation or a single paragraph. Vanilla profile already supports this via `accepts_inline: true` on the PRD input source. Skills that need a PRD will accept pasted content at the prompt.

---

## What NOT to put in a profile

Profiles are about packaging, not about modifying skill behavior. If you find yourself wanting to change what a skill checks or produces (the body, not the location), that's not a profile concern — that's either a fork of the skill or a contribution to the core.

Specifically, profiles should **not**:

- Change the content of a skill's output (what questions it asks, what it reports).
- Change the skill's preconditions or postconditions.
- Add or remove checks (e.g., design-readiness checks).
- Alter the skill's anti-hallucination rules.

Profiles decide **where** artifacts live and **what shape** of metadata wraps them. Everything else stays in the skill.

---

## Debugging profile resolution

If a skill writes to an unexpected location, verify which profile resolved:

1. Check for `$REPO/.sprout/profile.yaml` (repo override — highest priority).
2. Check for `$REPO/sprout-profile.yaml` (repo alternate).
3. Check for `~/.claude/sprout-profile.yaml` (user default).
4. If none of the above, vanilla is active.

The active profile file should contain either a full profile or an `extends: <name>` pointer to a shipped profile.

---

## Relationship to install adapters

Install adapters write the user-level default profile file:

| Adapter | Profile behavior |
|---|---|
| `adapters/claude.sh` | Asks at install: `1) bmad` or `2) vanilla`. Writes `~/.claude/sprout-profile.yaml` with `extends: <chosen>`. |
| `adapters/bmad.sh` | Auto-selects `bmad` (it's a BMAD install). Writes `_bmad/product-design/sprout-profile.yaml`. |
| `adapters/codex.sh`, `adapters/cursor.sh` | Default to vanilla; users override in-repo if they want bmad. |

Adapters never force a profile — they only set a reasonable default that a `$REPO/.sprout/profile.yaml` can always override.
