---
name: prd-gap-analyzer
description: >
  Use when a designer wants to check whether a PRD is ready for design work
  to begin. Produces a "design-readiness" verdict (ready / conditional /
  blocked) and, when conditional or blocked, the specific clarifying
  questions to route to PM. Profile-aware — outputs to the active profile's
  declared location. Complementary to John's `bmad-validate-prd` (which
  validates PRD completeness in general); this skill's lens is narrower:
  "can design start?"
  Triggers on: "analyze this PRD", "check the PRD for gaps", "is this PRD
  ready for design?", "PRD gap check", "ready for design?", "review this
  PRD before I start".
---

## Contract

```yaml
reads:
  - kind: ux-design
    required: false
    preferred_when_present: true
    note: "When Sally's UX spec already exists, it answers most design-readiness questions directly."
  - kind: prd
    required: true
    fallback_for: ux-design
writes:
  - kind: ux-readiness
preconditions:
  - "PRD parse succeeds (front-matter optional, body required)"
  - "PRD contains at least a title or feature name AND a problem or objective statement"
postconditions:
  - "Output front-matter lists source artifacts in inputDocuments"
  - "Output includes a design-readiness verdict: ready | conditional | blocked"
  - "Output includes one entry per 'ready for DESIGN' check"
  - "If ledger is enabled in the active profile, workflow-state records this artifact"
```

---

## Overview

Receive a PRD and answer one question: **can design work proceed?** If yes (ready), point the designer at next-recommended skills. If partial (conditional), list the explicit assumptions that will be carried forward so the designer can flag them at the first check-in. If blocked, emit the specific questions to route back to PM.

**This skill has a narrow lens.** It doesn't grade overall PRD quality. It checks whether the PRD gives enough material to run design skills (`user-journey`, `prototype`, `design-qa`) without compensating for missing intent. John's `bmad-validate-prd` (VP) already validates PRD completeness in general — this skill is the design-specific complement.

---

## Inputs

Resolved via the active profile's `input_sources`:

- **`ux-design` (preferred when present)** — Sally's UX spec. When it exists, many design-readiness questions are already answered by her work; this skill reads it and defers to it.
- **`prd` (fallback, required)** — the source PRD. Parsed tolerantly — BMAD's 11-section format, Linear doc, or plain markdown all accepted.

If neither input resolves at the profile's declared paths, ask once:
> "I couldn't find a PRD at the expected path for this profile. Paste the PRD content, provide a file path, or tell me the feature slug so I can locate it."

---

## Gate Check — Minimum Viable PRD

Before the readiness checks, confirm the document has enough to analyze. Minimum:
- A title or feature name
- A problem or objective statement

If neither is present, stop and respond:
> "This document doesn't have the minimum needed to analyze. It needs at least a feature name and a problem or objective statement. Please add those and resubmit."

If only one is present, record it as a Critical check failure (ID CHK-00) and proceed.

---

## The Five "Ready for DESIGN" Checks

Each check produces one entry in the `checks` array of the output. Each entry has: `id`, `name`, `status` (pass / partial / fail), `severity` (for partial or fail), `finding`, and `fix`.

### CHK-01 — Concrete user journeys with named personas

