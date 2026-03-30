# Animations

Animation decisions, easing, duration, enter/exit patterns, and component-level micro-interactions.

## When to Use Motion vs CSS

Use CSS transitions/animations by default. Only reach for Motion/Framer Motion when the interaction requires:
- **Orchestrated sequences** — multiple elements animating in relation to each other
- **Gesture-driven motion** — drag, swipe, follow cursor
- **Physics-based spring animations** — momentum, bounce, interruption with velocity

For everything else — hover states, button press, simple enter/exit — CSS is sufficient and faster.

When Motion is justified, prefer `style={{ transform }}` over shorthand props (`x`, `y`, `scale`) to stay GPU-accelerated. See `performance.md` for details.

## Should This Animate at All?

| Frequency | Decision |
|---|---|
| 100+ times/day (keyboard shortcuts, command palette) | **No animation. Ever.** |
| Tens of times/day (hover effects, list navigation) | Remove or drastically reduce |
| Occasional (modals, drawers, toasts) | Standard animation |
| Rare / first-time (onboarding, celebrations) | Can add delight |

**Never animate keyboard-initiated actions.** Raycast has no open/close animation — that is the optimal experience for something used hundreds of times a day.

## Every Animation Must Have a Purpose

Valid purposes:
- **Spatial consistency** — toast enters/exits from the same direction
- **State indication** — a morphing button shows the change
- **Feedback** — button scales on press, confirming the interface heard you
- **Preventing jarring changes** — elements appearing without transition feel broken

If the purpose is "it looks cool" and users see it often — don't animate.

## Easing

```
Element entering or exiting?
  Yes → ease-out (starts fast, feels responsive)
  No →
    Moving/morphing on screen?
      Yes → ease-in-out (natural arc)
    Hover/color change?
      Yes → ease
    Constant motion (marquee, progress bar)?
      Yes → linear
    Default → ease-out
```

**Never use ease-in for entering elements.** It starts slow — exactly when the user is watching most closely. A 300ms `ease-in` *feels* slower than a 300ms `ease-out`. For **exits**, ease-in is acceptable — by the time an element is leaving, the user's focus has already moved on.

**Use custom curves — built-in CSS easings are too weak:**

```css
--ease-out: cubic-bezier(0.23, 1, 0.32, 1);
--ease-in-out: cubic-bezier(0.77, 0, 0.175, 1);
--ease-drawer: cubic-bezier(0.32, 0.72, 0, 1); /* iOS-like */
```

