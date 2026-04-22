---
name: prd-ux-validator
description: >
  Optional Mesh Mode skill for teams that want secondary research enrichment
  before prototyping. Validates a PRD against targeted secondary research and
  produces a research brief. Not required in the core spec → prototype → QA →
  handoff pipeline — use when the product space is novel, high-stakes, or the
  product unit lacks sufficient context. Triggers on: "validate the PRD",
  "research against the PRD", "PRD + research brief", "enrich with research",
  "prd-ux-validator".
---

# PRD UX Validator

**Optional research enrichment skill.** Takes a PRD, validates it against targeted secondary research, and produces a research brief the team can use to inform the screen spec or prototype.

> This skill is NOT required in the core workflow (spec → prototype → QA → handoff). Use it when the product unit alone isn't enough context — novel markets, high-stakes UX decisions, or when the PM has flagged open research questions.

**Scenario A** (PRD exists, want research validation) → this skill.
**Scenario B** (no PRD, derive context from scratch) → use `secondary-research` skill instead.

The fundamental difference: `secondary-research` *derives* scope fields from research. This skill *audits* PRD scope against research and flags conflicts. PRD is authoritative for scope; research is authoritative for UX.

---

## Inputs

Ask the user for these if not already provided:
- **PRD** — file path or pasted content (required)
- **gap-report** — file path to a `prd-gap-analyzer` output (optional but recommended). If provided, skip Phase 1 PRD EXTRACT and use the DESIGN CONTEXT BRIEF block from the gap report instead. Map the "Gaps to fill" list directly as the research agenda for Phase 2.
- **depth** — `quick` | `standard` | `deep` (default: `standard`)
- **geography / market** — specific country, region, or market context (required; default to global if explicitly confirmed)

---

## Search Strategy by Depth

| Depth | Searches | Use when |
|-------|----------|----------|
| quick | 3 | Fast scan, PRD is well-researched |
| standard | 6 | Typical validation brief |
| deep | 10 | High-stakes or novel product space |

Run searches one at a time. After each, assess: do you have enough to validate the PRD's assumptions, or does the next search still add value?

**Recency:** Prioritize sources from the last 2 years. Note the year explicitly for older sources.

**Thin results check:** After the first 3 searches, if findings are sparse or too generic, stop and tell the user:
> "Research on this topic returned limited results. Options: (1) narrow the scope, (2) switch to deeper research, or (3) proceed with caveat flagged in Open Questions."

---

## ⚠ Anti-Hallucination Protocol

Same rules as secondary-research. Non-negotiable.

### 1. Source Ledger (do this before writing)
Before drafting the brief, compile a private source ledger:
- List every URL actually retrieved during this session
- Note the title and a one-sentence summary of what it contained
- **Only sources in this ledger may appear as footnotes.** Do not cite a URL you did not retrieve.

### 2. Claim-Source Binding
Every factual claim must be traceable to a ledger source. If you cannot bind a claim to a source:
- Replace it with: `[unverified — flag for primary research]`
- Do not rephrase or infer your way to a citation

### 3. Numeric Stat Quarantine
Never write a percentage, figure, or numeric statistic without the exact source URL inline. If a stat was not returned in search results this session, write: `[stat not retrieved this session — verify before use]`

### 4. Pre-Publish Citation Audit
Before finalizing the Sources section, run this check internally:
> "For each `[^n]` footnote in the brief: was this URL returned in my search results this session? If no → remove the footnote and replace the claim with [unverified]."

### 5. Confidence Flagging

| Marker | When to use |
|--------|-------------|
| `[verified]` | Directly supported by a retrieved source |
| `[inferred]` | Reasonable inference from retrieved sources — not stated directly |
| `[unverified]` | Cannot be bound to a retrieved source — must not drive design decisions |
| `[assumed — gap-filled]` | Content that fills a PRD gap, derived from research patterns or industry convention — not directly cited from a source. Makes every design assumption visible to the designer. |

