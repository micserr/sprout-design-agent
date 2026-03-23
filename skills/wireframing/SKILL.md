---
name: toge:wireframing
description: >
  Use when creating wireframes, sketching page layouts, designing information architecture,
  or structuring screens. Trigger phrases: "wireframe", "sketch a layout", "design a screen",
  "information architecture", "IA", "page layout", "sketch this page".
---

## Overview

This skill produces Vue 3 SFC wireframes using shadcn-vue components and Tailwind CSS. Each wireframe is a `.vue` file that can be dropped into any Vue 3 + shadcn-vue project. Templates use a strict grayscale palette to maintain wireframe aesthetics.

**Requirements:** Target project must have Vue 3, Tailwind CSS, and shadcn-vue installed.

## Template Selection Guide

Choose the right template based on the design context:

| Template | Use when... | File |
|---|---|---|
| `dashboard.vue` | Primary overview page, data-heavy, multiple metrics or summaries | `templates/dashboard.vue` |
| `list-detail.vue` | Browsable list of items with a detail/preview panel | `templates/list-detail.vue` |
| `form-page.vue` | Data entry, settings, configuration, multi-field input | `templates/form-page.vue` |
| `onboarding-wizard.vue` | Multi-step flows, setup sequences, guided processes | `templates/onboarding-wizard.vue` |
| `landing-page.vue` | Marketing pages, entry points, feature showcases | `templates/landing-page.vue` |
| `settings-page.vue` | Account preferences, app configuration, sectioned options | `templates/settings-page.vue` |

## How to Generate a Wireframe

Process:
1. Read the design context (product brief, user journey, or screen description)
2. Pick the closest template from the table above
3. Read the template file from `skills/wireframing/templates/`
4. Modify the Vue template to match the specific screen:
   - Update placeholder labels ("MAIN CONTENT" → actual section names)
   - Add/remove structural sections as needed
   - Keep all Tailwind classes grayscale
5. Save the output as `wireframe-[screen-name].vue` in the project's `src/views/` or `src/pages/` directory (or a `wireframes/` subfolder if the user prefers)
6. Tell the user: "Add `wireframe-[screen-name].vue` to your Vue project and open it via your dev server."

## shadcn-vue Component Reference

Always use grayscale. Never use color classes in wireframes.

| Wireframe element | shadcn-vue component |
|---|---|
| Cards / panels | `Card`, `CardHeader`, `CardContent`, `CardFooter` |
| Buttons | `Button` (variant: `default`, `outline`, `ghost`) |
| Text inputs | `Input` |
| Textarea | `Textarea` |
| Select dropdown | `Select`, `SelectTrigger`, `SelectContent`, `SelectItem` |
| Checkboxes | `Checkbox` + `Label` |
| Data table | `Table`, `TableHeader`, `TableBody`, `TableRow`, `TableHead`, `TableCell` |
| Badges / tags | `Badge` |
| Form labels + helpers | `Label` |
| Separators | `Separator` |
| Avatar placeholder | `Avatar`, `AvatarFallback` |
| Nav bar | Manual `<nav>` with Tailwind (no shadcn equivalent) |
| Step indicator | Manual circles with `:class` binding (no shadcn wizard) |

Placeholder text conventions:
- Use ALL CAPS for structural regions: "NAVIGATION", "MAIN CONTENT", "FEATURE TITLE"
- Use descriptive dummy values for data: "USER NAME", "FIELD VALUE", "CATEGORY"
- Minimal reactive state only — `ref()` for selected item, active step, active nav section

## Multiple Screens

If the user needs multiple screens (e.g., a full flow), generate one file per screen and number them: `wireframe-01-onboarding.vue`, `wireframe-02-dashboard.vue`, etc.
