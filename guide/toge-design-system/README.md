# Toge Design System

## Overview

Toge is the Vue 3 design system for **Prometheus Tower** products at Sprout. It builds on [shadcn-vue](https://www.shadcn-vue.com/) primitives with Sprout branding and tokens, and delivers components via a **shadcn-vue registry** hosted on Azure. Instead of installing a central npm package, components are pulled directly into your project — you own the source and can customize it.

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

> Each row says **what the component is and when to pick it over its closest sibling** — read this before selecting a primitive. Install with `npx shadcn-vue@latest add {REGISTRY_BASE}/{slug}.json`. The installed `.vue` source is the authoritative API (props/slots/events) — read it before writing code.

### Base UI — 68 components

| Component | Slug | What it is · when to use |
|---|---|---|
| Accordion | `ui/toge-accordion` | Vertically stacked sections that expand/collapse (typically one open at a time) to organize long content into scannable groups. For a single show/hide region use toge-collapsible. |
| Agent Banner | `ui/toge-agent-banner` | Banner with a glowing halo styled for AI/agent surfaces, with label, title, and description slots. For a standard inline notice use toge-alert. |
| Alert | `ui/toge-alert` | Inline, static banner that calls out a message in context (info, success, warning, error) and stays until removed. For transient pop-up notifications use toge-sonner; for AI/agent surfaces use toge-agent-banner. |
| Alert Dialog | `ui/toge-alert-dialog` | Modal confirmation for destructive or high-stakes actions — interrupts with a title, description, and confirm/cancel buttons, and traps focus until the user decides. For general content or forms use toge-dialog. |
| Aspect Ratio | `ui/toge-aspect-ratio` | Locks a child (image, video, embed) to a fixed width:height ratio so it scales responsively without layout shift. |
| Avatar | `ui/toge-avatar` | User/entity image with an initials fallback and an optional status dot. Sizes for inline rows up to profile headers. |
| Badge | `ui/toge-badge` | Small inline chip for status, counts, or labels next to other content (status badges use the outline variant). For dismissible value chips in an input use toge-tags-input. |
| Breadcrumb | `ui/toge-breadcrumb` | Shows the user’s location in a hierarchy as a trail of links back to ancestors. For switching between sibling views use toge-tabs; for primary navigation use toge-navigation-menu. |
| Button | `ui/toge-button` | The clickable trigger for actions and submissions, with variants (primary, secondary, ghost…) and sizes. To visually join several related buttons use toge-button-group; for switching views use toge-tabs. |
| Button Group | `ui/toge-button-group` | Visually joins a set of related action buttons into one segmented control (e.g. a split button or connected toolbar). To switch content views use toge-tabs; to select a value use toge-toggle-group. |
| Calendar | `ui/toge-calendar` | Always-visible inline month grid for selecting a single date. For a compact trigger+popover use toge-date-picker; for a start–end range use toge-range-calendar. |
| Card | `ui/toge-card` | Container that groups related content and actions into a bordered, padded surface with header/content/footer slots. A layout primitive — not interactive on its own. |
| Carousel | `ui/toge-carousel` | Horizontally scrollable, swipeable set of slides with prev/next controls. For static stacked content use a group of toge-card. |
| Chat | `ui/toge-chat` | Message-thread surface for conversational/AI interfaces, rendering user and assistant messages with markdown. Pair with toge-chat-input to compose and toge-chat-thought-process to show agent reasoning. |
| Chat Input | `ui/toge-chat-input` | Composer for chat/AI surfaces — multi-line message entry with a send affordance. Pairs with toge-chat. |
| Chat Thought Process | `ui/toge-chat-thought-process` | Displays an AI agent’s reasoning as a sequence of steps (plan, tool call, observation, answer) with connecting lines. Pairs with toge-chat. |
| Checkbox | `ui/toge-checkbox` | Single binary control — a standalone yes/no, or a row in a multi-select list. For an instant on/off setting use toge-switch; for mutually-exclusive choices use toge-radio-group. |
| Choicebox | `ui/toge-choicebox` | Grid of selectable cards (single- or multi-select) where each option shows a label and description — a richer alternative to plain radios/checkboxes. For plain options use toge-radio-group (single) or toge-checkbox (multiple). |
| Collapsible | `ui/toge-collapsible` | A single region that toggles between shown and hidden. For multiple coordinated sections use toge-accordion. |
| Combobox | `ui/toge-combobox` | Searchable select — a text input plus a filterable dropdown for typeahead picking from 10+ or async options. For short static lists use toge-select; for a ⌘K palette use toge-command; for free-text multi-value use toge-tags-input. |
| Command | `ui/toge-command` | Searchable command palette (⌘K) with groups, shortcuts, and instant filtering for app-level navigation and actions. To pick a value into a field use toge-combobox; for in-page list filtering use toge-search-input. |
| Context Menu | `ui/toge-context-menu` | Menu of actions that opens on right-click (or long-press) of a target element. For a button-triggered menu use toge-dropdown-menu. |
| Data Table | `ui/toge-data-table` | Feature-rich table built on @tanstack/vue-table with sorting, filtering, pagination, row selection, and column controls. Use only when those interactions are needed; for simple static data use toge-table. |
| Date Picker | `ui/toge-date-picker` | Trigger + calendar popover for picking a single date (or a start–end pair). Pair with toge-time-picker for date+time. For an always-visible inline grid use toge-calendar. |
| Dialog | `ui/toge-dialog` | Modal dialog for focused tasks, forms, or content shown over the page. For destructive or yes/no confirmations use toge-alert-dialog; for edge-anchored side panels use toge-sheet or toge-drawer. |
| Drawer | `ui/toge-drawer` | Touch-first drawer (built on vaul) that slides in from a screen edge — bottom by default, also top/left/right — with a drag handle, snap points, and a scaled-back page behind it. For a plain desktop edge panel use toge-sheet; for a centered modal use toge-dialog. |
| Dropdown Menu | `ui/toge-dropdown-menu` | Menu of actions that opens from a button/trigger on click. For a right-click menu use toge-context-menu; for an app menu bar use toge-menubar; for selecting a form value use toge-select. |
| Email Input | `ui/toge-email-input` | Email-typed field (inputmode=email) with optional format validation on blur. For arbitrary text use toge-input; for schema-driven validation wrap the field with toge-form. |
| File Upload | `ui/toge-file-upload` | Drag-and-drop or click-to-browse file picker with per-item progress, status, and remove. For a tiny “choose file” affordance with no list, wrap a hidden <input type=file> in a toge-button. |
| Floating Action | `ui/toge-floating-action` | Floating action region docked to a screen edge that slides in/out, for a persistent primary action or contextual prompt. For inline page actions use toge-button. |
| Form | `ui/toge-form` | vee-validate composition for multi-field forms (TogeForm + TogeFormField + Item/Label/Control/Description/Message) that wires validation, aria-invalid, and error copy automatically. For one or two fields, use individual inputs with their built-in validate props. |
| Hover Card | `ui/toge-hover-card` | Hover-triggered floating card that previews the hovered element (e.g. a profile or link peek). For click-triggered interactive content use toge-popover; for short text hints use toge-tooltip. |
| Input | `ui/toge-input` | Single-line text field — the workhorse for short free-form input (name, title, short note). For multi-line use toge-textarea; for typed values use toge-email-input, toge-url-input, toge-search-input, toge-phone-number-input, or toge-number-field. |
| Input Group | `ui/toge-input-group` | Composes a toge-input with leading/trailing addons — icons, prefix/suffix text, or inline buttons — inside one bordered shell. For a standalone field with no addons use toge-input. |
| Label | `ui/toge-label` | Accessible <label> linked to a field via for — clicking it focuses the field and screen readers announce it as the field’s name. For helper text use a plain paragraph; for a section heading use a heading class. |
| Menubar | `ui/toge-menubar` | Horizontal application menu bar with cascading menus (File, Edit, View…). For a single button-triggered menu use toge-dropdown-menu; for a right-click menu use toge-context-menu. |
| Native Select | `ui/toge-native-select` | Browser-native <select> styled to match the Toge field family — uses the OS picker on mobile. For a custom popover with rich rendering use toge-select; for typeahead search use toge-combobox. |
| Navigation Menu | `ui/toge-navigation-menu` | Top-level site/app navigation with optional flyout panels of links. For the location trail use toge-breadcrumb; for an app-style menu bar use toge-menubar; for a side rail use toge-sidebar. |
| Number Field | `ui/toge-number-field` | Numeric input with increment/decrement steppers, min/max clamping, and arrow-key support, for bounded values. For unbounded or formatted numbers (currency, IDs) use toge-input; for fixed-length codes use toge-pin-input. |
| Pagination | `ui/toge-pagination` | Page-navigation controls (prev/next and page numbers) for splitting a long list across pages. To append more rows inline, use a load-more button instead. |
| Phone Number Input | `ui/toge-phone-number-input` | Phone field with an inline country-code picker and digits-only filtering on the local number. For a domestic-only field with no country picker, use toge-input with inputmode=tel. |
| Pin Input | `ui/toge-pin-input` | Multi-cell input for short fixed-length codes (OTP, 2FA, PIN) with auto-advance and paste. For an arbitrary numeric value use toge-number-field; for free-form text use toge-input. |
| Popover | `ui/toge-popover` | Click-triggered floating panel anchored to a trigger, for rich interactive content like mini-forms, menus, or pickers. For hover-only previews use toge-hover-card; for short text hints use toge-tooltip; for a centered modal use toge-dialog. |
| Progress | `ui/toge-progress` | Determinate horizontal bar showing completion of a known-length task (upload, multi-step save). For unknown-duration loading use toge-skeleton; for step-by-step flows use toge-stepper. |
| Radio Group | `ui/toge-radio-group` | Mutually-exclusive options shown all at once — pick one of 2–5. For 6+ options or tight space use toge-select; for independent on/off choices use toge-checkbox (multiple) or toge-switch (single setting). |
| Range Calendar | `ui/toge-range-calendar` | Always-visible inline month grid for selecting a start–end date range. For a single date use toge-calendar; for a compact trigger+popover use toge-date-picker. |
| Resizable | `ui/toge-resizable` | Split-pane layout with draggable handles to resize adjacent regions. For a static divider use toge-separator. |
| Scroll Area | `ui/toge-scroll-area` | Container with a styled, self-hiding custom scrollbar for overflowing content. (For ad-hoc scroll regions, the .toge-scrollbar utility class is the lighter option.) |
| Search Input | `ui/toge-search-input` | Text field styled for live, in-page search — leading magnifier icon and a clear button. For a global ⌘K menu use toge-command; for type-ahead picking from options use toge-combobox. |
| Select | `ui/toge-select` | Dropdown for choosing one option from a static, mid-sized list (~3–25). For 2–4 visible options use toge-radio-group; for long searchable lists use toge-combobox; for native/mobile rendering use toge-native-select. |
| Separator | `ui/toge-separator` | Thin divider line (horizontal or vertical) that visually groups content. For draggable split panes use toge-resizable. |
| Sheet | `ui/toge-sheet` | Panel that slides in from a screen edge (top/right/bottom/left) for secondary tasks, filters, or detail without leaving the page. For a centered modal use toge-dialog; for a touch-first bottom sheet use toge-drawer. |
| Sidebar | `ui/toge-sidebar` | Full application navigation sidebar — collapsible icon rail, nav groups, quick actions, user menu, and a mobile drawer. The app shell’s primary navigation; for top-bar nav use toge-navigation-menu. |
| Skeleton | `ui/toge-skeleton` | Placeholder shapes shown while content loads, to reduce layout shift and perceived wait. For measurable progress use toge-progress. |
| Slider | `ui/toge-slider` | Drag-to-set control for choosing a number (or range) along a continuous track. For typed bounded numbers use toge-number-field. |
| Sonner | `ui/toge-sonner` | Transient toast notifications that stack in a corner and auto-dismiss (built on vue-sonner), with success/info/warning/error styles. For a persistent inline message use toge-alert. |
| Stacked Sheet | `ui/toge-stacked-sheet` | Sheet that stacks multiple layers, opening one panel over another while keeping prior context visible — for side panels with sub-navigation or drill-down. For a single panel use toge-sheet. |
| Stepper | `ui/toge-stepper` | Step indicator for multi-step flows/wizards, showing completed, current, and upcoming steps. For simple task completion use toge-progress. |
| Switch | `ui/toge-switch` | On/off boolean control for a setting that applies immediately (e.g. enable notifications). For a pressable two-state action button use toge-toggle; to pick among several options use toge-radio-group or toge-toggle-group. |
| Table | `ui/toge-table` | Static, presentational table for rendering rows and columns of data — the default table for most uses. For sorting, filtering, pagination, row selection, or column visibility, use toge-data-table. |
| Tabs | `ui/toge-tabs` | Switches between mutually exclusive views or panels in the same context, showing one panel at a time. To select a value or toggle options (not swap views) use toge-toggle-group; to group related action buttons use toge-button-group. |
| Tags Input | `ui/toge-tags-input` | Free-form multi-value entry where each token becomes a removable chip (emails, keywords, labels). For multi-select from a known list use toge-combobox; for a single value use toge-input. |
| Textarea | `ui/toge-textarea` | Auto-growing multi-line text field for descriptions, notes, and comments; optionally pairs with a markdown-style toolbar. For one line use toge-input; for a full rich-text editor integrate Tiptap or ProseMirror. |
| Time Picker | `ui/toge-time-picker` | Segmented time field (HH MM AM/PM) with an optional dropdown of preset times. Pair with toge-date-picker for a date+time value. |
| Toggle | `ui/toge-toggle` | Single two-state on/off button (pressed/unpressed) for toolbar-style actions like bold or mute. For a set of options use toge-toggle-group; for an on/off form setting use toge-switch. |
| Toggle Group | `ui/toge-toggle-group` | Set of toggle buttons for single- or multi-select among options (e.g. text alignment, view density). For one standalone toggle use toge-toggle; to swap views use toge-tabs; for a labeled boolean form field use toge-switch. |
| Tooltip | `ui/toge-tooltip` | Small text label revealed on hover/focus to describe a control or icon. For interactive content use toge-popover; for richer hover previews use toge-hover-card. |
| Url Input | `ui/toge-url-input` | URL field with a non-interactive protocol prefix (http:// by default) and optional URL-shape validation. For free-form text use toge-input. |

### Fintech — 1 component(s)

| Component | Slug | What it is · when to use |
|---|---|---|
| ReadyWage Card | `fintech/readywage-card` | A card component for displaying ReadyWage information. |

### Platform — 1 component(s)

| Component | Slug | What it is · when to use |
|---|---|---|
| Global Search | `platform/global-search` | Centered command-palette / spotlight search for the app shell. Composes TogeDialog + TogeCommand with an autofocused filter input, sliders trigger, scrollable results slot, keyboard-hint footer, and a built-in ⌘K shortcut. Launch it from the sidebar Search button. |

### Sidekick — 3 component(s)

| Component | Slug | What it is · when to use |
|---|---|---|
| Sidekick Banner | `sidekick/sidekick-banner` | Soft-gradient banner themed for Sidekick AI surfaces. Renders a title, optional close button, and markdown body via TogeChatMarkdown. |
| Sidekick Central Card | `sidekick/sidekick-central-card` | A card showcasing Sidekick Central — an AI assistant suite for Filipino businesses covering HR, Payroll, Managers, and Employees. |
| Sidekick Chat | `sidekick/sidekick-chat` | Sidekick Chat component. |

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
