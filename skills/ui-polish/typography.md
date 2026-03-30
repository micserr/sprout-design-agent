# Typography

Typography rendering details that make interfaces feel better.

## Font Smoothing (macOS)

On macOS, text renders heavier than intended by default. Apply antialiased smoothing to the root layout so all text renders crisper and thinner.

```css
html {
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
```

```tsx
// Tailwind — apply to root layout
<html className="antialiased">
```

Apply once at the root — not per-element. Other platforms ignore these properties, so it's safe to apply universally.

## Text Wrapping

### text-wrap: balance

Distributes text evenly across lines, preventing orphaned words. **Only works on 6 lines or fewer** (Chromium) or 10 lines or fewer (Firefox) — the balancing algorithm is expensive.

```css
h1, h2, h3 {
  text-wrap: balance;
}
```

**Tailwind:** `text-balance`

### text-wrap: pretty

Optimizes the last line to avoid orphans using a slower algorithm. Works on longer text — use for body copy.

```css
p {
  text-wrap: pretty;
}
```

### When to Use Which

| Scenario | Use |
| --- | --- |
| Headings, titles, short text (≤6 lines) | `text-wrap: balance` |
| Body paragraphs, descriptions | `text-wrap: pretty` |
| Code blocks, pre-formatted text | Neither — leave default |

## Tabular Numbers

Use `font-variant-numeric: tabular-nums` for any dynamically updating numbers to prevent layout shift as digits change width.

```css
.counter, .price, .timer {
  font-variant-numeric: tabular-nums;
}
```

```tsx
// Tailwind
<span className="tabular-nums">{count}</span>
```

### When to Use

| Use tabular-nums | Don't use tabular-nums |
| --- | --- |
| Counters and timers | Static display numbers |
| Prices that update | Decorative large numbers |
| Table columns with numbers | Phone numbers, zip codes |
| Animated number transitions | Version numbers (v2.1.0) |
| Scoreboards, dashboards | |

### Caveat

Some fonts (like Inter) change the visual appearance of numerals with this property — the digit `1` becomes wider and centered. This is expected and usually desirable, but verify it looks right in your specific font.
