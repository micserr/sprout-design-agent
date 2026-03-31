---
name: prd-gap-analyzer
description: Use when a designer or PM wants to validate a PRD before design work begins. Triggers on: "analyze this PRD", "check the PRD for gaps", "review this brief before I start", "is this PRD ready for design?", "PRD gap check", "validate the requirements".
---

# PRD Gap Analyzer

Receive a PRD and produce a structured gap report before design work begins. The goal is to surface missing, ambiguous, or under-specified content that would force compensatory work during the design phase.

This is a Skill, not an Agent. It follows a fixed pattern: input PRD → output gap report. No dynamic decisions about what to do next.

---

## Input

A PRD in any of the following forms:
- Pasted text directly in the conversation
- A `.md` file path
- A Notion link (paste content manually if MCP unavailable)

If no PRD is provided, ask once:
> "Please paste the PRD content or provide a file path to begin the gap analysis."

---

## Gate Check — Minimum Viable PRD

Before analyzing gaps, check if the document is even a PRD. It must have at least:
- A title or feature name
- Some form of problem or objective statement

If neither is present, stop and respond:
> "This document doesn't have enough structure to analyze. It needs at minimum a feature name and a problem or objective statement. Please add those and resubmit."

If only one is present, note it as a **Critical gap** and proceed with the analysis.

---

## Phase 1 — Section Scan

Check for the presence of each standard PRD section. Mark each as:
- ✅ Present — content exists and is substantive
- ⚠️ Partial — section exists but is vague, one-line, or placeholder text
- ❌ Missing — section is absent entirely

### Standard sections to check:

| Section | What to look for |
|---|---|
| Problem Statement | Clear articulation of the user or business problem being solved |
| Success Criteria | Observable, measurable outcomes — not activity metrics ("we will build X") |
| User / Persona | Who is affected, their role, context, and relevant workflow |
| Scope | What is explicitly in and out of scope for this release |
| User Stories / Jobs-to-be-Done | Specific tasks the user needs to accomplish |
| Functional Requirements | What the feature must do |
| Non-functional Requirements | Performance, accessibility, compliance, platform targets |
| Technical Constraints | Known engineering limitations, dependencies, or platform restrictions |
| Edge Cases | Unusual but valid states the design must handle |
| Open Questions | Unresolved decisions explicitly flagged by the PM |

Output a SECTION SCAN block:
```
SECTION SCAN
├── Problem Statement       [✅ / ⚠️ / ❌]
├── Success Criteria        [✅ / ⚠️ / ❌]
├── User / Persona          [✅ / ⚠️ / ❌]
├── Scope                   [✅ / ⚠️ / ❌]
├── User Stories / JTBD     [✅ / ⚠️ / ❌]
├── Functional Requirements [✅ / ⚠️ / ❌]
├── Non-functional Req.     [✅ / ⚠️ / ❌]
├── Technical Constraints   [✅ / ⚠️ / ❌]
├── Edge Cases              [✅ / ⚠️ / ❌]
└── Open Questions          [✅ / ⚠️ / ❌]
```

---

## Phase 2 — Gap Severity Rating

For every ⚠️ Partial or ❌ Missing section, assign a severity:

| Severity | Meaning |
|---|---|
| 🔴 Critical | Design cannot proceed without this. High rework risk. |
| 🟡 Moderate | Design can begin but will likely produce assumptions that need validation. |
| 🟢 Low | Nice to have. Absence won't block design but may cause minor gaps. |

### Severity defaults by section:

| Section | Default severity if missing |
|---|---|
| Problem Statement | 🔴 Critical |
| Success Criteria | 🔴 Critical |
| User / Persona | 🔴 Critical |
| Scope | 🔴 Critical |
| User Stories / JTBD | 🟡 Moderate |
| Functional Requirements | 🟡 Moderate |
| Non-functional Req. | 🟡 Moderate |
| Technical Constraints | 🟡 Moderate |
| Edge Cases | 🟢 Low |
| Open Questions | 🟢 Low |

Override defaults when context justifies it. Example: if the feature involves BIR/SSS/PhilHealth compliance, missing Non-functional Requirements becomes 🔴 Critical.

---

## Phase 3 — Clarifying Questions

For every 🔴 Critical and 🟡 Moderate gap, generate 1–2 specific clarifying questions the designer should ask the PM before proceeding.

Questions must be:
- **Specific** — tied to the actual gap, not generic
- **Answerable** — structured so the PM can respond with a concrete answer
- **Design-relevant** — focused on what would change design decisions

Bad: "Can you clarify the success criteria?"
Good: "What observable user action or system state tells us this feature is working? For example: is success when the employee completes the submission, or when the admin approves it?"

Output a CLARIFYING QUESTIONS block:
```
CLARIFYING QUESTIONS
├── [Section with gap]
│   ├── Q1: [specific question]
│   └── Q2: [specific question if needed]
└── ...
```

---

## Phase 4 — Design Risk Summary

Produce a short plain-language summary of:
1. **Overall readiness** — is this PRD ready for design, needs minor clarification, or needs significant work?
2. **Highest risk gaps** — the 1–2 items most likely to cause rework if not resolved
3. **Safe to start** — what parts of the design can begin now despite the gaps