**Pass when:** The PRD (or Sally's UX spec) describes at least one user journey with:
- A named or role-specific persona (e.g., "Josephine — mid-level PSI with 2 years of experience") — not "the user" or "a customer".
- A concrete situation the journey starts from.
- At least 3 stages or decision points in the journey.

**Partial when:** A persona is named but the journey is a list of features rather than a narrative. Or the situation is implied but not stated.

**Fail when:** No persona is identifiable, or the PRD only describes "what the product does" without any user-side narrative.

**Severity default:** fail → critical; partial → moderate.

**Why it matters:** design-framing (JTBD, HMW) and `user-journey` depend on being able to anchor on a specific person in a specific situation. Generic "the user" leads to generic designs.

---

### CHK-02 — Friction points derivable from the PRD

**Pass when:** At least two specific pain points are identifiable — either stated explicitly in the PRD or extractable from the journey narrative / problem statement. Pain points are concrete (e.g., "2-3 hours of manual IRD cross-referencing before each KOM") — not abstract ("the current process is slow").

**Partial when:** One pain point is identifiable, or pain points are abstract.

**Fail when:** The PRD lists features without connecting them to any pain point the user experiences.

**Severity default:** fail → moderate; partial → low.

**Why it matters:** `user-journey` anchors pain points on FP-1/FP-2 markers. HMW statements target friction points. Without specific friction, design reduces to guesswork.

---

### CHK-03 — FR-to-screen mappability

**Pass when:** Every Functional Requirement (FR) in the current scope can be traced to an identifiable screen, component, or flow step. The PRD doesn't need to spell out the UI — but the FR must describe something UI-shaped, not purely backend behavior without user touchpoints.

**Partial when:** More than half the FRs map to screens, but some describe behaviors that'd need UI clarification before implementation.

**Fail when:** FRs are absent, or most FRs describe API contracts / data pipelines with no user-facing manifestation.

**Severity default:** fail → critical; partial → moderate.

**Why it matters:** `prototype` needs a concrete list of user capabilities to wire up. If FRs don't describe user-observable behavior, the prototype becomes speculation.

**Bolt-scoping note:** when the PRD uses Bolt-scoping (BMAD profile), this check applies to the current Bolt's FRs only. FRs explicitly deferred to future Bolts are not counted.

---

### CHK-04 — Specific classification fields (BMAD profile only)

**Pass when:** The PRD front-matter's `classification` block has:
- `projectType` — a real enum value (saas_b2b, internal-tooling, etc.), not "other" or absent.
- `domain` — a specific domain slug (e.g., `hr-payroll-implementation-tech`), not "general".
- `projectContext` — `greenfield` or `brownfield` declared.

**Partial when:** One of the three is generic/missing.

**Fail when:** Classification block is absent entirely (BMAD PRDs should always have it).

**Severity default:** fail → moderate; partial → low.

**N/A when:** active profile is not `bmad` (vanilla-profile PRDs rarely have this block — treat as `status: n/a`).

**Why it matters:** design tone, terminology, density, and convention choices (e.g., spreadsheet-style data density for HR tools vs. whitespace-forward consumer apps) depend on these classifiers.

---

### CHK-05 — Observable success criteria

**Pass when:** Success criteria describe observable user outcomes or behaviors (e.g., "PSI catches bi-weekly payroll escalations before KOM 100% of the time" — observable, countable). At least 3 of the criteria are phrased this way.

**Partial when:** Some criteria are observable, but the PRD mixes them with delivery metrics ("we will build the feature") without distinguishing.

**Fail when:** Success criteria are all delivery-focused ("ship by Q3", "feature launched"). No user-outcome framing.

**Severity default:** fail → critical; partial → moderate.

**Why it matters:** Phase 1 reframes success criteria as UX outcome statements. If the PRD only gives delivery metrics, that reframing becomes invention rather than translation.

---

## Parsing the PRD

The skill must handle BMAD's 11-section shape AND less-structured inputs. Rules:

- **Match headings by regex, not exact string.** E.g., `/^##?\s+Executive Summary/i` matches "## Executive Summary", "# executive summary", "Executive summary:" (with slight tolerance).
- **Read front-matter if present.** Capture `classification`, `stepsCompleted`, `inputDocuments` — use them directly rather than re-inferring.
- **Tolerate section-ordering variation.** BMAD PRDs have a canonical order; other PRDs won't. Match by name, not position.
- **Tolerate missing sections.** A missing "Functional Requirements" heading makes CHK-03 fail, not the whole skill. Continue and fail checks individually.
- **When Sally's UX spec exists (BMAD profile),** read it first. Sally's `key_design_challenges`, `design_opportunities`, and `user_journeys` answer many CHK-01/CHK-02 questions directly — defer to her findings and cite her document in `inputDocuments`.

---

## Verdict logic

| Condition | Verdict |
|---|---|
| All applicable checks pass | `ready` |
| Any check is `fail` with severity `critical` | `blocked` |
| Any check is `fail` (non-critical) OR any `partial` | `conditional` |

Checks marked `n/a` (e.g., CHK-04 under vanilla profile) don't affect the verdict.

---

## Clarifying Questions

For every `fail` or `partial` check that contributed to a non-`ready` verdict, produce 1–2 clarifying questions in the output's `clarifying_questions` array. Requirements:

- **Specific** — tied to the actual check that failed, not generic.
- **Answerable** — PM can respond with a concrete answer.
- **Design-relevant** — focused on what would change design decisions.

Bad: "Can you clarify the success criteria?"
Good: "The PRD lists 'Launch Bolt 1 by Q3' but no user-observable outcome. What user behavior or system state tells us Bolt 1 is working — e.g., 'PSI catches bi-weekly escalations before KOM 100% of the time'?"

Tag each question with `affects: [<artifact kinds>]` — which downstream artifacts depend on the answer.

---

## Assumptions to Carry (for `conditional` verdicts only)

When the verdict is `conditional`, list the explicit assumptions the designer will carry forward if they proceed without waiting for PM response. Each has:
- `assumption` — the concrete statement.
- `rationale` — why this is the reasonable default given current PRD content.
- `revisit_if` — condition under which this assumption should be re-confirmed with PM (e.g., "if the first prototype check-in reveals the persona is wrong").

These become the caveats the designer flags at the Phase 1 check-in.

---

## Output Format

Produce an artifact conforming to [`contracts/ux-readiness.schema.yaml`](../../contracts/ux-readiness.schema.yaml). Write it to the path declared by the active profile's `artifact_locations.ux_readiness`:

```yaml
---
stepsCompleted: [section-scan, check-run, verdict, clarifying-questions]  # when profile style is bmad
inputDocuments:
  - <path to source PRD>
  - <path to Sally's UX spec, if consumed>
producedBy: sprout-design-agent
skill: prd-gap-analyzer
classification:      # copied from source PRD when present (BMAD profile)
  projectType: saas_b2b
  domain: hr-payroll-implementation-tech
  complexity: medium-high
  projectContext: brownfield
editHistory:
  - date: <today>
    changes: initial readiness check
feature: <kebab-case slug>
date: <YYYY-MM-DD>
---

# UX Readiness Check — <feature>

**Verdict:** ready | conditional | blocked

**Summary:** <one-paragraph human summary>

## Checks

| # | Check | Status | Severity | Finding | Fix |
|---|---|---|---|---|---|
| CHK-01 | Concrete user journeys with named personas | pass | — | … | — |
| CHK-02 | Friction points derivable from PRD | partial | moderate | … | … |
| CHK-03 | FR-to-screen mappability | pass | — | … | — |
| CHK-04 | Specific classification fields | pass | — | … | — |
| CHK-05 | Observable success criteria | pass | — | … | — |

## Assumptions to Carry    <!-- only when verdict is conditional -->

- **<assumption text>** — <rationale>. Revisit if: <condition>.

## Clarifying Questions    <!-- only when verdict is conditional or blocked -->

- **[<severity>]** <question> (affects: <comma-separated artifact kinds>)

## Next Recommended

- <skill slug>
- <skill slug>
```

For vanilla-profile outputs, use the minimal front-matter style: `title`, `date`, `inputs` only. The body sections stay the same.

---

## After Producing the Artifact

1. **Call `workflow-state` helper (`init` + `record`)** if the active profile has `workflow_state` declared. Pass:
   - `feature` — the slug
   - `source_prd` — path to the PRD
   - `source_prd_hash` — SHA-256 of the PRD content
   - `source_ux_design` / `source_ux_design_hash` — if Sally's spec was consumed
   - Then `record` with `kind: ux-readiness`, `skill: prd-gap-analyzer`, `path`, `verdict`, `source_hashes`.

2. **Report back to the user:**
   - The output artifact path.
   - The verdict and a one-line rationale.
   - If `ready`: "Next recommended: run `user-journey` or `prd-ux-validator` for enrichment."
   - If `conditional`: "N assumption(s) carried. N clarifying question(s) routed to PM. You can proceed with caveats or wait for answers."
   - If `blocked`: "Design cannot proceed. N critical clarifying question(s) for PM. Route to John (or your PM agent) before re-running."

---

## Behavioral Rules

1. **Never suggest design solutions.** This skill surfaces readiness; it doesn't design.
2. **Never fill gaps.** If success criteria are missing, the skill flags them — it doesn't generate example criteria.
3. **If a section exists but is template boilerplate** ("TBD", "To be defined", "See Jira"), treat it as absent.
4. **Don't hedge the verdict.** Three values only — ready / conditional / blocked. Don't invent "almost ready" or "mostly ready".
5. **When Sally's UX spec is present, cite it.** Many checks pass by virtue of her work. Cite her document in `inputDocuments` and in check findings where she resolved the question.
6. **Bolt scope is respected for CHK-03.** Deferred-Bolt FRs don't count against mappability.
7. **This skill does not gate design.** It informs the designer; the designer decides whether to proceed despite a conditional or blocked verdict.

---

## Anti-Hallucination Rules

1. **Only analyze what's in the document.** No inferring sections from context or domain knowledge. If a section isn't written, it's absent — no matter how obvious its content seems.
2. **Don't infer intent from adjacent content.** A detailed problem statement doesn't imply a scope section exists.
3. **When flagging a partial check, quote the actual text that caused the rating.** Don't paraphrase. Format: `partial — "<actual text from PRD>" — <why this is insufficient>`.
4. **Never fill gaps.** Missing success criteria stay missing. Don't generate example criteria even as illustration.
5. **Never upgrade a rating based on what the PM probably meant.** Vague text is partial even if intent is guessable.
6. **Clarifying questions must be grounded in the specific gap.** No generic PRD questions.
7. **If uncertain whether a check is `pass` or `partial`, default to `partial`.** Err toward surfacing more gaps. A missed gap is more costly than a flagged one the PM considers sufficient.

---

## Related

- [`../../contracts/ux-readiness.schema.yaml`](../../contracts/ux-readiness.schema.yaml) — output schema.
- [`../../contracts/prd.schema.yaml`](../../contracts/prd.schema.yaml) — input schema (shape-tolerant).
- [`../../contracts/ux-design.schema.yaml`](../../contracts/ux-design.schema.yaml) — Sally's UX spec (optional preferred input under BMAD profile).
- [`../workflow-state/SKILL.md`](../workflow-state/SKILL.md) — ledger helper called post-production.
- [`../prd-ux-validator/SKILL.md`](../prd-ux-validator/SKILL.md) — the likely next step when verdict is `conditional`.