### 6. "I Don't Know" is Valid
If a section has no retrieved signal, write:
> "No clear signal found — recommend primary research before making design decisions in this area."

---

## Phase 1 — Parse PRD

**If a `gap-report` was provided:** Read its DESIGN CONTEXT BRIEF block and output it verbatim as the PRD EXTRACT — do not re-parse the PRD. Map every item in "Gaps to fill" as a research target for Phase 2. Skip the extraction below.

**If no `gap-report` was provided:** Read the PRD and extract the following. Output a **PRD EXTRACT** block before proceeding to research:

```
PRD EXTRACT
├── User/Personas:       [extracted text | ❌ absent]
├── Problem Statement:   [extracted text | ❌ absent]
├── Functional Scope:    [in-scope items | ❌ absent]
├── Success Criteria:    [extracted text | ❌ absent]
└── NFR/Constraints:     [extracted text | ❌ absent]
```

For each ❌ absent field: note that research must fill this gap. Do not proceed with Phase 2 until the PRD EXTRACT is complete.

---

## Phase 2 — Targeted Research

Run searches anchored to the PRD framing — not starting from scratch. Research validates or challenges what the PRD already specifies.

**Query targets (anchor to PRD context):**
- Competitive landscape validation — do existing products challenge the PRD's assumptions about the market?
- User behavior / friction validation — what do users in this segment actually struggle with?
- UX interaction patterns for this product type — what conventions exist?
- Constraints not mentioned in PRD — regulatory, technical, accessibility gaps

**Research is anchored, not free-form.** The PRD defines the product space; research tests whether that definition holds.

---

## Phase 3 — Produce Research Brief

Output in the same 18-section format as secondary-research (same section numbering, same PM labels). Differences from standard secondary-research output are noted per section.

Use this annotation marker for conflicts between PRD and research:
> `[⚠️ RESEARCH CONFLICT: research suggests X, PRD states Y — PM must resolve before approving]`