Resources: [easing.dev](https://easing.dev/) · [easings.co](https://easings.co/)

### Easing by Interaction Type

| Interaction | Easing | Why |
|---|---|---|
| Element entering | `ease-out` | Starts fast, feels responsive as user watches |
| Element exiting | `ease-in` | Slow start is fine — user focus has moved on |
| Hover / press | `ease-in-out` | Natural arc for state toggles |
| Morphing (scale, rotate, shape change) | Spring with bounce `0.1–0.2` | Simulates physical response |

## Duration

| Element | Duration |
|---|---|
| Button press feedback | 100–160ms |
| Tooltips, small popovers | 125–200ms |
| Dropdowns, selects | 150–250ms |
| Modals, drawers | 200–500ms |
| Marketing / explanatory | Can be longer |

**UI animations should stay under 300ms.** A faster-spinning spinner makes the app feel like it loads faster even when load time is identical.

## CSS Transitions vs. Keyframes

| | CSS Transitions | CSS Keyframe Animations |
| --- | --- | --- |
| **Behavior** | Interpolate toward latest state | Run on a fixed timeline |
| **Interruptible** | Yes — retargets mid-animation | No — restarts from beginning |
| **Use for** | Interactive state changes (hover, toggle, open/close) | Staged sequences that run once (enter, loading) |

```css
/* Good — interruptible transition */
.drawer {
  transform: translateX(-100%);
  transition: transform 200ms ease-out;
}
.drawer.open {
  transform: translateX(0);
}
```

Always prefer CSS transitions for interactive elements. Reserve keyframes for one-shot sequences.

### Handling Interruptions

If a user triggers a new interaction mid-animation, immediately snap to the target state of the interrupted animation, then start the new one. Never queue animations — queuing makes interfaces feel laggy.

CSS transitions handle this automatically (they retarget mid-animation). For Motion, avoid `AnimatePresence` queuing by using `mode="popLayout"` or managing `key` prop changes directly.

## Asymmetric Enter/Exit

Entering should feel smooth; exiting should be fast. The user is done — get out of the way.

```css
.overlay { transition: clip-path 400ms var(--ease-out); }
.overlay[data-leaving] { transition: clip-path 200ms ease-out; }
```

## Enter Animations: Split and Stagger

Don't animate a single container. Break content into semantic chunks and animate each individually.

1. **Split** into logical groups (title, description, buttons)
2. **Stagger** with ~100ms delay between groups
3. **For titles**, consider splitting into individual words with ~80ms stagger
4. **Combine** `opacity`, `blur`, and `translateY` for the enter effect

```tsx
// Motion (Framer Motion) — staggered enter
// Complex interaction — Motion justified: orchestrated multi-element sequence
<motion.div initial="hidden" animate="visible" variants={{ visible: { transition: { staggerChildren: 0.1 } } }}>
  <motion.h1 variants={{ hidden: { opacity: 0, y: 12, filter: "blur(4px)" }, visible: { opacity: 1, y: 0, filter: "blur(0px)" } }}>
    Welcome
  </motion.h1>
  <motion.p variants={{ hidden: { opacity: 0, y: 12, filter: "blur(4px)" }, visible: { opacity: 1, y: 0, filter: "blur(0px)" } }}>
    A description.
  </motion.p>
</motion.div>
```

```css
/* CSS-only stagger */
.stagger-item {
  opacity: 0;
  transform: translateY(12px);
  filter: blur(4px);
  animation: fadeInUp 400ms ease-out forwards;
}
.stagger-item:nth-child(1) { animation-delay: 0ms; }
.stagger-item:nth-child(2) { animation-delay: 100ms; }
.stagger-item:nth-child(3) { animation-delay: 200ms; }

@keyframes fadeInUp {
  to { opacity: 1; transform: translateY(0); filter: blur(0); }
}
```

Stagger is decorative — never block interaction while stagger plays.

## Exit Animations

Exits should be softer and faster than enters. The user's focus is moving to the next thing.

```tsx
// Subtle exit (recommended)
// Complex interaction — Motion justified: exit needs velocity awareness
<motion.div exit={{ opacity: 0, y: -12, filter: "blur(4px)", transition: { duration: 0.15, ease: "easeIn" } }}>
  {content}
</motion.div>
```

Key rules:
- Use small fixed `translateY` (e.g., `-12px`) not full container height
- Exit duration should be shorter than enter (150ms vs 300ms)
- Keep some directional movement to indicate where the element went

## Never Animate from scale(0)

Nothing in the real world disappears and reappears completely. `scale(0)` collapses to a point and looks mechanical. Use `scale(0.95)` for most elements — or `scale(0.25)` as the minimum for icon/glyph animations where spatial origin needs preserving. Anything below `0.1` is effectively invisible and should be treated as `scale(0)`.

```css
/* ❌ Pops out of nowhere */
.entering { transform: scale(0); }

/* ✅ Natural — general elements */
.entering { transform: scale(0.95); opacity: 0; }

/* ✅ Natural — icon/glyph with spatial origin (see Icon Animations section) */
.entering { transform: scale(0.25); opacity: 0; filter: blur(4px); }
```

## Popover Origin-Awareness

Popovers should scale from their trigger, not from center. **Exception: modals** — they stay centered.

```css
.popover { transform-origin: var(--radix-popover-content-transform-origin); }
/* Base UI: */ .popover { transform-origin: var(--transform-origin); }
```

## Scale on Press

A subtle scale-down on click gives buttons tactile feedback. Always use `scale(0.96)`. Never go below `0.95` — anything smaller feels exaggerated.

```css
.button {
  transition-property: scale;
  transition-duration: 150ms;
  transition-timing-function: ease-out;
}
.button:active {
  scale: 0.96;
}
```

```tsx
// Tailwind
<button className="transition-transform duration-150 ease-out active:scale-[0.96]">
  Click me
</button>
```

Add a `static` prop to disable it when motion would be distracting:

```tsx
const tapScale = "active:not-disabled:scale-[0.96]";

function Button({ static: isStatic, className, children, ...props }) {
  return (
    <button
      className={cn("transition-transform duration-150 ease-out", !isStatic && tapScale, className)}
      {...props}
    >
      {children}
    </button>
  );
}
```

## Icon Animations

When icons appear/disappear contextually (on hover, on state change), animate with `opacity`, `scale`, and `blur`. Always use exactly these values — do not deviate:

- `scale`: `0.25` → `1`
- `opacity`: `0` → `1`
- `filter`: `"blur(4px)"` → `"blur(0px)"`
- Spring: `{ type: "spring", duration: 0.3, bounce: 0 }` — **bounce must always be `0`**

```tsx
// With Motion (if project uses motion/react)
<AnimatePresence mode="popLayout">
  <motion.span
    key={isActive ? "active" : "inactive"}
    initial={{ opacity: 0, scale: 0.25, filter: "blur(4px)" }}
    animate={{ opacity: 1, scale: 1, filter: "blur(0px)" }}
    exit={{ opacity: 0, scale: 0.25, filter: "blur(4px)" }}
    transition={{ type: "spring", duration: 0.3, bounce: 0 }}
  >
    <Icon />
  </motion.span>
</AnimatePresence>
```

```tsx
// CSS-only (no motion dependency) — keep both icons in DOM, cross-fade
function IconButton({ isActive, ActiveIcon, InactiveIcon }) {
  return (
    <button>
      <div className="relative">
        <div className={cn(
          "absolute inset-0 flex items-center justify-center",
          "transition-[opacity,filter,scale] duration-300",
          isActive ? "scale-100 opacity-100 blur-0" : "scale-[0.25] opacity-0 blur-[4px]"
        )}>
          <ActiveIcon />
        </div>
        <div className={cn(
          "transition-[opacity,filter,scale] duration-300",
          isActive ? "scale-[0.25] opacity-0 blur-[4px]" : "scale-100 opacity-100 blur-0"
        )}>
          <InactiveIcon />
        </div>
      </div>
    </button>
  );
}
```

Check `package.json` for `motion` or `framer-motion`. If present, use Motion. If not, use the CSS cross-fade — don't add a dependency just for icon transitions.

## Skip Animation on Page Load

Use `initial={false}` on `AnimatePresence` to prevent enter animations on first render.

```tsx
// Good — icon doesn't animate in on mount, only on state change
<AnimatePresence initial={false} mode="popLayout">
  <motion.span key={isActive ? "active" : "inactive"} ...>
    <Icon />
  </motion.span>
</AnimatePresence>
```

Don't use `initial={false}` when the component relies on its `initial` prop for a first-time entrance animation (staggered page hero, loading state) — it will skip the entire entrance.

## Tooltip Instant-Open on Subsequent Hovers

Once one tooltip is open, adjacent ones should open instantly with no animation delay. Feels faster without removing the purpose of the initial delay.

```css
.tooltip[data-instant] { transition-duration: 0ms; }
```

## clip-path for Revealing Content

```css
.hidden { clip-path: inset(0 100% 0 0); }
.visible { clip-path: inset(0 0 0 0); transition: clip-path 200ms ease-out; }
```

Use cases: hold-to-delete progress, tab color transitions, image reveals on scroll, comparison sliders.

## Spring Animations

Springs feel natural because they simulate physics. They don't have fixed durations — they settle based on parameters.

**Use springs for:**
- Drag interactions with momentum
- Elements that should feel "alive"
- Gestures that can be interrupted mid-animation

```js
// Apple's approach (easier to reason about)
{ type: "spring", duration: 0.5, bounce: 0.2 }

// Traditional physics (more control)
{ type: "spring", mass: 1, stiffness: 100, damping: 10 }
```

Keep bounce subtle (0.1–0.3). Avoid bounce in most UI contexts — use it only for drag-to-dismiss and playful interactions.

**Springs vs duration-based:** Springs maintain velocity when interrupted. CSS keyframes restart from zero. Use springs for gestures users may reverse mid-motion.

## @starting-style for Enter Animations (Modern CSS)

```css
.toast {
  opacity: 1;
  transform: translateY(0);
  transition: opacity 400ms ease, transform 400ms ease;

  @starting-style {
    opacity: 0;
    transform: translateY(100%);
  }
}
```

## prefers-reduced-motion

Reduced motion means fewer and gentler animations — not zero. Keep opacity and color transitions. Remove movement and position animations.

```css
@media (prefers-reduced-motion: reduce) {
  .element { animation: fade 0.2s ease; }
}
```

## Touch Device Hover Guards

Touch devices trigger hover on tap. Gate hover animations behind this media query.

```css
@media (hover: hover) and (pointer: fine) {
  .element:hover { transform: scale(1.05); }
}
```
