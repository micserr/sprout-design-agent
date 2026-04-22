---
title: Sprout Core + Profiles — Skill-Native Design Agent for Any SDLC
date: 2026-04-17
status: draft — awaiting user review (revised twice: once after repo scan, once for profile architecture)
classification:
  projectType: internal-tooling
  domain: ai-agent-architecture
  complexity: medium-high
---

# Sprout Core + Profiles — Skill-Native Design Agent for Any SDLC

## Context

Sprout today is a linear Phase 0–6 orchestrator that assumes one agent, one session, end-to-end. Two things are changing at once:

1. The user runs a **multi-agent BMAD pipeline** (`Sprout-Solutions-Ph/implem-aidlc`) where Sprout is already installed as `_bmad/custom-agents/sprout-design-agent/` alongside Sally (UX), John (PM), Winston (Architect), and others. They want to invoke skills individually, not always the full workflow.
2. **Other teams don't use BMAD.** Some use Linear, some use Notion, some have no framework at all. Sprout needs to work for them too — with the same design rigor but without forcing BMAD conventions on them.

These two constraints together force an architecture that separates **universal design work** from **framework-specific packaging**.

### Design principle

**Skill logic is universal. Artifact packaging is profile-specific.** A screen spec is a screen spec whether the output lands at `_bmad-output/planning-artifacts/ux/ux-screen-spec-policy-prep-tool.md` or `docs/design/screen-spec-checkout-flow.md`. The skill doesn't care — the profile tells it where to write and in what front-matter shape.

### Anchor decisions (all confirmed)

| Fork | Decision |
|---|---|
| Communication model | File handoffs in a shared repo |
| Invocation unit | Individual skills |
| PM agent | John (BMAD) exists — match BMAD conventions in the BMAD profile |
| Output location | Profile-declared (BMAD profile = `planning-artifacts/ux/`; vanilla profile = `docs/design/`) |
| `prd-gap-analyzer` scope | Keep it, narrow lens to "ready for DESIGN" |
| First slice | Contracts + Profiles layer + `prd-gap-analyzer` retrofit end-to-end |
| Sally coexistence | Profile-declared; BMAD profile reads Sally's UX spec when present, falls back to PRD |
| Prototype split | Profile-declared; BMAD profile: code in `../implem-prototype/`, manifest in `ux/prototype/`. Vanilla profile: everything in `prototype/` next to code |
| Portability | Profiles-first — ship BMAD + Vanilla profiles together in the first PR |

---

## Target Architecture (6 layers)

### 1. Sprout Core — framework-neutral skill logic

The skills themselves. Every skill does the same work regardless of profile: parse input, produce structured output, enforce quality gates. What changes per profile: where output lands, what front-matter shape it has, what inputs it prefers.

### 2. `contracts/` — YAML schemas (universal)

Schemas describe the *body* of each artifact type — the data inside, not where it lives. They're profile-neutral.