```
---
topic: "[topic from PRD]"
mode: prd-validate
date: [YYYY-MM-DD]
depth: [depth]
status: draft
prd_source: [filename or "pasted"]
---

# [Brief Title] — PRD Validation Brief

---

## 1. The Macro Signal
*(PM)*

Lead with the strongest evidence that the problem the PRD addresses is real and large. Anchor to geography if applicable. Include:
- The strongest stat(s) that confirm demand exists
- Any local/regional signal that differentiates this market from the global average
- Why the timing is now (what has changed recently)
- Flag if macro signal is weak or contradicts PRD framing

## 2. Competitive Landscape
*(PM + prototype fallback)*

Key players organized by type (global platforms, local institutional players, adjacent tools).

Format as a table per player category:

| Player | What they're building | Gap they still leave |

After the table, write a **Consistent Structural Gap** paragraph. Flag if the competitive landscape contradicts the PRD's positioning assumptions.

Cite sources inline [^1]. Every product claim must be [verified] or [inferred].

## 3. The Definitional Problem
*(PM)*

**This section evaluates the PRD framing.** Does the PRD's problem statement hold up against what research shows? Ask:
- Is the PRD solving the right problem for the right user?
- Does research confirm the PRD's framing, or suggest a different definitional split?

If research reveals a conflict with the PRD's problem statement: name it explicitly and apply the `[⚠️ RESEARCH CONFLICT]` marker.

If the PRD framing is confirmed: write "PRD framing confirmed — research is consistent with stated problem."

## 4. User Segments
*(PM + prototype)*

For each segment: role, motivation, behavior, emotional state, and key design insight.

Format each as a named sub-section (e.g. **4a. The Anxious Stayer**).

If PRD specifies personas: validate them. Flag any segment that research suggests is missing or mis-characterized.

## 5. Friction Points
*(prototype)*

**Always derived from research** — PRD rarely specifies interaction-level friction points. 2–4 named friction points at interaction level.

Format each as:
**FP-[n]: [Name]** — [what the user is trying to do, what breaks, what they feel]

If research has no signal on friction: write "No friction signal found — flag in user testing."

## 6. User Research Hypotheses
*(PM)*

Generate 3–5 testable hypotheses that must be resolved before confident product decisions. For each:
- **H[n] — [Name]** *(priority note)*
- Write the hypothesis as a falsifiable claim in italics
- State: "If confirmed → [product/design implication]. If false → [alternative direction]."

## 7. Patterns & Conventions
*(PM + prototype)*

What users already expect based on existing solutions. Include:
- Conventions that work and should be followed
- **Problematic conventions to avoid**

Every pattern claim must be bound to a source or marked [unverified].

## 8. Whitespace & Opportunities
*(PM)*

Gaps, underserved needs, differentiation space relative to the PRD's stated positioning. Rank by:
1. **Primary whitespace** — the core confirmed gap no one is filling
2. **Secondary whitespace** — adjacent gaps
3. **Tailwinds** — structural forces increasing urgency

## 9. Constraints
*(PM + prototype)*

Guardrails the prototype agent must design within. Include any that are relevant:
- **Regulatory** — compliance requirements surfaced in research
- **Technical** — platform limitations, API dependencies, offline/connectivity constraints
- **Accessibility** — standards or user population needs affecting interaction design
- **Learner / User** — attention, device, prior knowledge, motivation, literacy constraints
- **Market** — sales cycle, content shelf life, credentialing trust constraints

**Merge with PRD NFRs.** Flag any constraint research found that the PRD did not mention.

If no constraints found: "No constraints surfaced — recommend flagging with engineering before prototype handoff."

## 10. Product Concept — Leanest Version
*(PM + prototype)*

**References the PRD's stated scope as the anchor concept.** Propose the minimum viable product concept that tests the core value proposition from the PRD.

Include:
- The core mechanic (what does the user actually do — per PRD)
- Entry point / first interaction
- What the MVP explicitly does NOT include (per PRD In-Scope/Out-of-Scope if present)
- **MVP test:** what metric or behavior would validate the concept

Flag with `[⚠️ RESEARCH CONFLICT]` if research suggests a different minimum concept than the PRD.

## 11. User Flow / Screen Map
*(prototype)*

**Derived from PRD Functional Scope (In Scope list).** An ordered list of screens the prototype should include.

For each screen, provide:
- **Name** — what to call the screen
- **Purpose** — one-line description
- **Primary action** — the one thing the user does on this screen
- **Transition** — what screen follows

Format as a numbered list. Flag screens where research suggests a different flow:
> `[⚠️ RESEARCH CONFLICT: research suggests X screen before Y — PRD does not include this step]`

## 12. The Critical Strategic Question
*(PM)*

Name the single most important unresolved strategic question that will change the entire product. State what decision must be made before building.

## 13. Risks
*(PM)*

Name 3–5 risks directly — specific, evidence-grounded risks for this opportunity.

Format each as:
**Risk [n] — [Name]:** [One paragraph. State what the risk is, what evidence supports it, and what it means for the product timeline or design.]

## 14. Design Implications
*(prototype)*

5 UX-specific, directional takeaways for the prototype agent. Each must:
- Name the **specific screen or component** it applies to
- State the **interaction pattern** to use — not the business rationale
- Reference the friction point it resolves (FP-n)
- Be traceable to at least one source in the ledger (cite inline)

Format: `**DI-[n]: [Screen/Component] — [Imperative]** — [One sentence on the interaction pattern]. Resolves FP-[n]. [^citation]`

Every DI must resolve at least one named FP from section 5.

## 15. Prototype Agent Input Block
*(prototype)*

**Scenario A fill rules apply.** The PRD is authoritative for scope fields; research is authoritative for UX fields.

> **Format authority:** Before generating this block, verify field names against `skills/prototype-agent/SKILL.md` Phase 1 RESEARCH SUMMARY block. That block is the canonical definition. Do not rename or reorder fields.

```
PROTOTYPE AGENT INPUT
├── User: [from PRD Personas — flag if research identifies a different primary segment]
├── Core need: [from PRD Problem Statement — flag if research reframes it]
├── Primary friction: [from FP-1 and FP-2 in research §5 — PRD source if research unavailable]
├── Decision trigger: [from PRD User Stories if present, else from research]
├── Success state: [from PRD Success Criteria if present, else derived from research]
├── Key constraints: [merged: PRD NFRs + research §9 constraints]
├── Screen map: [from PRD Functional Scope — flag if research suggests different flow]
└── Gap-fill confidence: [high | medium | low] — [one sentence: what remains unverified or assumed]
```

**Gap-fill confidence levels:**
- `high` — all gaps resolved by research with verified sources; no material assumptions
- `medium` — most gaps resolved; ≤2 `[assumed — gap-filled]` items remain
- `low` — significant gaps remain unverified; designer should align with PM before committing to screens

## 16. Pressure-Test Verdict
*(PM)*

One final paragraph synthesizing the brief into a direct assessment:
- Does the research confirm or challenge the PRD's opportunity?
- What is the viable version of the product — narrowed or adjusted from PRD framing?
- What is the primary risk that determines whether it works?
- What must happen first?

This is not a summary. It is an opinion grounded in the research. Be direct. If the PRD has significant unresolved conflicts with research findings, state that clearly.

## 17. Open Questions
*(PM + prototype)*

What still needs validation before key design decisions can be made? Explicitly list any `[⚠️ RESEARCH CONFLICT]` items that require PM resolution before the brief can be approved.

Include a line if applicable: "Source coverage was limited — recommend deeper primary research before prototype decisions."

## 18. Sources

List only URLs actually retrieved this session. Format:
[^1]: URL — title (year if available)
[^2]: URL — title (year if available)

List all additional retrieved URLs after the footnoted sources, even if not directly cited.
Minimum 5 sources. If fewer were retrieved, add to Open Questions:
"Only [n] sources retrieved — brief has limited coverage. Expand research depth before handoff."
```

