---
name: toge:design-qa
description: >
  Use when reviewing a design for quality assurance, auditing visual consistency, checking
  accessibility, validating design token usage, or evaluating a screen before handoff.
  Trigger phrases: "design QA", "review this design", "audit the UI", "check the design",
  "design review", "QA this screen", "is this design ready", "before handoff", "design audit".
---

## Overview

This skill produces a structured **Design QA report** that evaluates a screen or component against four pillars: **Visual Consistency**, **Design Token Compliance**, **Accessibility**, and **Interaction Readiness**. The output is a prioritized list of findings with severity ratings and actionable fixes — not a vague critique.

**REQUIRED:** Before running the Token Compliance pillar, always load `toge:design-tokens`. Token checks must be validated against the actual token system — surface classes, semantic families, text tokens, border tokens, and typography classes defined there.

---

## QA Pillars

| Pillar | What It Checks |
|---|---|
| **Visual Consistency** | Alignment, spacing rhythm, typography hierarchy, color usage |
| **Token Compliance** | Correct use of design tokens (colors, type, spacing, surfaces) |
| **Accessibility** | Contrast ratios, touch targets, label presence, focus order |
| **Interaction Readiness** | All states defined, edge cases covered, responsive behavior described |

---

## Severity Levels

| Level | Label | Meaning |
|---|---|---|
| 🔴 | **Critical** | Blocks handoff — must be fixed before development |
| 🟡 | **Major** | Significant issue that degrades UX or violates standards |
| 🔵 | **Minor** | Polish or consistency improvement; low risk if deferred |
| ⚪ | **Note** | Observation or suggestion; no action required |

---

## Process

1. **Identify the scope.** What screen, flow, or component is being reviewed? Anchor the review to a specific artifact (Figma URL, screenshot, or description).
2. **Run each pillar check.** Evaluate the design against each pillar's criteria below.
3. **Log every finding.** Each finding gets a severity, pillar, location, and a concrete fix.
4. **Summarize.** Count findings by severity. State whether the design is **Ready**, **Conditionally Ready**, or **Not Ready** for handoff.

---

## Pillar Criteria

### Visual Consistency

- [ ] Spacing follows the 4pt/8pt grid — no arbitrary pixel values
- [ ] Consistent alignment within and across sections (left-align or center-align, not both)
- [ ] Typography hierarchy is clear: one H1, logical H2/H3 nesting, body text distinct from labels
- [ ] Icon sizes are consistent within context (16px, 20px, 24px — don't mix)
- [ ] Shadows and elevation are used consistently — not decoratively

### Token Compliance

> Cross-check every item below against `toge:design-tokens` — use the actual token tables, not assumptions.

- [ ] All background colors use a Layer 3 surface or semantic token (`bg-surface-adaptive`, `bg-brand`, etc.) — never a raw hex or primitive (`bg-mushroom-100`)
- [ ] All text uses a component-only text token (`text-strong`, `text-base`, `text-weak`, `text-{family}-text`) — never a raw color or primitive
- [ ] All borders use a border token (`border border-base`, `border-weak`, `border-strong`) — never a raw color
- [ ] Typography uses the correct component class (`body`, `heading-md`, `label-sm`, etc.) — never raw `text-{size}` utilities
- [ ] Semantic state colors use the correct family (`brand`, `success`, `danger`, `caution`, `pending`, `information`, `accent`) with the right modifier (`-subtle`, `-text`, etc.)
- [ ] Dark mode: if dark mode is in scope, tokens are used correctly — toggle `.dark` on `<html>`, no hardcoded light/dark overrides
- [ ] No primitives used in component code (e.g., no `bg-kangkong-500`, `text-mushroom-600`) — exception: `ubas` palette for charts only

### Accessibility

- [ ] Text/background contrast meets WCAG AA (4.5:1 for normal text, 3:1 for large text)
- [ ] Interactive elements are at least 44×44px touch targets
- [ ] All form inputs have visible, associated labels (not just placeholder text)
- [ ] Focus states are visible and distinct — not just a color change
- [ ] Icons used without text have an accessible label or tooltip defined
- [ ] Error states include both color and a text message — never color alone

### Interaction Readiness

- [ ] All interactive states are designed: default, hover, focus, active, disabled
- [ ] Empty states are defined for lists, tables, and data-heavy components
- [ ] Loading states are defined for async content
- [ ] Error states are defined for failed actions or invalid input
- [ ] Responsive behavior is described or shown at relevant breakpoints
- [ ] Edge cases are covered: long text, missing data, maximum item counts

---

## Output Format

Produce the QA report in this order:

### 1. Summary

```
Screen / Component: [name or URL]
Reviewed by: [reviewer or "Design QA Agent"]
Date: [date]

Findings: X Critical · X Major · X Minor · X Notes
Handoff Status: Ready / Conditionally Ready / Not Ready
```

**Conditionally Ready** = only Minor findings remain.
**Not Ready** = one or more Critical or Major findings.

---

### 2. Findings Table

| # | Severity | Pillar | Location | Issue | Fix |
|---|---|---|---|---|---|
| 1 | 🔴 Critical | Accessibility | Login button | Contrast ratio 2.8:1 fails WCAG AA | Change button text to `--color-text-on-primary` |
| 2 | 🟡 Major | Token Compliance | Card background | Raw hex `#F5F5F5` used instead of `--surface-secondary` | Replace with `--surface-secondary` token |
| 3 | 🔵 Minor | Visual Consistency | Section headers | Spacing above H2 varies between 16px and 24px | Standardize to `spacing-6` (24px) |

---

### 3. Recommendations

After the findings table, list the **top 3 highest-impact fixes** — the ones that, if addressed, most improve the design's quality or unblock handoff. Keep each recommendation to one sentence with a clear action.

---

## Quick Reference: Common Issues

| Issue | Pillar | Likely Fix |
|---|---|---|
| Raw hex colors | Token Compliance | Map to nearest token via `toge:design-tokens` (surface, semantic family, or text token) |
| Missing hover/focus states | Interaction Readiness | Define all interactive states per component |
| Placeholder-only labels | Accessibility | Add visible `<label>` element above input |
| Inconsistent spacing | Visual Consistency | Align to 4pt/8pt grid using spacing tokens |
| Low contrast text | Accessibility | Use `text-base` or `text-strong` — check contrast via `toge:design-tokens` bridge values |
| No empty state | Interaction Readiness | Design an empty state with message + CTA |
| Mixed icon sizes | Visual Consistency | Pick one size per context and standardize |
