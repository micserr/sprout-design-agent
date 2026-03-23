---
name: toge:ux-market-research
description: >
  Use when researching competitors, analyzing market landscape, or identifying industry trends
  for a product. Trigger phrases: "research competitors", "market analysis", "competitive
  landscape", "industry trends", "market research", "analyze the market", "who are the competitors".
---

## Overview

This skill structures competitive and market research into a consistent, actionable report. Rather than producing a loose collection of facts, it applies repeatable frameworks — feature matrices, positioning maps, SWOT analysis, market sizing, and trend scanning — so every research engagement produces comparable, decision-ready output.

Use this skill whenever a product team needs to understand the competitive landscape before making strategic, positioning, or prioritization decisions.

---

## How to Use This Skill

Follow these steps in order:

1. **Confirm the product or space.** If the user hasn't specified what product or market to research, ask: "What product or market are we researching? Who is the target user?"
2. **Identify competitors.** Surface 3–5 direct competitors (same job-to-be-done, same user) and 2–3 indirect competitors (different solution, same underlying need).
3. **Run through each framework below.** Complete the Feature Matrix, Positioning Map, and per-competitor SWOT. Then estimate market size and scan for trends.
4. **Output the structured research report** using the format defined in the Output Format section.

---

## Competitive Analysis Framework

### Feature Matrix

Use this table structure. List competitors as columns and key capabilities/features as rows. For each cell, mark:
- **Yes** — fully supported
- **Partial** — limited or requires workaround
- **No** — not supported

| Feature / Capability | Competitor A | Competitor B | Competitor C | Your Product |
|----------------------|-------------|-------------|-------------|--------------|
| [Feature 1]          |             |             |             |              |
| [Feature 2]          |             |             |             |              |
| [Feature 3]          |             |             |             |              |

Choose features that matter to the target user — not an exhaustive list of everything each product does.

---

### Positioning Map

Pick two axes that reflect the key tradeoffs in this market. Common pairs:
- Simple ↔ Complex
- Affordable ↔ Premium
- Narrow focus ↔ All-in-one
- Self-serve ↔ High-touch

For each competitor, describe where they sit on both axes and why. Then identify the whitespace — the quadrant or region where no strong competitor currently lives. That whitespace is a potential positioning opportunity.

---

### SWOT per Competitor

For each major competitor, produce a focused SWOT from your product's perspective:

- **Strengths** — what they do well that you need to match or counter
- **Weaknesses** — where they fall short (user complaints, missing features, poor UX, pricing issues)
- **Opportunities** (for you) — gaps their weaknesses create that you can exploit
- **Threats** (to you) — ways they could respond, expand, or outmaneuver you

Keep each SWOT tight: 2–4 bullets per quadrant.

---

## Market Sizing Approach

Estimate market size in three layers:

**TAM — Total Addressable Market**
The full global demand if everyone who could use this type of product did. Use top-down data: industry analyst reports (Gartner, IDC, Statista), public filings, or press coverage. State the source and year.

Prompt questions:
- How many people or businesses globally have this problem?
- What do they currently spend (in time, money, or tools) to solve it?

**SAM — Serviceable Addressable Market**
The portion of TAM you can realistically reach given your business model, geography, and target segment. Apply filters: language, distribution channel, pricing tier, industry vertical.

Prompt questions:
- Which segments are actually reachable in your first 2–3 years?
- What portion of the TAM fits your ideal customer profile?

**SOM — Serviceable Obtainable Market**
Your realistic capture in year one or two. This is usually 1–5% of SAM for early-stage products. Justify the number based on go-to-market capacity, not wishful thinking.

Prompt questions:
- How many customers can your team realistically support or acquire?
- What does a comparable company's early traction suggest?

---

## Trend Identification

Scan for signals across four categories:

**Technology trends**
What new or maturing technology is changing what's possible in this space? (e.g., LLMs enabling new interaction patterns, cheaper sensors, faster mobile networks)

**Behavior trends**
How are user habits, expectations, or workflows shifting? (e.g., users expecting AI-assisted defaults, remote-first workflows becoming permanent, shorter attention spans)

**Regulatory and market trends**
Compliance requirements, industry consolidation, new standards, or funding shifts that reshape the competitive environment. (e.g., data privacy regulations, vertical SaaS consolidation, enterprise procurement shifts)

**Weak signals**
Early indicators that haven't hit mainstream awareness yet. Look at niche communities, academic research, adjacent industries, and startup activity. These are bets worth watching, not certainties.

For each trend identified, note: What's the implication for product strategy? Does it favor or threaten your position?

---

## Output Format

The final deliverable is a structured markdown report with these sections:

1. **Executive Summary** — 3–5 bullet points summarizing the most important findings and strategic implications. Write this last; it should reflect the full analysis.

2. **Competitor Overview** — The completed feature matrix, with a brief narrative interpreting what it shows.

3. **Positioning Analysis** — The positioning map description plus a paragraph on identified whitespace.

4. **Market Size Estimate** — TAM / SAM / SOM with sources and assumptions stated explicitly.

5. **Key Trends** — 2–3 trends per category (Technology, Behavior, Regulatory, Weak Signals). Keep it scannable.

6. **Gaps and Opportunities** — The most important section. Synthesize the analysis into 3–5 specific, actionable opportunities: things no competitor is doing well, underserved user segments, or unaddressed jobs-to-be-done. Each opportunity should include a one-sentence rationale for why it exists and why now.
