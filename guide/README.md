# Guide

This directory contains reference guides for AI agents working on Sprout products. Read the relevant guide before writing any UI code.

---

## Design System

This agent uses **Toge** (shadcn-vue registry). See [`toge-design-system/README.md`](./toge-design-system/README.md).

---

## Quick Rules

- Never hardcode hex colors — always use design tokens from `guide/toge-design-system/tokens/style.css`
- Do NOT call `mcp__design-system-toge__*` tools — the MCP server returns stale, incorrect data for Toge. Use the CLI installer and the installed files in `src/components/ui/` only
- When in doubt about a component API, read `guide/toge-design-system/README.md` before writing code
