---
name: secondary-research
description: Use when the user asks for competitive analysis, landscape analysis, desk research, market research, or a UX design brief on any topic. Triggers on: "research X", "competitive analysis of X", "landscape of X", "desk research on X", "what's out there for X", "brief on X".
---

# Secondary Research

Run structured web research and save a reviewable design brief to `skills/secondary-research/outputs/`.

The brief serves two readers: the **PM** (strategic review before approving) and the **prototype-agent** (execution). Both need different content. Produce all sections — PM-oriented sections provide strategic grounding; prototype-specific sections provide the parsed inputs the prototype-agent reads directly.

The brief must do two things: **document** what exists and **interrogate** whether the framing is correct. A brief that only documents findings is incomplete. Apply pressure to the opportunity — name what the evidence actually supports, where the window is closing, and what must be resolved before building anything.

## Inputs

Ask the user for these if not already provided:
- **topic** — what to research (required)
- **mode** — `competitive` | `landscape` | `desk` (required)
- **depth** — `quick` | `standard` | `deep` (default: `standard`)
- **geography / market** — specific country, region, or market context (required for product briefs; default to global if explicitly confirmed)

**Topic scope check — do this before searching:**
If the topic is a single generic word or broad category (e.g. "fintech", "healthcare", "technology", "payments"), stop and ask:
> "That topic is quite broad. Can you specify a segment, geography, user group, or product type? For example, instead of 'fintech', try 'remittance apps in Southeast Asia'."
Only proceed once the topic is specific enough to surface actionable findings.

## Search Strategy by Depth

| Depth | Searches | Use when |
|-------|----------|----------|
| quick | 3 | Fast scan, early exploration |
| standard | 6 | Typical research brief |
| deep | 10 | High-stakes design decision |

Run searches one at a time. After each, assess: do you have enough to answer the research question, or does the next search still add value?

**Recency:** Prioritize sources from the last 2 years. If you use an older source, note its year explicitly in the citation. Avoid presenting dated findings as current without flagging them.

**Thin results check:** After the first 3 searches, if findings are sparse, too generic, or mostly opinion with no data, stop and tell the user:
> "Research on this topic returned limited results. The brief may be too shallow to inform design decisions. Options: (1) narrow the topic, (2) switch mode, or (3) proceed with a caveat flagged in Open Questions."
Do not silently produce a shallow brief.

## Research Focus by Mode

**competitive** — Who are the key players? What UX patterns and interaction conventions do they use? What do users love/hate (reviews, forums)? Where are the gaps? What is the **consistent structural gap across all players** — the thing nobody has built?

Useful query types: product names, "[product] UX review", "[product] alternatives", "[product] complaints", "[category] design patterns"

**landscape** — What is the full shape of this problem space? Who are the user segments? What mental models exist? What trends are emerging? Who are the institutional players (government, NGOs, major corps) already moving in this space?

Useful query types: "[topic] industry trends", "[topic] user research", "jobs to be done [topic]", "future of [topic]", "[topic] market segments"

**desk** — What existing research, data, and reports exist? What behavioral patterns and constraints affect design decisions? What standards or regulations apply?

Useful query types: "[topic] research report", "[topic] UX case study", "[topic] user behavior study", "[topic] statistics", "[topic] accessibility standards"

---

## ⚠ Anti-Hallucination Protocol

Apply these rules throughout research and writing. They are non-negotiable.

### 1. Source Ledger (do this before writing)
Before drafting the brief, compile a private source ledger:
- List every URL actually retrieved during this session
- Note the title and a one-sentence summary of what it contained
- **Only sources in this ledger may appear as footnotes.** Do not cite a URL you did not retrieve.

### 2. Claim-Source Binding
Every factual claim — statistics, product descriptions, user behavior findings, market data — must be traceable to a ledger source. If you cannot bind a claim to a source:
- Replace it with: `[unverified — flag for primary research]`
- Do not rephrase or infer your way to a citation

### 3. Numeric Stat Quarantine
Never write a percentage, figure, or numeric statistic without the exact source URL inline. If a stat appears in your memory but was not returned in search results this session, it must not appear in the brief. Write instead: `[stat not retrieved this session — verify before use]`

### 4. Pre-Publish Citation Audit
Before finalizing the Sources section, run this check internally:
> "For each `[^n]` footnote in the brief: was this URL returned in my search results this session? If no → remove the footnote and replace the claim with [unverified]."

No footnote may exist without a corresponding retrieved URL.

### 5. Confidence Flagging
Use these inline markers when certainty varies:

| Marker | When to use |
|--------|-------------|
| `[verified]` | Directly supported by a retrieved source |
| `[inferred]` | Reasonable inference from retrieved sources — not stated directly |
| `[unverified]` | Cannot be bound to a retrieved source — must not drive design decisions |

### 6. "I Don't Know" is Valid
If a section has no retrieved signal, write:
> "No clear signal found — recommend primary research before making design decisions in this area."

Do not fill gaps with plausible-sounding content. Silence is more useful than confident fabrication.

---

## Output Format