Output a DESIGN RISK SUMMARY block:
```
DESIGN RISK SUMMARY
├── Readiness: [Ready / Needs clarification / Not ready]
├── Highest risk: [top 1-2 gaps and why they cause rework]
└── Safe to start: [what design work can begin now]
```

---

## Output Format

```
1. SECTION SCAN           — presence check across all standard sections
2. GAP SEVERITY RATINGS   — severity for each ⚠️ or ❌ section
3. CLARIFYING QUESTIONS   — PM questions for Critical and Moderate gaps
4. DESIGN RISK SUMMARY    — readiness verdict and safe-to-start guidance
```

All four sections are always shown. Do not skip any section even if gaps are minimal.

---

## Phase 5 — Design Context Brief

After the DESIGN RISK SUMMARY, output this structured block. It is the handoff contract to `prd-ux-validator` — do not skip it.

```
DESIGN CONTEXT BRIEF
├── Feature:        [PRD title]
├── Confirmed:
│   ├── [Section name]: [1–2 line extract of confirmed content — quote directly from PRD]
│   └── (one entry per ✅ Present section)
├── Gaps to fill:
│   ├── 🔴 [Section name] — [what is missing, stated as a research target]
│   ├── 🟡 [Section name] — [what is missing, stated as a research target]
│   └── 🟢 [Section name] — [what is missing, stated as a research target]
├── Design assumptions to validate:
│   └── [Assumptions the designer would be forced to make given current gaps]
├── Safe to design now:
│   └── [Flows or screens from the DESIGN RISK SUMMARY safe-to-start field]
└── Handoff recommendation: [proceed-to-enrichment | proceed-directly | needs-PM-input]
    └── [one sentence rationale]
```

**Handoff recommendation values:**
- `proceed-to-enrichment` — gaps exist but are fillable through secondary research; pass this file to `prd-ux-validator`
- `proceed-directly` — PRD is strong; enrichment is optional; product-design agent can proceed to Phase 1 Design Framing
- `needs-PM-input` — a Critical gap exists that research cannot fill (no problem statement, no scope, no target user); design should not proceed until PM responds

**Anti-hallucination rule for this block:** The Confirmed section quotes real PRD text only. The Gaps to fill section names what is absent — it does not fill the gap. The Design assumptions section names what a designer would be forced to assume; it does not resolve those assumptions. No new content is generated here.

---

## File Saving

After completing the analysis:

1. Create a folder: `skills/prd-gap-analyzer/outputs/[feature-slug]/`
2. Save the full gap report as `[feature-slug]-gap-report.md`
3. Tell the user:
   - The file path
   - The handoff recommendation
   - If `proceed-to-enrichment`: "Pass this file path to `prd-ux-validator` as the `gap-report` input to skip redundant PRD parsing."

Use the feature name from the PRD title as the slug (lowercase, hyphenated). If no title exists, use `untitled-[date]`.

---

## Behavioral Rules

1. Never suggest design solutions in this skill. The job is gap detection, not problem solving.
2. Severity overrides are allowed when Sprout domain context justifies it — especially for compliance-adjacent features (payroll, government remittances, leave law).
3. If a section exists but is clearly copied from a template with no real content (e.g., "TBD", "To be defined", "See Jira"), treat it as ❌ Missing.
4. The DESIGN RISK SUMMARY must always give a clear readiness verdict. Do not hedge with "it depends."
5. Calibrate to Sprout's context: success criteria should ideally connect to user outcomes, not just feature delivery. Flag criteria that only describe outputs ("we will build a dashboard") with no outcome.
6. This skill does not gate the design process — it informs it. The designer decides whether to proceed.

---

## Anti-Hallucination Rules

These rules exist to prevent the skill from generating plausible-sounding analysis that isn't grounded in the actual PRD content.

1. **Only analyze what is explicitly present in the document.** Do not infer, assume, or reconstruct sections from context or domain knowledge. If a section is not written in the PRD, it is ❌ Missing — regardless of how obvious its content might seem.

2. **Do not infer intent from adjacent content.** A detailed problem statement does not imply a scope section exists. A list of features does not imply success criteria exist. Each section must stand on its own.

3. **When flagging a ⚠️ Partial section, quote the actual text that caused the rating.** Do not paraphrase or describe what you think it says. Use the exact words from the PRD so the designer can verify the assessment independently.
   - Format: `⚠️ Partial — "actual text from PRD here" — reason this is insufficient`

4. **Never fill gaps.** If success criteria are missing, flag them as missing. Do not generate example success criteria, even as illustration. The skill's job is to surface the gap, not resolve it.

5. **Never upgrade a rating based on what the PM probably meant.** A vague statement is ⚠️ Partial even if the intent is guessable. Generous interpretation is the PM's job, not this skill's.

6. **Clarifying questions must be grounded in the actual gap.** Do not generate questions about topics not related to what is missing or partial in the specific PRD being analyzed. Generic PRD questions are not allowed.

7. **If uncertain whether a section is ✅ Present or ⚠️ Partial, default to ⚠️ Partial.** Err toward surfacing more gaps, not fewer. A false negative (missing gap not caught) is more costly than a false positive (gap flagged that PM considers sufficient).