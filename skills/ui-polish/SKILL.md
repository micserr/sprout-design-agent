---
name: ui-polish
description: Merged design engineering principles from Emil Kowalski and Jakub Krehel. Use when building UI components, reviewing frontend code, implementing animations, hover states, shadows, borders, typography, micro-interactions, or any visual detail work. Triggers on UI polish, "make it feel better", "feels off", stagger, border radius, optical alignment, font smoothing, tabular numbers, image outlines, shadows, scale on press.
---

# UI Polish — Design Engineering Principles

> Synthesized from Emil Kowalski (animations.dev) and Jakub Krehel (make-interfaces-feel-better).
> Great interfaces rarely come from one thing. It's the compound of invisible details.

---

## Philosophy

Most details users never consciously notice. That is the point. When a feature functions exactly as someone assumes it should, they proceed without a second thought. Beauty is underutilized in software — good defaults and good animations are real differentiators.

Good taste is a trained instinct. Develop it by studying great work, reverse-engineering animations, and asking why something feels right.

---

## Quick Reference

| Category | When to Use |
| --- | --- |
| [Typography](typography.md) | Text wrapping, font smoothing, tabular numbers |
| [Surfaces](surfaces.md) | Border radius, optical alignment, shadows, image outlines, hit areas |
| [Animations](animations.md) | Animation decisions, easing, duration, enter/exit, icon animations, scale on press, springs |
| [Performance](performance.md) | GPU-compositable properties, transition specificity, `will-change` usage |

---

## Common Mistakes

| Issue | Fix |
|---|---|
| Same border radius on parent and child | `outerRadius = innerRadius + padding` |
| Icons look off-center | Align optically, not geometrically |
| Hard borders between sections | Layered `box-shadow` with transparency |
| `transition: all` | Specify exact properties |
| `scale(0)` entry | Start from `scale(0.95)` + `opacity: 0` |
| `ease-in` on UI element | Switch to `ease-out` or custom curve |
| Duration > 300ms on UI | Reduce to 150–250ms |
| Same enter/exit speed | Make exit faster |
| Elements all appear at once | Stagger ~100ms between groups |
| Animation on keyboard action | Remove entirely |
| Hover without media query | Add `@media (hover: hover) and (pointer: fine)` |
| Numbers cause layout shift | `font-variant-numeric: tabular-nums` |
| Heavy text on macOS | `-webkit-font-smoothing: antialiased` |
| Heading wraps awkwardly | `text-wrap: balance` |
| Tiny hit area on small control | Pseudo-element to 40×40px |
| Images look flat | `outline: 1px solid rgba(0,0,0,0.06)` |
| Framer Motion `x`/`y` under load | Use `transform: "translateX()"` |
| `transform-origin: center` on popover | Set to trigger origin (modals exempt) |
| Animation on page load | `initial={false}` on `AnimatePresence` |
