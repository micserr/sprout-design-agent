# Toge Design System

## Overview

The Toge Design System uses a **component registry** workflow powered by shadcn-vue. Instead of installing a central npm package, you pull individual components directly into your project via CLI. The component source code lives in your repo — you own it, you can read it, and you can customize it.

This is the new workflow. Use this for new projects or when migrating away from the legacy npm-based system.

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

## Project Setup

### 1. Initialize shadcn-vue

If the project doesn't have a `components.json` yet:

```bash
npx shadcn-vue@latest init
```

### 2. Register the Toge registry

Add the `@toge` registry to `components.json`:

```json
{
  "$schema": "https://shadcn-vue.com/schema.json",
  "style": "new-york",
  "typescript": false,
  "tailwind": {
    "config": "",
    "css": "src/style.css",
    "baseColor": "neutral",
    "cssVariables": true,
    "prefix": ""
  },
  "aliases": {
    "components": "@/components",
    "utils": "@/lib/utils",
    "ui": "@/components/ui",
    "lib": "@/lib",
    "composables": "@/composables"
  },
  "registries": {
    "@toge": {
      "url": "https://toge-ds.azurewebsites.net/r/{name}.json"
    }
  }
}
```

> Run this command from the directory where `components.json` lives.

---

## Adding Components

Pull any Toge component into your project:

```bash
npx shadcn-vue@latest add @toge/ui/toge-badge
npx shadcn-vue@latest add @toge/ui/toge-button
npx shadcn-vue@latest add @toge/ui/toge-input
```

The component files are written into your project under the path specified in `aliases.ui` (default: `src/components/ui/`).

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

Since the source lives in your project, you can open and modify it freely.

---

## Updating a Component

To get the latest version of a component from the registry, re-run the add command:

```bash
npx shadcn-vue@latest add @toge/ui/toge-badge
```

> This overwrites your local copy. If you've customized the file, back up your changes first.

---

## When to Use This

- Starting a new project
- The team has migrated to the Toge workflow
- You need to customize component internals beyond what props allow
- You want zero runtime dependency on a shared npm package

For existing projects already on `design-system-next`, see [`../toge-design-system-v1/README.md`](../toge-design-system-v1/README.md).
