# Surfaces

Border radius, optical alignment, shadows, image outlines, and hit areas.

## Concentric Border Radius

Outer radius = inner radius + padding. Mismatched radii on nested elements is the most common thing that makes interfaces feel off.

```
outerRadius = innerRadius + padding
```

If padding is larger than `24px`, treat the layers as separate surfaces and choose each radius independently.

```css
/* Good — concentric radii */
.card {
  border-radius: 20px; /* 12 + 8 */
  padding: 8px;
}
.card-inner {
  border-radius: 12px;
}

/* Bad — same radius on both */
.card {
  border-radius: 12px;
  padding: 8px;
}
.card-inner {
  border-radius: 12px;
}
```

```tsx
// Tailwind — outer accounts for padding
<div className="rounded-2xl p-2">       {/* 16px radius, 8px padding */}
  <div className="rounded-lg">          {/* 8px = 16 - 8 ✓ */}
    ...
  </div>
</div>
```

## Optical Alignment

When geometric centering looks off, align optically instead.

### Buttons with Text + Icon

Use slightly less padding on the icon side: `icon-side padding = text-side padding - 2px`.

```css
.button-with-icon {
  padding-left: 16px;
  padding-right: 14px; /* icon side = text side - 2px */
}
```

```tsx
// Tailwind
<button className="pl-4 pr-3.5 flex items-center gap-2">
  <span>Continue</span>
  <ArrowRightIcon />
</button>
```

### Play Button Triangles

Play icons are triangular — their geometric center is not their visual center. Shift slightly right:

```css
.play-button svg {
  margin-left: 2px;
}
```

### Asymmetric Icons

Best fixed in the SVG directly. If not possible, use a small margin:

```tsx
<span className="ml-px">
  <StarIcon />
</span>
```

## Shadows Instead of Borders

For buttons, cards, and containers using a border for depth — prefer `box-shadow`. Shadows adapt to any background with transparency; solid borders don't.

**Do not apply this to dividers** (`border-b`, `border-t`) or any border whose purpose is layout separation.

### Shadow as Border (Light Mode)

Three layers: 1px border ring, subtle lift, ambient depth.

```css
:root {
  --shadow-border:
    0px 0px 0px 1px rgba(0, 0, 0, 0.06),
    0px 1px 2px -1px rgba(0, 0, 0, 0.06),
    0px 2px 4px 0px rgba(0, 0, 0, 0.04);
  --shadow-border-hover:
    0px 0px 0px 1px rgba(0, 0, 0, 0.08),
    0px 1px 2px -1px rgba(0, 0, 0, 0.08),
    0px 2px 4px 0px rgba(0, 0, 0, 0.06);
}
```

### Shadow as Border (Dark Mode)

Simplify to a single white ring — layered depth shadows aren't visible on dark backgrounds.

```css
--shadow-border: 0 0 0 1px rgba(255, 255, 255, 0.08);
--shadow-border-hover: 0 0 0 1px rgba(255, 255, 255, 0.13);
```

### Usage with Hover Transition

```css
.card {
  box-shadow: var(--shadow-border);
  transition-property: box-shadow;
  transition-duration: 150ms;
  transition-timing-function: ease-out;
}
.card:hover {
  box-shadow: var(--shadow-border-hover);
}
```

### When to Use Shadows vs. Borders

| Use shadows | Use borders |
| --- | --- |
| Cards, containers with depth | Dividers between list items |
| Buttons with bordered styles | Table cell boundaries |
| Elevated elements (dropdowns, modals) | Form input outlines (accessibility) |
| Elements on varied backgrounds | Hairline separators in dense UI |

## Image Outlines

Add a subtle `1px` outline with low opacity to images for consistent depth.

```tsx
// Tailwind
<img
  className="outline outline-1 -outline-offset-1 outline-black/10 dark:outline-white/10"
  src={src}
  alt={alt}
/>
```

**Why `outline` instead of `border`?** Outline doesn't affect layout, and `outline-offset: -1px` keeps it inset so images stay their intended size.

## Minimum Hit Area

Interactive elements need at least **40×40px** hit area (WCAG recommends 44×44px). Extend with a pseudo-element if the visible element is smaller.

```css
.checkbox {
  position: relative;
  width: 20px;
  height: 20px;
}
.checkbox::after {
  content: "";
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 40px;
  height: 40px;
}
```

```tsx
// Tailwind
<button className="relative size-5 after:absolute after:top-1/2 after:left-1/2 after:size-10 after:-translate-1/2">
  <CheckIcon />
</button>
```

If the extended hit area overlaps another interactive element, shrink the pseudo-element — but make it as large as possible without colliding. Two interactive elements should never have overlapping hit areas.