| Schema | Artifact body |
|---|---|
| `contracts/prd.schema.yaml` | Inbound PRD (shape-tolerant: BMAD's 11-section format, Linear doc, Notion export, plain markdown) |
| `contracts/ux-design.schema.yaml` | Sally's UX spec (BMAD-specific; optional input for non-BMAD profiles) |
| `contracts/ux-screen-spec.schema.yaml` | Screen inventory, actors, states, flow, open design decisions |
| `contracts/ux-journey.schema.yaml` | Journey map + flow diagram + pain points (optional) |
| `contracts/prototype-manifest.schema.yaml` | Screens, routes, components, stack header |
| `contracts/ux-qa.schema.yaml` | Findings table + handoff status |
| `contracts/ui-feedback.schema.yaml` | UI feedback triage record |
| `contracts/ux-handoff.schema.yaml` | Dev-ready manifest |
| `contracts/ux-audit.schema.yaml` | Cross-artifact coherence report |
| `contracts/workflow-state.schema.yaml` | Ledger shape |
| `contracts/profile.schema.yaml` | The profile file itself |

### 3. `profiles/` — SDLC-specific packaging

Every team installs with a profile. The profile tells skills:

- Where to write each artifact kind (path templates)
- What front-matter shape to use
- Where to find inputs (PRD, optional sibling artifacts)
- Which other agents exist and what they produce
- Where prototype code lives (same repo vs. sibling)
- Naming conventions

**Shipped profiles (first slice):**

- `profiles/bmad.yaml` — `Sprout-Solutions-Ph/implem-aidlc`-style. Full mesh with Sally/John/Winston coexistence, `_bmad-output/planning-artifacts/ux/`, BMAD front-matter, sibling-repo prototype, feature-scoped ledger.
- `profiles/vanilla.yaml` — No framework assumptions. Artifacts in `docs/design/`, prototype in `prototype/` next to code, minimal front-matter (`title`, `date`, `inputs`), no coexistence, no ledger (opt-in).

**Future profiles (teams author their own):**

- `profiles/linear.yaml` — Linear ticket → design doc per ticket, Linear-style frontmatter.
- `profiles/notion.yaml` — Notion page as input, output as Notion-compatible markdown.
- `profiles/shape-up.yaml` — Shape Up pitch → design cycle artifact.

**Profile selection order:**

1. `$REPO/.sprout/profile.yaml` (per-repo override, highest priority)
2. `$REPO/sprout-profile.yaml` (alternate repo-level path)
3. `~/.claude/sprout-profile.yaml` (user default, set at install)
4. `profiles/vanilla.yaml` (fallback — always works)

Install adapters (`claude.sh`, `bmad.sh`, etc.) write the chosen profile path to the user-level default.

**Profile schema (`contracts/profile.schema.yaml`) — example:**

```yaml
profile: bmad                                    # identifier
display_name: BMAD (implem-aidlc)
description: Full BMAD mesh with Sally, John, Winston coexistence

artifact_locations:
  ux_screen_spec: "_bmad-output/planning-artifacts/ux/ux-screen-spec-{feature}.md"
  prototype_manifest: "_bmad-output/planning-artifacts/ux/prototype/prototype-manifest-{feature}.md"
  ux_qa: "_bmad-output/planning-artifacts/ux/ux-qa-{feature}-{date}.md"
  ui_feedback: "_bmad-output/planning-artifacts/ux/ui-feedback-{feature}-{date}.md"
  ux_handoff: "_bmad-output/planning-artifacts/ux/ux-handoff-{feature}.md"
  ux_audit: "_bmad-output/planning-artifacts/ux/ux-audit-{feature}-{date}.md"
  workflow_state: "_bmad-output/state/ux-workflow-{feature}.yaml"

input_sources:
  - kind: prd
    path_pattern: "_bmad-output/planning-artifacts/prd/prd-{feature}.md"
    schema: contracts/prd.schema.yaml
    required: true
  - kind: ux_design
    path_pattern: "_bmad-output/planning-artifacts/ux/ux-design-{feature}.md"
    schema: contracts/ux-design.schema.yaml
    required: false
    preferred_when_present: true

front_matter:
  required_fields: [stepsCompleted, inputDocuments, producedBy, skill, classification, editHistory]
  carry_forward_from_prd: [classification]
  style: bmad

coexistence_agents:
  - name: John
    role: Product Manager
    produces: [prd]
  - name: Sally
    role: UX Designer
    produces: [ux_design]
  - name: Winston
    role: Architect
    consumes: [ux_handoff]

prototype:
  code_target: "../implem-prototype/"
  manifest_in_planning: true

naming:
  feature_slug: "{feature}"
  date_format: "YYYY-MM-DD"
  case: kebab-case
```

The vanilla profile is the same schema with much simpler values (artifact_locations under `docs/design/`, no coexistence, code target `prototype/`, minimal front-matter).

### 4. Skill-level `Contract:` block — profile-aware

Every `skills/*/SKILL.md` gains a Contract block that references profile variables instead of hardcoded paths:

```yaml
contract:
  reads:
    - kind: ux_design                              # resolved via profile.input_sources
      required: false
      preferred_when_present: true
    - kind: prd
      required: true
      fallback_for: ux_design
  writes:
    - kind: ux_screen_spec                         # resolved via profile.artifact_locations
      schema: contracts/ux-screen-spec.schema.yaml
  preconditions:
    - "At least one input document parses successfully"
    - "Input contains at least a feature name AND a problem or objective statement"
  postconditions:
    - "Output front-matter lists source artifacts in inputDocuments"
    - "Output includes at least one actor and one screen with states"
    - "Profile's workflow_state ledger updated (if ledger is enabled for this profile)"
```

The skill never writes a literal path. It writes to the profile-resolved `kind: ux_screen_spec` location. Swap profile → same skill writes elsewhere.

### 5. Workflow state ledger (profile-declared)

If the profile declares `artifact_locations.workflow_state`, skills maintain a ledger there. If the profile omits it, skills skip ledger maintenance (vanilla-profile teams get a simpler, stateless experience).

BMAD profile's ledger (`_bmad-output/state/ux-workflow-{feature}.yaml`):

```yaml
feature: policy-prep-tool
bolt: 1
source_prd: _bmad-output/planning-artifacts/prd/prd-policy-prep-tool.md
source_prd_hash: <sha256>
source_ux_design: _bmad-output/planning-artifacts/ux/ux-design-policy-prep-tool.md
source_ux_design_hash: <sha256>
artifacts:
  - kind: ux_screen_spec
    skill: product-design
    path: _bmad-output/planning-artifacts/ux/ux-screen-spec-policy-prep-tool.md
    produced: 2026-04-17
next_recommended: [prototype]
blocked: []
drift: []
```

Hash fields detect when upstream artifacts change after a downstream skill ran.

### 6. `skills/design-audit/` — meta-skill for coherence (profile-aware)

Cross-checks artifacts for coherence. Universally useful, profile-respecting:

- **FR coverage:** every FR from the current PRD (or Bolt) is implemented in the prototype manifest.
- **Journey ↔ HMW:** every HMW maps to a journey step.
- **Scope respected:** no deferred-Bolt screens in the prototype (BMAD-specific; vanilla profile skips).
- **QA criticals:** unfixed Critical findings block handoff.
- **Drift:** source hashes match (ledger-enabled profiles only).
- **Coexistence coherence:** if profile declares a partner agent (e.g., Sally), check their artifact is consistent with prototype.

Output: `ux_audit` kind — path resolved via profile.

---

## Human-as-Orchestrator Flow — Profile-Switchable

### BMAD profile example (Policy Prep Tool, real feature)

1. John's PRD already at `planning-artifacts/prd/prd-policy-prep-tool.md`.
2. Designer invokes `bmad-sprout-prd-gap-analyzer`. Skill reads `~/.claude/sprout-profile.yaml` → bmad. Writes to `planning-artifacts/ux/ux-screen-spec-policy-prep-tool.md`. Updates `_bmad-output/state/ux-workflow-policy-prep-tool.yaml`.
3. Sally runs `bmad-create-ux-design` → `ux-design-policy-prep-tool.md`.
4. Designer invokes `bmad-sprout-user-journey`. Skill sees Sally's UX spec (profile's `preferred_when_present`), reads it, writes `ux-journey-policy-prep-tool.md`.
5. Designer invokes `bmad-sprout-prototype`. Code written to `../implem-prototype/`; manifest at `planning-artifacts/ux/prototype/prototype-manifest-policy-prep-tool.md`.
6. `design-audit` runs, cross-checks coherence, flags drift if John has edited the PRD since step 2.
7. Handoff manifest produced. Winston picks it up.

