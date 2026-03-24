# Guide

This directory contains reference guides for AI agents working on Sprout products. Read the relevant guide before writing any UI code.

---

## Design Systems

Sprout has two design systems. They are **not interchangeable** — check which one the target project uses before writing components.

| Guide | When to use |
|---|---|
| [Toge v1 Design System](./toge-design-system-v1/README.md) | Project has `design-system-next` in `package.json` |
| [Toge v2 Design System](./toge-design-system-v2/README.md) | Project uses a `components.json` with `@toge` registry |

### How to detect which system a project uses

1. Check `package.json` — if `design-system-next` is a dependency → use the **Legacy** guide
2. Check for `components.json` with `registries["@toge"]` → use the **Toge** guide
3. If both exist, prefer Toge for new code unless the project convention says otherwise

---

## Quick Rules

- Never mix `spr-` prefixed components (Toge v1) with Toge v2 components in the same file
- Never hardcode hex colors — always use design tokens from the active system
- When in doubt about a component API, read the guide for that system before writing code
