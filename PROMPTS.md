# Sample Prompts

Ready-to-use prompts for every skill and workflow. Copy, fill in the brackets, and paste into Claude Code.

---

## Full Workflow (Product Design Agent)

**Start from a PRD or Intent doc — standard entry point**
```
Design agent, here's the PRD: [file path or paste content]

Run the full product design workflow.
```

**Start with a gap check first, then hand off to the agent**
```
Run prd-gap-analyzer on [file path].
Then pass the gap report to prd-ux-validator and produce the enriched design brief.
```

**Resume at a specific phase**
```
Skip to Phase 3. Here's the context:
- Product: [product name]
- Enriched brief: [file path to secondary-research output]
- User journey already mapped: [paste or describe it]
- Stack: Vue 3 · Tailwind v4 · Toge v2

Wireframe the most critical screens.
```

---

## PRD Pipeline (Individual Steps)

### Step 1 — Gap Analysis
```
Analyze this PRD for gaps before we start design work:
[file path or paste PRD content]
```

### Step 2 — Context Enrichment
```
Run prd-ux-validator on this PRD.
Gap report: [file path from step 1]
Depth: standard
Geography: Philippines
```

### Step 3 — Design Framing (from enriched brief)
```
Run Phase 1 Design Framing using the enriched brief at:
[file path to secondary-research output]

Extract JTBD statements, HMW statements, and reframe the success criteria as UX outcomes.
```

---

## Individual Skills

### User Journey
```
Map the end-to-end user journey for [primary use case].
Anchor pain points on: [FP-1 description] and [FP-2 description].
Include a journey map table and a Mermaid flow diagram. Focus on the critical path.
```

### Wireframing

**Single screen**
```
Wireframe a [screen type] for [product name].
Use the bento layout. Placeholder content should be realistic, not Lorem Ipsum.
```

**Multiple screens**
```
Wireframe the following screens for [product name]:
1. [Screen name] — [one-line purpose]
2. [Screen name] — [one-line purpose]
3. [Screen name] — [one-line purpose]

Use the bento layout. Save as wireframes/01-[name].vue, etc.
```

### Prototype
```
Turn the wireframes in wireframes/ into a fully interactive prototype.
Stack: Vue 3 · Tailwind v4 · Toge v2 · entry: prototype/main.js · dark mode: yes
Wire all screens together with real navigation. Add edge states where the journey map flagged pain points.
```

### Design Tokens
```
What token should I use for [describe the use case — e.g., "a card background", "error text", "a subtle divider"]?
```

```
Review this component for token violations and replace any raw values:
[paste component code]
```

### Design QA
```
Run a design QA on [screen name / paste code].
Check all 4 pillars: visual consistency, token compliance, accessibility, and interaction readiness.
Give me a findings table with severity ratings and offer to fix the issues.
```

```
Is this design ready for frontend handoff?
[paste code or describe the screen]
```

### UI Polish
```
This [component / screen] feels off. Review it and give me specific fixes for animations, surfaces, and typography.
[paste code]
```

```
Apply a full UI polish pass to the prototype in prototype/screens/.
Go screen by screen: typography, surfaces, animations, performance — in that order.
```

---

## Advisor Mode (Quick Questions)

**Component decision**
```
Should I use a modal or a drawer for [use case]? Give me a direct recommendation with the tradeoff.
```

**Animation fix**
```
The [element] animation feels [too slow / too abrupt / mechanical]. What should I change?
[paste the current CSS or component code]
```

**Token question**
```
Which token should I use for [background / text / border] on a [card / button / input] in [light / dark] mode?
```

**Design review**
```
Review this screen against Nielsen's heuristics and tell me what's wrong.
[paste code or describe the screen]
```

---

## Design QA — Standalone Triggers

These phrases trigger Design QA without going through the full workflow:

- `"review this design"`
- `"design qa"`
- `"audit the UI"`
- `"is this ready for handoff"`
- `"QA this screen"`