---

## File Saving

After producing the brief:

1. Generate the filename: `YYYY-MM-DD_prd-validate_[topic-slug].md`
   - topic-slug = lowercase, spaces → hyphens, remove special characters
   - Example: `2026-03-17_prd-validate_mobile-expense-tracker-ph.md`

2. Save to: `skills/secondary-research/outputs/[filename]`
   - Same folder as secondary-research outputs — prototype-agent can find it without path changes

3. Tell the user:
   - The file path
   - Number of `[⚠️ RESEARCH CONFLICT]` markers requiring PM resolution
   - To resolve all conflicts, then change `status: draft` → `status: approved`
   - That the approved brief is ready for the prototype agent
   - How many `[unverified]` markers appear in the brief (if any)

---

## Hard Constraints

- Always cite sources inline with `[^n]` footnotes
- Never fabricate or infer a URL — only cite retrieved sources
- Never include a numeric statistic without a bound source from this session
- Minimum 5 unique sources per brief — flag shortfalls in Open Questions
- **No word count cap** — be comprehensive. Shallow briefs are not useful.
- If a section has no findings, write "No clear signal found — recommend primary research"
- The PRD EXTRACT block must be output before research begins
- §15 field names must match `skills/prototype-agent/SKILL.md` Phase 1 RESEARCH SUMMARY exactly — verify before writing
- Every `[⚠️ RESEARCH CONFLICT]` marker is a blocker — PM must resolve all before approving
- Design Implications must name a specific screen/component and reference an FP
- Every DI must resolve at least one named FP from the Friction Points section
- Constraints section is required — never omit it, even if empty
- Every `[^n]` footnote must pass the pre-publish citation audit before the brief is saved
- The Pressure-Test Verdict must take a position — hedged non-conclusions are not acceptable