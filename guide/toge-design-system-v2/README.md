# Toge v2 Design System

## Overview

Toge v2 is the Vue 3 design system for **Prometheus Tower** products at Sprout. It builds on [shadcn-vue](https://www.shadcn-vue.com/) primitives with Sprout branding and tokens, and delivers components via a **shadcn-vue registry** hosted on Azure. Instead of installing a central npm package, components are pulled directly into your project — you own the source and can customize it.

This is the current workflow. Use it for new Prometheus Tower projects.

---

## How It's Different from Toge v1

| | Toge v1 | Toge v2 |
|---|---|---|
| **Delivery** | npm package (`design-system-next`) | CLI registry pull |
| **Components** | Pre-built, locked in node_modules | Copied into your project |
| **Customization** | Via props and tokens only | Edit the source files directly |
| **Updates** | `npm update` | Re-pull component from registry |
| **Ownership** | Centrally managed | You own the code |

---

## Installation

### Quick install (recommended)

Run this from your consumer project root — no cloning required:

```bash
curl -fsSL https://toge-ds.azurewebsites.net/install.mjs -o /tmp/toge-install.mjs && node /tmp/toge-install.mjs
```

The CLI handles everything automatically:
1. Detects if `components.json` exists; runs `npx shadcn-vue@latest init` if not
2. Patches `tsconfig.json` and `vite.config.ts` with the `@/*` path alias
3. Injects the `@toge` registry entry into `components.json`
4. Shows a numbered menu of component groups to install
5. Prompts whether to overwrite existing files

**Group menu example:**
```
  1. Base UI      (56 components)
  2. Fintech      (1 component)
  3. Sidekick     (2 components)
  0. Exit
```

Enter one or more numbers (e.g. `1,2`). For the overwrite prompt, answer **N** on first install and **y** when updating.

---

### Install a single component

```bash
npx shadcn-vue@latest add https://toge-ds.azurewebsites.net/r/ui/toge-button.json
```

Replace `ui/toge-button` with any slug from the component list below. All `registryDependencies` resolve automatically.

---

### Manual setup (without CLI)

**1. Add the `@toge` registry to `components.json`:**
```json
{
  "registries": {
    "@toge": {
      "url": "https://toge-ds.azurewebsites.net/r/{name}.json"
    }
  }
}
```

**2. Add path aliases to `tsconfig.json` / `tsconfig.app.json`:**
```json
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": { "@/*": ["./src/*"] }
  }
}
```

**3. Add path alias to `vite.config.ts`:**
```ts
import path from 'node:path'

export default defineConfig({
  resolve: {
    alias: { '@': path.resolve(__dirname, './src') },
  },
})
```

**4. Install a component:**
```bash
npx shadcn-vue@latest add https://toge-ds.azurewebsites.net/r/ui/toge-button.json
```

---

## Using Components

After adding a component, import and use it like any local Vue component:

```vue
<script setup>
import { TogeButton } from '@/components/ui/toge-button'
</script>

<template>
  <TogeButton variant="primary">Save</TogeButton>
</template>
```

Components land in `src/components/ui/{component-name}/`. Since the source lives in your project, you can open and modify it freely.

---

## Installing / Updating Styles

The Sprout token theme (`src/style.css`) installs automatically with any component. To install it standalone:

```bash
npx shadcn-vue@latest add https://toge-ds.azurewebsites.net/r/ui/toge-styles.json
```

`toge-styles` writes:
- Google Fonts (Rubik, Rethink Sans)
- Tailwind CSS v4 theme with Sprout color primitives (mushroom, kangkong, tomato, etc.)
- Semantic token mappings (`--brand`, `--surface-white`, `--border-weak`, etc.)
- Light and dark mode CSS variables

After install, confirm `src/style.css` is imported in your app entry:
```ts
// src/main.ts
import './style.css'
```

---

## Updating Components

Run the CLI and answer **y** to the overwrite prompt, or update a single component directly:

```bash
npx shadcn-vue@latest add --overwrite https://toge-ds.azurewebsites.net/r/ui/toge-button.json
```

> If you've customized a component locally, back up your changes before overwriting.

---

## Available Components

**Registry base URL:** `https://toge-ds.azurewebsites.net/r`

### Base UI — 55 components + styles

| Component | Slug |
|---|---|
| Accordion | `ui/toge-accordion` |
| Alert | `ui/toge-alert` |
| Alert Dialog | `ui/toge-alert-dialog` |
| Avatar | `ui/toge-avatar` |
| Badge | `ui/toge-badge` |
| Breadcrumb | `ui/toge-breadcrumb` |
| Button | `ui/toge-button` |
| Button Group | `ui/toge-button-group` |
| Calendar | `ui/toge-calendar` |
| Card | `ui/toge-card` |
| Carousel | `ui/toge-carousel` |
| Checkbox | `ui/toge-checkbox` |
| Collapsible | `ui/toge-collapsible` |
| Combobox | `ui/toge-combobox` |
| Command | `ui/toge-command` |
| Context Menu | `ui/toge-context-menu` |
| Data Table | `ui/toge-data-table` |
| Date Picker | `ui/toge-date-picker` |
| Dialog | `ui/toge-dialog` |
| Drawer | `ui/toge-drawer` |
| Dropdown Menu | `ui/toge-dropdown-menu` |
| Form | `ui/toge-form` |
| Hover Card | `ui/toge-hover-card` |
| Input | `ui/toge-input` |
| Input Group | `ui/toge-input-group` |
| Label | `ui/toge-label` |
| Menubar | `ui/toge-menubar` |
| Native Select | `ui/toge-native-select` |
| Navigation Menu | `ui/toge-navigation-menu` |
| Number Field | `ui/toge-number-field` |
| Pagination | `ui/toge-pagination` |
| Pin Input | `ui/toge-pin-input` |
| Popover | `ui/toge-popover` |
| Progress | `ui/toge-progress` |
| Radio Group | `ui/toge-radio-group` |
| Range Calendar | `ui/toge-range-calendar` |
| Resizable | `ui/toge-resizable` |
| Scroll Area | `ui/toge-scroll-area` |
| Select | `ui/toge-select` |
| Separator | `ui/toge-separator` |
| Sheet | `ui/toge-sheet` |
| Sidebar | `ui/toge-sidebar` |
| Skeleton | `ui/toge-skeleton` |
| Slider | `ui/toge-slider` |
| Sonner (Toast) | `ui/toge-sonner` |
| Stepper | `ui/toge-stepper` |
| Switch | `ui/toge-switch` |
| Table | `ui/toge-table` |
| Tabs | `ui/toge-tabs` |
| Tags Input | `ui/toge-tags-input` |
| Textarea | `ui/toge-textarea` |
| Toggle | `ui/toge-toggle` |
| Toggle Group | `ui/toge-toggle-group` |
| Tooltip | `ui/toge-tooltip` |
| Styles (theme) | `ui/toge-styles` |

### Fintech — 1 component

| Component | Slug |
|---|---|
| ReadyWage Card | `fintech/readywage-card` |

### Sidekick — 2 components

| Component | Slug |
|---|---|
| Sidekick Central Card | `sidekick/sidekick-central-card` |
| Sidekick Chat | `sidekick/sidekick-chat` |

---

## Troubleshooting

| Error | Cause | Fix |
|---|---|---|
| CLI runs but prints nothing | `node <(curl ...)` disconnects stdin | Use the download-then-run command above |
| `Cannot find module '@/components/...'` | Missing `@/*` alias | The CLI patches this. For manual setup, add alias to `tsconfig.json` and `vite.config.ts` |
| Component renders without Sprout styling | `toge-styles` not installed or not imported | Run the styles install; verify `import './style.css'` in `src/main.ts` |
| Token classes have no effect (`bg-brand` etc.) | Tailwind not scanning component files | Ensure content config includes `./src/**/*.{vue,ts}` |
| `@toge` registry not found | `components.json` missing registry entry | The CLI adds this automatically; for manual setup see above |
| `The resource you are looking for has been removed` | `install.mjs` not yet deployed to Azure | Wait for next deploy or contact Toge DS maintainers |

---

## Notes for AI Agents

1. **Always run from the consumer project root** — not from inside `toge-ds-components`
2. **The CLI handles all setup** — do not manually edit `components.json`, `tsconfig.json`, or `vite.config.ts` before running the installer
3. **Registry base URL:** `https://toge-ds.azurewebsites.net/r`
4. **Component URL pattern:** `{REGISTRY_BASE}/{namespace}/{slug}.json`
5. **`toge-styles` auto-installs** as a dependency of every component — no need to install it separately
6. **Namespace → team mapping:** `ui/` → Base primitives · `fintech/` → Fintech blocks · `sidekick/` → Sidekick AI blocks

For existing projects already on `design-system-next`, see [`../toge-design-system-v1/README.md`](../toge-design-system-v1/README.md).
