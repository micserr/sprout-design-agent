# Sprout Legacy Design System

## Overview

The Sprout Legacy Design System is consumed via the **`design-system-next`** npm package. It ships a complete set of pre-built Vue 3 components (65+), design tokens, and Tailwind utilities. Everything is centrally managed — you install, import, and use. You do not own or modify the source files.

This is the older workflow. Most existing Sprout products use this system.

---

## Installation

> Full docs: https://design.sprout.ph/en/guide/basics/installation.html

`design-system-next` is a **private package hosted on Azure Artifacts**. Authentication is required before installing.

### Step 1 — Connect to Azure Artifacts

Follow the connect guide to authenticate your environment:
https://dev.azure.com/sproutphil/Sprout%20Design%20System/_artifacts/feed/Design-System-Next/connect

### Step 2 — Install

```bash
npm install design-system-next
```

> A public version exists on npmjs.com but may lag behind the Azure Artifacts version. Use Azure Artifacts for production.

---

## Setup

Register the plugin in `main.ts`:

```ts
import { createApp } from 'vue'
import { createPinia } from 'pinia'
import SproutDesignSystem from 'design-system-next'
import 'design-system-next/style.css'
import App from './App.vue'

const app = createApp(App)
app.use(createPinia())       // Required — snackbar uses a Pinia store
app.use(SproutDesignSystem)  // Registers all components with spr- prefix
app.mount('#app')
```

> Pinia must be registered **before** SproutDesignSystem. The CSS import is required for styling to work.

---

## Usage

All components auto-register with the `spr-` prefix. No imports needed in templates.

```vue
<template>
  <spr-button tone="success">Save</spr-button>
  <spr-input v-model="name" label="Full Name" />
  <spr-modal v-model:show="showModal" title="Confirm">...</spr-modal>
</template>
```

### TypeScript types

```ts
import type { ButtonPropTypes, InputPropTypes } from 'design-system-next'
```

---

## Design Tokens

The design system exposes a `spr-` Tailwind prefix for design tokens. Use `spr-` only for tokens — use standard Tailwind for everything else.

| Use case | Correct class | Wrong |
|---|---|---|
| Text color | `spr-text-color-base` | `text-gray-900` or `text-[#262B2B]` |
| Background | `spr-background-color-hover` | `bg-gray-100` |
| Border color | `spr-border-color-base` | `border-gray-200` |
| Border radius | `spr-rounded-border-radius-md` | `rounded-md` |
| Typography | `spr-heading-md`, `spr-body-sm-regular` | custom font classes |
| Layout/spacing | `flex`, `p-4`, `gap-3`, `w-full` | — (standard Tailwind is correct here) |

---

## Icons

Uses `@iconify/vue` with the Phosphor icon set (`ph:` prefix):

```vue
<script setup>
import { Icon } from '@iconify/vue'
</script>

<template>
  <Icon icon="ph:pencil" />
  <spr-button hasIcon>
    <Icon icon="ph:plus" />
    Add Item
  </spr-button>
</template>
```

Browse icons: https://icon-sets.iconify.design/ph/

---

## When to Use This

- The project is already using `design-system-next`
- The team has not yet migrated to the Toge registry workflow
- You need the full component library without any setup overhead

For new projects or teams starting fresh, see [`../toge-design-system/README.md`](../toge-design-system/README.md).