Produce the design brief in this exact structure. Start directly with the frontmatter — no preamble. **There is no word count cap — be comprehensive. A thorough analytical brief is more valuable than a short one.**

```
---
topic: "[topic]"
mode: [mode]
date: [YYYY-MM-DD]
depth: [depth]
status: draft
---

# [Brief Title]

---

## 1. The Macro Signal
*(PM)*

Lead with the strongest evidence that the problem is real and large. Anchor to geography if applicable. Include:
- The strongest stat(s) that confirm demand exists
- Any local/regional signal that differentiates this market from the global average
- Why the timing is now (what has changed recently)
- The structural risk if the problem goes unsolved (e.g. "AI adoption concentrates in top 10% of firms, widening the gap rather than closing it")

This section sets the stakes. If the macro signal is weak, say so and flag it as a risk.

## 2. Competitive Landscape
*(PM + prototype fallback)*

Key players organized by type (global platforms, local institutional players, adjacent tools).

Format as a table per player category:

| Player | What they're building | Gap they still leave |

After the table, write a **Consistent Structural Gap** paragraph: the pattern that all players share. This is the whitespace. Be specific — "nobody is building X" is more useful than "there is an opportunity."

Cite sources inline [^1]. Every product claim must be [verified] or [inferred].

## 3. The Definitional Problem
*(PM)*

Before listing opportunities, interrogate whether the framing is coherent. Ask: **What is the unit of value this product delivers?**

If there are two fundamentally different product directions implied by the topic (e.g. skill-first vs task-first, learning tool vs workflow tool), name them explicitly and show what each implies:

- Direction A → who it competes with, what the user must believe, what the product must do
- Direction B → who it competes with, what the user must believe, what the product must do

Then state which direction the research evidence supports, or flag it as an open question if evidence is insufficient.

If the framing is unambiguous, write: "The framing is coherent — no definitional split identified."

## 4. User Segments
*(PM + prototype)*

For each segment: role, motivation, behavior, emotional state, and key design insight.

Format each as a named sub-section (e.g. **4a. The Anxious Stayer**).

## 5. Friction Points
*(prototype)*

2–4 named friction points at interaction level — not market-level problems, but specific moments where the user's task breaks down. Derived from user reviews, behavioral data, and competitive research.

Format each as:
**FP-[n]: [Name]** — [what the user is trying to do, what breaks, what they feel]

Example:
**FP-1: First-lesson drop-off** — User opens the app, sees a wall of module options, has no clear starting point, closes after 30 seconds.

These friction points are the primary inputs for Design Implications and the Prototype Agent Input Block. Every DI must resolve at least one FP.

## 6. User Research Hypotheses
*(PM)*

Generate 3–5 testable hypotheses that must be resolved before confident product decisions can be made. For each:

- **H[n] — [Name]** *(priority note: must resolve before building | test early | targeting question)*
- Write the hypothesis as a falsifiable claim in italics
- State: "If confirmed → [product/design implication]. If false → [alternative direction]."

Focus hypotheses on the highest-stakes unknowns — the ones where being wrong changes the product fundamentally.

## 7. Patterns & Conventions
*(PM + prototype)*

What users already expect based on existing solutions. Dominant mental models and interaction norms. Include:
- Conventions that work and should be followed
- **Problematic conventions to avoid** (anti-patterns, overused tropes, patterns causing user fatigue)

Every pattern claim must be bound to a source or marked [unverified].

## 8. Whitespace & Opportunities
*(PM)*

Gaps, underserved needs, differentiation space. Rank by:
1. **Primary whitespace** — the core confirmed gap no one is filling
2. **Secondary whitespace** — adjacent gaps
3. **Tailwinds** — structural forces that increase urgency or fundability

For each, assess: is this whitespace confirmed by evidence, or inferred?

## 9. Constraints
*(PM + prototype)*

Guardrails the prototype agent must design within. Include any of the following that are relevant:
- **Regulatory** — compliance requirements surfaced in research
- **Technical** — platform limitations, API dependencies, offline/connectivity constraints
- **Accessibility** — standards or user population needs that affect interaction design
- **Learner / User** — attention, device, prior knowledge, motivation, literacy constraints
- **Market** — sales cycle, content shelf life, credentialing trust constraints

If no constraints are found, write: "No constraints surfaced — recommend flagging with engineering before prototype handoff."

## 10. Product Concept — Leanest Version
*(PM + prototype)*

Propose the minimum viable product concept that tests the core value proposition. This is not a full spec — it is the smallest thing that answers the most important question.

Include:
- The core mechanic (what does the user actually do)
- Entry point / first interaction
- What the MVP explicitly does NOT include
- **MVP test:** what metric or behavior would validate the concept in early testing

This section bridges research to prototype — give the prototype agent something concrete to build from.

## 11. User Flow / Screen Map
*(prototype)*

An ordered list of screens the prototype should include. This is the minimum flow that validates the core mechanic — not a full product spec.

For each screen, provide:
- **Name** — what to call the screen
- **Purpose** — one-line description of what the screen accomplishes
- **Primary action** — the one thing the user does on this screen
- **Transition** — what happens next / what screen follows

Format as a numbered list, not prose. Example:

1. **Role Picker** — Establishes user context before showing any content. Primary action: select role from 3–4 options. → leads to Home
2. **Home / Dashboard** — Shows the user's current state and primary CTA. Primary action: tap "Start" or resume last session. → leads to Session
3. **Session** — Core mechanic screen. Primary action: complete the task unit. → leads to Completion
4. **Completion** — Confirms success and surfaces next step. Primary action: "Next" or "Done". → returns to Home

Derive this flow from the Product Concept and Friction Points. Every screen must serve a purpose — do not include screens that don't resolve a friction point or advance the core mechanic.

## 12. The Critical Strategic Question
*(PM)*

Name the single most important unresolved strategic question that will change the entire product. Common forms:
- B2C vs B2B vs B2G — who is the buyer, who is the user, how does that change the product
- Platform-native vs standalone — does the product exist inside an existing tool or on its own
- Skill-first vs task-first (see Definitional Problem)

State what decision must be made before building, and the safest sequencing if full resolution isn't possible yet.

## 13. Risks
*(PM)*

Name 3–5 risks directly. Not generic risks — specific, evidence-grounded risks for this opportunity.

Format each as:
**Risk [n] — [Name]:** [One paragraph. State what the risk is, what evidence supports it, and what it means for the product timeline or design.]

Do not soften risks. If the window is 12–18 months, say that. If the revenue model is unclear, say that. Honest risk assessment is more useful than optimism.

## 14. Design Implications
*(prototype)*

5 UX-specific, directional takeaways for the prototype agent. Each must:
- Name the **specific screen or component** it applies to
- State the **interaction pattern** to use — not the business rationale
- Reference the friction point it resolves (FP-n)
- Be traceable to at least one source in the ledger (cite inline)

Format: `**DI-[n]: [Screen/Component] — [Imperative]** — [One sentence on the interaction pattern]. Resolves FP-[n]. [^citation]`

Example:
**DI-1: Onboarding / Role picker** — Show role selection as the first and only action on the first screen; do not show any other content until role is selected. Resolves FP-1. [^3]

Every DI must resolve at least one named FP from section 5.

## 15. Prototype Agent Input Block
*(prototype)*

A pre-parsed block formatted exactly as the prototype-agent's RESEARCH SUMMARY expects. The prototype-agent copies this directly into its Phase 1 output. Do not paraphrase — be precise and terse.

> **Format authority:** The field names in this block are governed by `skills/prototype-agent/SKILL.md` Phase 1 RESEARCH SUMMARY block. That is the canonical definition. If you change field names there, update this block to match. Do not rename or reorder fields independently.

```
PROTOTYPE AGENT INPUT
├── User: [role + context, e.g. "Mid-career professional upskilling on mobile during commute"]
├── Core need: [one sentence, e.g. "Learn a marketable skill in 10-minute sessions without losing progress"]
├── Primary friction: [FP-1 name and FP-2 name from section 5]
├── Decision trigger: [what initiates the user interaction, e.g. "Notification or habit cue prompts app open"]
├── Success state: [what task completion looks like, e.g. "User completes a lesson unit and sees progress update"]
├── Key constraints: [condensed from section 9, comma-separated]
└── Screen map: [ordered list of screen names from section 11, e.g. "Role Picker → Home → Session → Completion"]
```

## 16. Pressure-Test Verdict
*(PM)*

One final paragraph that synthesizes the brief into a direct assessment:
- Is the opportunity real? (evidence-based, not hedged)
- What is the viable version of the product — narrowed from the original framing?
- What is the moat, if any?
- What is the primary risk that determines whether it works?
- What must happen first?

This is not a summary. It is an opinion grounded in the research. Be direct.

## 17. Open Questions
*(PM + prototype)*

What still needs validation before key design decisions can be made?
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

1. Generate the filename: `YYYY-MM-DD_[mode]_[topic-slug].md`
   - topic-slug = lowercase, spaces → hyphens, remove special characters
   - Example: `2026-03-17_competitive-desk_ai-literacy-fluency-non-tech-workers.md`

2. Save to: `skills/secondary-research/outputs/[filename]`

3. Tell the user:
   - The file path
   - To change `status: draft` → `status: approved` when satisfied
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
- Design Implications must name a specific screen/component and reference an FP — the prototype agent reads them directly
- Every DI must resolve at least one named FP from the Friction Points section
- Constraints section is required in every brief — never omit it, even if empty
- Every `[^n]` footnote must pass the pre-publish citation audit before the brief is saved
- The Pressure-Test Verdict must take a position — hedged non-conclusions are not acceptable
- The Definitional Problem section must interrogate the framing, even if only to confirm it holds
- Hypotheses must be falsifiable and include both if-confirmed and if-false branches
- The Prototype Agent Input Block must use exact field names — do not rename or reorder fields
- The User Flow / Screen Map must derive from Product Concept and Friction Points — no screens without purpose