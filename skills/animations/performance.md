# Performance

GPU compositing, transition specificity, and animation performance rules.

## Only Animate transform and opacity

These properties skip layout and paint, running on the GPU. Animating `padding`, `margin`, `height`, or `width` triggers all three rendering steps (layout → paint → composite).

| Property | GPU-compositable | Worth animating |
| --- | --- | --- |
| `transform` | Yes | Yes |
| `opacity` | Yes | Yes |
| `filter` (blur, brightness) | Yes | Yes |
| `clip-path` | Yes | Yes |
| `top`, `left`, `width`, `height` | No | Avoid |
| `background`, `border`, `color` | No | Avoid |

## Never Use `transition: all`

Always specify exact properties. `transition: all` forces the browser to watch every property and causes unexpected transitions on things you didn't intend to animate.

```css
/* Bad */
.button { transition: all 300ms; }

/* Good */
.button { transition: transform 200ms ease-out, opacity 200ms ease-out; }
```

```html
<!-- Bad -->
<button class="transition duration-150 ease-out">

<!-- Good — explicit properties -->
<button class="transition-[scale,background-color] duration-150 ease-out">
```

**Tailwind `transition-transform` note:** Maps to `transition-property: transform, translate, scale, rotate` — covers all transform-related properties. For multiple non-transform properties, use bracket syntax: `transition-[scale,opacity,filter]`.

## Use `will-change` Sparingly

`will-change` hints the browser to pre-promote an element to its own GPU layer, preventing first-frame stutter. Only add when you notice stutter — Safari benefits most.

```css
/* Good */
.animated-card { will-change: transform; }
.animated-card { will-change: transform, opacity; }

/* Bad — never will-change: all */
.animated-card { will-change: all; }

/* Bad — non-compositable properties don't benefit */
.animated-card { will-change: background-color, padding; }
```

Only valid for `transform`, `opacity`, `filter`. Never `will-change: all`. Each extra compositing layer costs memory — don't add it preemptively.

## CSS Animations Beat JS Under Load

CSS animations run off the main thread. When the browser is loading a page, JS animation libraries (`requestAnimationFrame`) drop frames. CSS animations remain smooth.

- **Use CSS** for predetermined animations
- **Use JS** for dynamic, interruptible animations (drag, gesture-based)

## Motion Library Hardware Acceleration Caveat

Applies to `motion/react` (Framer Motion) and `motion/vue` equally.

Shorthand props (`x`, `y`, `scale`) use `requestAnimationFrame` — not hardware-accelerated. For GPU acceleration, use the full `transform` string.

```jsx
// React (motion/react)

/* Bad — not GPU-accelerated */
<motion.div animate={{ x: 100 }} />

/* Good — GPU-accelerated */
<motion.div animate={{ transform: "translateX(100px)" }} />
```

```vue
<!-- Vue (motion/vue) -->

<!-- Bad — not GPU-accelerated -->
<Motion :animate="{ x: 100 }" />

<!-- Good — GPU-accelerated -->
<Motion :animate="{ transform: 'translateX(100px)' }" />
```

### When to Use Motion at All

Motion/Framer Motion is justified only for:
- Orchestrated sequences (multiple elements in relation to each other)
- Gesture-driven motion (drag, swipe)
- Physics-based spring animations

For everything else (hover states, button press, simple enter/exit), use CSS — no Motion overhead, no GPU caveat to manage. See `animations.md` for the full decision guide.

## CSS Variables Cascade Cost

Changing a CSS variable on a parent recalculates styles for all children. For animations, update `transform` directly on the element instead.

```js
// Bad — triggers recalc on all children
element.style.setProperty('--swipe-amount', `${distance}px`);

// Good — only affects this element
element.style.transform = `translateY(${distance}px)`;
```

## translateY with Percentages

`translateY(100%)` moves by the element's own height — works regardless of actual dimensions. Prefer over hardcoded pixels for exit/enter transitions.

## Blur Performance

Keep `filter: blur()` under 20px — heavy blur is expensive in Safari. Use blur to mask imperfect crossfades, but don't overdo it.
