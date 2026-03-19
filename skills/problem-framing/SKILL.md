---
name: toge:problem-framing
description: >
  Use when framing a product problem, applying Jobs-to-be-Done thinking, creating
  How-Might-We statements, or building opportunity trees. Trigger phrases: "frame the
  problem", "JTBD", "jobs to be done", "how might we", "opportunity", "problem statement",
  "what problem are we solving".
---

## Overview

This skill helps structure vague product problems into clear, actionable problem statements using proven frameworks. Unframed problems lead to solutions that miss the mark. This skill forces precision: who is the user, what are they actually trying to accomplish, why do current solutions fail them, and what would success look like?

Apply this skill before ideation, before writing specs, and whenever a team is debating solutions without agreeing on the problem.

---

## Jobs-to-be-Done (JTBD)

JTBD reframes problems around what users are trying to accomplish — not what they're asking for.

### The Core JTBD Template

```
When [situation], I want to [motivation], so I can [expected outcome].
```

**Example:**
> When I receive my monthly credit card statement, I want to quickly understand where my money went, so I can decide what to cut next month.

### Three Job Types to Identify

Every significant job has three layers. Identify all three — missing any one produces incomplete solutions.

- **Functional job** — the practical task the user is trying to complete. (e.g., "track my monthly expenses")
- **Emotional job** — how the user wants to feel during or after completing the task. (e.g., "feel in control of my finances instead of anxious")
- **Social job** — how the user wants to be perceived by others because of this. (e.g., "look financially responsible to my partner or financial advisor")

### Process

Before generating JTBD statements, ask 3–5 clarifying questions to understand the user and their context:

1. Who is the primary user? What is their role, life stage, or context?
2. What triggers this job — what situation or event prompts the need?
3. What do they currently do to get this job done? (The incumbent solution, even if it's a spreadsheet or nothing)
4. What about the current solution frustrates them most?
5. What does "done well" look like to them — how would they know they succeeded?

Then generate a JTBD statement for each of the three job types.

---

## Opportunity Tree

The opportunity tree maps the path from a desired outcome to concrete solutions, via the real obstacles in the way.

### Structure

```
Desired Outcome
└── Opportunity 1 (unmet need or pain point)
    ├── Solution A
    └── Solution B
└── Opportunity 2
    ├── Solution C
    └── Solution D
└── Opportunity 3
    ├── Solution E
    └── Solution F
```

### How to Build It

1. **Start with the desired outcome.** State what the user ultimately wants to achieve — not a feature, but an outcome. (e.g., "Feel confident I'm not overspending each month.")

2. **List opportunities.** Opportunities are obstacles, unmet needs, or friction points standing between the user and their desired outcome. Each opportunity should be phrased as a user need, not a product feature. (e.g., "Users don't know they're overspending until it's too late.")

3. **Brainstorm solutions per opportunity.** For each opportunity, generate 2–3 distinct solution directions. Solutions should vary in approach — don't just list variations of the same idea.

4. **Prioritize.** Score each opportunity by:
   - **Impact** — how much does solving this move the user toward their desired outcome? (1–5)
   - **Feasibility** — how achievable is this given current constraints? (1–5)
   - Prioritize opportunities with the highest combined score.

---

## How-Might-We (HMW) Statements

HMW statements are the bridge between problem and solution. They're questions, not answers — designed to open up solution space rather than prescribe it.

### Formula

```
How might we [verb] [user] [goal] without [constraint]?
```

The constraint at the end is optional but powerful — it forces creative thinking past the obvious solution.

**Example:**
> How might we help users notice overspending patterns before the end of the month, without making them review every transaction?

### Rules for Good HMW Statements

- **Not too broad:** "How might we improve the financial experience?" — too vague to act on.
- **Not too narrow:** "How might we add a red alert when spending exceeds $500?" — too prescriptive, forecloses alternatives.
- **The right width:** Each HMW should inspire 3–5 meaningfully different solution directions.
- **Generate 5–10 HMW statements per problem.** Volume matters — the first few are obvious; the interesting ones come later.
- **One problem per statement.** Don't combine two unrelated problems into one HMW.

---

## Problem Statement Structure

A well-formed problem statement captures the user, their need, and the insight that explains why current solutions fail — in one or two sentences.

### Template

```
[User type] needs a way to [goal/need]
because [insight about why current solutions fail].
```

**Example:**
> People who track expenses manually need a way to see spending patterns emerge in real time because by the time they review a monthly summary, the moment to change behavior has already passed.

### What Makes the Insight Good

The insight — the "because" clause — is the most important part. A weak insight restates the problem ("because they don't know how much they spent"). A strong insight reveals the mechanism of failure: why existing tools, habits, or workarounds break down for this specific user in this specific situation.

To find the insight, ask: "People already have [spreadsheets / budgeting apps / bank statements]. Why doesn't that work?" The answer is the insight.

---

## Output Format

Produce a Problem Brief containing these five sections:

1. **Core JTBD** — One statement for each job type: functional, emotional, and social. Use the "When / I want to / so I can" template.

2. **Opportunity Tree** — The top 2–3 opportunities, each with 2 solution directions. Include your prioritization rationale (impact × feasibility).

3. **HMW Statements** — 5 How-Might-We statements. They should span different angles of the problem — not variations of the same framing.

4. **Problem Statement** — A single, crisp statement using the template above. One or two sentences maximum. The insight must be specific.

5. **Success Criteria** — How would we know we solved this problem? Define 2–3 measurable or observable signals that would indicate the solution is working. These should map directly back to the desired outcome and the JTBD, not to output metrics like "shipped a feature."