### Vanilla profile example (non-BMAD team, any repo)

1. User has a `product-spec.md` file (wherever — Notion export, pasted content, requirements doc).
2. User says "run prd-gap-analyzer on product-spec.md". Skill reads `~/.claude/sprout-profile.yaml` → vanilla. Accepts the explicit file path. Writes to `docs/design/readiness-checkout-flow.md` with minimal front-matter (`title`, `date`, `inputs`).
3. User runs `user-journey`. Writes to `docs/design/journey-checkout-flow.md`. No Sally, no coexistence.
4. User runs `prototype`. Writes code to `prototype/` in the same repo. Manifest at `prototype/manifest.md`.
5. User runs `design-qa`, `design-feedback`, etc. — all same skills, writing under `docs/design/` with short names.
6. No ledger, no drift detection, no Bolt-scoping (vanilla profile doesn't declare those). Skills still produce full-quality design work.

Same skills. Same rigor. Different outputs.

---

## First Slice — What I'll Build Now

### 1. Write all contract schemas
- `contracts/prd.schema.yaml` (shape-tolerant)
- `contracts/ux-design.schema.yaml` (BMAD-specific; referenced only by BMAD profile)
- `contracts/ux-screen-spec.schema.yaml`, `ux-journey.schema.yaml`, `prototype-manifest.schema.yaml`, `ux-qa.schema.yaml`, `ui-feedback.schema.yaml`, `ux-handoff.schema.yaml`, `ux-audit.schema.yaml`
- `contracts/workflow-state.schema.yaml`
- `contracts/profile.schema.yaml`
- `contracts/README.md` — schema system overview

### 2. Ship both initial profiles
- `profiles/bmad.yaml` — full implem-aidlc spec (what the earlier draft documented)
- `profiles/vanilla.yaml` — minimal `docs/design/` defaults
- `profiles/README.md` — how to author a custom profile; how profile resolution works

### 3. Workflow-state helper skill
- `skills/workflow-state/SKILL.md` — reads/writes ledger; used by other skills; no-op on profiles without ledger
- `skills/workflow-state/format.md` — ledger format reference

### 4. Fully retrofit `prd-gap-analyzer`
- Add profile-aware `Contract:` block
- Rewrite body to: (a) resolve active profile, (b) read PRD (profile input), (c) optionally read `ux_design` input if profile declares it and file exists, (d) run "ready for DESIGN" checks, (e) write output to profile-resolved path with profile-appropriate front-matter, (f) call workflow-state helper if ledger enabled

**"Ready for DESIGN" checks (the narrowed lens):**
- User Journeys are concrete with named personas and specific situations
- Friction points derivable from PRD narrative or Success Criteria
- Every current-scope FR maps to an identifiable screen or component
- `classification.domain` and `projectContext` specific enough to drive design tone (BMAD profile only — other profiles skip if fields absent)
- Success Criteria include observable user outcomes, not just delivery metrics

Output verdicts: `ready` / `conditional` / `blocked`.

### 5. Update install adapters
- `adapters/claude.sh` — ask user which profile at install; write to `~/.claude/sprout-profile.yaml`
- `adapters/bmad.sh` — auto-select BMAD profile (it's a BMAD install by definition); write profile to `_bmad/sprout-profile.yaml`
- `adapters/codex.sh`, `adapters/cursor.sh` — ask at install, default to vanilla

### 6. Update product-design agent (`agents/product-design.md`)
- Add "Mesh Mode" section — skills are independently callable
- Agent reads active profile at session start, announces which one
- Offers next-best action from ledger (if ledger enabled)
- Preserves linear Phase 0–6 as default for fresh sessions

### 7. Docs
- `README.md` — update with profiles architecture, human-as-orchestrator framing
- `docs/profiles-guide.md` — how profiles work, how to author one, resolution order
- `CHANGELOG.md` `[Unreleased]`

### Out of scope for this first slice

- Retrofitting the other 9 skills with Contract blocks (follow-on PRs, one per skill)
- Building the full `skills/design-audit/` (just the profile/contract slot; behavior in later PR)
- Drift-detection logic beyond hash storage in the ledger
- Additional profiles (linear, notion, shape-up) — teams author their own
- A PR against `implem-aidlc` — draft included in spec for user to submit separately

---

## Files to Create (first slice)

**Contracts:**
- `contracts/README.md`
- `contracts/profile.schema.yaml`
- `contracts/prd.schema.yaml`, `ux-design.schema.yaml`, `ux-screen-spec.schema.yaml`, `ux-journey.schema.yaml`, `prototype-manifest.schema.yaml`, `ux-qa.schema.yaml`, `ui-feedback.schema.yaml`, `ux-handoff.schema.yaml`, `ux-audit.schema.yaml`, `workflow-state.schema.yaml`

**Profiles:**
- `profiles/README.md`
- `profiles/bmad.yaml`
- `profiles/vanilla.yaml`

**Skills:**
- `skills/workflow-state/SKILL.md`
- `skills/workflow-state/format.md`

**Docs:**
- `docs/profiles-guide.md`

## Files to Modify (first slice)

- `skills/prd-gap-analyzer/SKILL.md` — full profile-aware retrofit
- `agents/product-design.md` — Mesh Mode section
- `README.md` — profiles architecture
- `CHANGELOG.md` — `[Unreleased]`
- `adapters/claude.sh`, `bmad.sh`, `codex.sh`, `cursor.sh` — profile selection at install + `workflow-state` registration

---

## Verification

1. **Schema validity:** every `contracts/*.schema.yaml` parses as valid YAML.
2. **Profile validity:** `profiles/bmad.yaml` and `profiles/vanilla.yaml` both validate against `contracts/profile.schema.yaml`.
3. **BMAD dry run (real):** against the real `Sprout-Solutions-Ph/implem-aidlc` Policy Prep Tool PRD. Invoke `prd-gap-analyzer`. Expected output at `_bmad-output/planning-artifacts/ux/ux-screen-spec-policy-prep-tool.md` with BMAD front-matter, ledger updated at `_bmad-output/state/ux-workflow-policy-prep-tool.yaml`.
4. **Vanilla dry run:** set vanilla profile, point skill at a simple `product-spec.md` in a bare repo. Expected output at `docs/design/readiness-{feature}.md` with minimal front-matter, no ledger.
5. **Precondition failure:** stub PRD missing FR section. Skill refuses, names failed precondition.
6. **Postcondition failure:** force-write malformed output. Postcondition catches before ledger update.
7. **Sally-present path (BMAD):** with Sally's UX spec in place, skill reads it as preferred input and lists it in `inputDocuments`.
8. **Profile resolution order:** verify repo-level override beats user-level default beats vanilla fallback.
9. **Legacy agent works:** linear Phase 0 flow still completes end-to-end using retrofitted skill under whichever profile is active.

---

## Non-Goals (explicit)

- **Not building an MCP server.** File handoffs are sufficient.
- **Not replacing Sally.** She remains BMAD-native; Sprout complements her under the BMAD profile.
- **Not replacing the linear `product-design.md` agent.** Mesh mode is additive.
- **Not mandating a single SDLC company-wide.** Sprout's job is design rigor under whatever process each team runs. Profiles make that possible.
- **Not shipping every profile out of the box.** Teams author their own — `profiles/README.md` explains how.
- **Not modifying `implem-aidlc` directly in this PR.** A companion draft for `pipeline-standard.md` is included below.
- **Not migrating existing real artifacts.** New artifacts use new names; old ones stay.
- **Not automating agent-to-agent invocation.** Human is the dispatcher.

---

## Companion Proposal — `implem-aidlc` pipeline-standard update

Draft (for the user to submit as a PR against `Sprout-Solutions-Ph/implem-aidlc`):

Add to `docs/pipeline-standard.md` § 3 "Design & Prototyping":

```markdown
| Input | Output | Output Location |
|-------|--------|-----------------|
| Product Outcome + Product Unit | Screen Spec | `planning-artifacts/ux/ux-screen-spec-{feature}.md` |
| Screen Spec | Prototype Manifest | `planning-artifacts/ux/prototype/prototype-manifest-{feature}.md` |
| Prototype Manifest | UX QA Report | `planning-artifacts/ux/ux-qa-{feature}-{date}.md` |
| Prototype + UI Feedback | UI Feedback Triage | `planning-artifacts/ux/ui-feedback-{feature}-{date}.md` |
| All UX artifacts | UX Handoff Manifest | `planning-artifacts/ux/ux-handoff-{feature}.md` |
| All UX artifacts | UX Coherence Audit (on-demand) | `planning-artifacts/ux/ux-audit-{feature}-{date}.md` |
```

This formalizes Sprout's outputs in the BMAD pipeline standard. Teams using other profiles get the same artifact kinds at their profile's paths.

---

## Open Questions (flagged for later)

1. **Profile authoring UX** — should we ship a `skills/profile-builder/` that interviews a team about their conventions and produces a custom profile YAML? *Recommendation: yes, but follow-on PR.*
2. **Multi-profile repos** — what if a single repo hosts multiple features with different profiles (unusual but possible)? *Recommendation: allow `.sprout/profile.yaml` at subdirectory level; resolve nearest-parent at invocation.*
3. **Profile inheritance** — can a custom profile extend `bmad.yaml` and override just a few fields? *Recommendation: yes, via `extends: bmad` — implement in a later PR when the need arises.*
4. **How tolerant should the PRD schema be?** *Recommendation: very — match sections by heading regex, not exact string. A PRD that's less structured than BMAD's should still produce a usable readiness verdict.*
