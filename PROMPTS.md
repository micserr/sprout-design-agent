# Sample Prompts

Ready-to-use prompts for every skill and workflow. Copy, fill in the brackets, and paste into Claude Code.

---

## Full Workflow (Product Design Agent)

**Run the complete design workflow from a brief**
```
Design agent, here's my brief:

Product: [what you're building]
User: [who it's for]
Problem: [what problem it solves]
Constraints: [platform, timeline, existing product]

Run the full product design workflow.
```

**Resume at a specific phase**
```
Skip to Phase 4. Here's the context:
- Product: [product name]
- User journey already mapped: [paste or describe it]
- Stack: Vue 3 · Tailwind v4 · Toge v2

Wireframe the 5 most critical screens.
```

---

## Individual Skills

### UX Market Research
```
Research the competitive landscape for [product idea].
Identify 3–5 direct or adjacent competitors and surface the biggest gaps in the market.
```

### Problem Framing
```
Help me frame the problem for [product/feature].
Generate JTBD statements, an opportunity tree, and 3–5 How-Might-We statements.
```

### User Journey
```
Map the end-to-end user journey for [primary use case].
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
