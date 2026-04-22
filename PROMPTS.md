# Sample Prompts

Ready-to-use prompts for every skill and workflow. Copy, fill in the brackets, and paste into Claude Code.

---

## Full Workflow (Product Design Agent)

**Start from a PRD or Intent doc — standard entry point**
```
Toge, here's the PRD: [file path or paste content]

Run the full product design workflow.
```

**Generate a screen spec first (Mesh Mode Phase 0)**
```
Run prd-gap-analyzer on [file path to product outcome + product unit].
Produce the screen spec.
```

**Resume at prototype**
```
Skip to Phase 3. Here's the context:
- Product: [product name]
- Screen spec: [file path or paste content]
- Stack: Vue 3 · Tailwind v4 · Toge

Prototype the screens from the spec.
```

---

## Pipeline (Individual Steps)

### Step 1 — Screen Spec
```
Product outcome: [file path or paste]
Product unit: [file path or paste]

Generate the screen spec.
```

### Step 2 — Prototype
```
Screen spec: [file path from step 1]
Stack: Vue 3 · Tailwind v4 · Toge · entry: prototype/main.js · dark mode: yes

Build the prototype from the screen spec.
```

### Step 3 — Design Framing (optional — run when design framing adds value)
```
Screen spec: [file path]

Run Phase 1 Design Framing. Extract JTBD statements, HMW statements, and reframe success criteria as UX outcomes.
```

---

## Individual Skills

### User Journey
```
Map the end-to-end user journey for [primary use case].
Anchor pain points on the open design decisions from the screen spec.
Include a journey map table and a Mermaid flow diagram. Focus on the critical path.
```

### Prototype
```
Turn the wireframes in wireframes/ into a fully interactive prototype.
Stack: Vue 3 · Tailwind v4 · Toge · entry: prototype/main.js · dark mode: yes
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

### Animations
```
This [component / screen] feels off. Review it and give me specific fixes for animations, surfaces, and typography.
[paste code]
```

```
Apply animations and micro-interactions to the prototype in prototype/screens/.
Go screen by screen: hover states, enter/exit transitions, button feedback, icon state changes.
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
