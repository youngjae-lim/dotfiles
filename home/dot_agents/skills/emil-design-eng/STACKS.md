# Translating These Skills To Your Stack

*Local addition, not part of Emil Kowalski's original skills (MIT, see LICENSE). Upstream: github.com/emilkowalski/skills at `64eb3de` (2026-11-15). Library facts checked 2026-11-24.*

The skills show their examples in React with Motion, Base UI, Sonner and Vaul. The rules carry over to any stack unchanged: the frequency gate, the purpose of each animation, the curves, the durations, `transform`/`opacity` only, interruptibility and reduced motion. **Only the syntax changes.** When a project isn't React, use this file to write the same motion in its own tools. Don't add React or Motion to a project just to follow an example.

## Detect the stack first

| Signal | Stack | Section |
| --- | --- | --- |
| `svelte` in `package.json`, `.svelte` files | Svelte 5 (runes) / SvelteKit | [Svelte 5](#svelte-5) |
| `astro` in `package.json`, `.astro` files | Astro, often with Svelte islands | [Astro](#astro) |
| `react`, `next` | React: use the skills as written | — |
| `composer.json` with `livewire/livewire`, `.blade.php` | Laravel Blade, Livewire, Alpine | [Server-rendered](#server-rendered-pages-htmx-blade-livewire-liveview) |
| `go.mod` and `hx-` attributes | Go templates + htmx | [Server-rendered](#server-rendered-pages-htmx-blade-livewire-liveview) |
| `mix.exs` with `phoenix_live_view` | Phoenix LiveView | [Server-rendered](#server-rendered-pages-htmx-blade-livewire-liveview) |
| `tailwindcss` | Any of the above + Tailwind | [Tailwind](#tailwind) |

Check what's installed before reaching for a library. A Svelte project with Bits UI uses Bits UI; a static Astro site with no islands uses CSS.

## Concept map

| In the skills (React) | Svelte 5 | Astro / plain HTML, CSS, JS |
| --- | --- | --- |
| `motion.div` with `initial`/`animate`/`exit`, `AnimatePresence` | `transition:` / `in:` / `out:` directives from `svelte/transition`. Svelte keeps the element mounted until its out-transition ends | `@starting-style` for entry; `transition-behavior: allow-discrete` with `display`/`overlay` for exit; WAAPI `el.animate()` + `finished` before removing |
| `useEffect(() => setMounted(true), [])` + `data-mounted` | `@starting-style` first; else `onMount` / `$effect` setting a `$state` flag | `@starting-style`; else set a `data-mounted` attribute in a script |
| `useMotionValue`, `useSpring`, `useTransform` | `Spring` / `Tween` from `svelte/motion` (`Spring.of(() => value)` follows a prop); `$derived` for linked values | `animate()` from `motion` (vanilla, no React needed) or WAAPI |
| `layout`, `layoutId` (shared layout animation) | `animate:flip` for keyed reorders; `crossfade` (`send`/`receive`) to move an element between lists | View Transitions API: `view-transition-name` + `document.startViewTransition()`; Astro `transition:name` across pages |
| `useReducedMotion()` | `prefersReducedMotion.current` from `svelte/motion` | `@media (prefers-reduced-motion: reduce)`; `matchMedia(...)` in scripts |
| `useInView`, `whileInView` | An attachment (`{@attach}`) wrapping `IntersectionObserver` | `IntersectionObserver`, or `inView()` from `motion` |
| `ref.current.style.transform = …` | `bind:this` or an attachment, then `node.style.transform = …` | `el.style.transform = …` |
| Drag props (`drag`, `dragElastic`, `onDragEnd`) | Pointer events in an attachment + `setPointerCapture`; release with `animate()` from `motion` or a CSS transition | Same, in a plain script |
| Base UI popover/tooltip, `var(--transform-origin)` | Bits UI; origin in `--bits-<name>-content-transform-origin` (e.g. `--bits-popover-content-transform-origin`) | Native `popover` + CSS anchor positioning; set `transform-origin` to the side facing the trigger |
| Base UI tooltip delay groups | `Tooltip.Provider` with `delayDuration` and `skipDelayDuration` | Hand-rolled: one shared timestamp of the last close |
| Sonner | `svelte-sonner` (a port, same API: see `../ask-sonner/SKILL.md`) | Sonner needs React; on a static page, prefer not needing toasts |
| Vaul | `vaul-svelte` (Svelte 5 support only in its prerelease `vaul-svelte@next`), or Bits UI `Dialog` styled as a sheet | `<dialog>` styled as a sheet with the Vaul curve (see `../gestures/SKILL.md`) |

## Easing tokens

The curves in the skills are CSS. They work unchanged in `.css`, Svelte `<style>`, Astro `<style>`, Blade and HEEx templates:

```css
:root {
  --ease-out: cubic-bezier(0.23, 1, 0.32, 1);
  --ease-in-out: cubic-bezier(0.77, 0, 0.175, 1);
  --ease-drawer: cubic-bezier(0.32, 0.72, 0, 1);
}
```

**Svelte's `transition:` directives take an easing *function*, not a CSS curve.** The built-ins in `svelte/easing` default to `linear` or weak curves (`cubicOut`). Closest strong equivalents:

| Token | Svelte function | How close |
| --- | --- | --- |
| `--ease-out` (0.23, 1, 0.32, 1) | `quintOut` | Near-identical (quint is 0.22, 1, 0.36, 1) |
| `--ease-in-out` (0.77, 0, 0.175, 1) | `quartInOut` | Close (quart is 0.76, 0, 0.24, 1) |
| `--ease-drawer` (0.32, 0.72, 0, 1) | none | Use a CSS transition, or `cubicBezier(0.32, 0.72, 0, 1)` from `motion` if it's installed |

When the exact curve matters and the state can be expressed as a class or attribute, prefer a CSS transition (`class:open={open}`) over a directive: it uses the token directly and retargets mid-flight.

## Svelte 5

### Enter and exit

```svelte
<script lang="ts">
  import { fly } from 'svelte/transition';
  import { quintOut } from 'svelte/easing';
  import { prefersReducedMotion } from 'svelte/motion';
  let { open } = $props();
</script>

{#if open}
  <div
    class="toast"
    in:fly={{ y: prefersReducedMotion.current ? 0 : 16, duration: 250, easing: quintOut }}
    out:fly={{ y: prefersReducedMotion.current ? 0 : 16, duration: 200, easing: quintOut }}
  >…</div>
{/if}
```

- **Interruption:** a bidirectional `transition:` reverses from where it is when toggled mid-flight. Separate `in:`/`out:` do not reverse; the out plays from the in's current state. For anything toggled rapidly, use `transition:` or a CSS transition.
- **Local by default:** transitions play only when their own block changes. Add `|global` only when the parent's appearance should animate the child too, which is rarely right.
- **Never `scale(0)`:** `scale` from `svelte/transition` takes `start`. Use `start: 0.95`, never the default 0.
- **Exit faster than enter:** separate `in:` and `out:` durations make that explicit.
- **Where it runs:** Svelte 5 samples a transition's `css` into keyframes and plays them with `element.animate()`. Those transitions follow the same compositor rules as CSS and WAAPI. Transitions written with `tick` run on the main thread every frame.

### Springs and tweens

```svelte
<script lang="ts">
  import { Spring } from 'svelte/motion';
  let { value } = $props();
  const s = Spring.of(() => value, { stiffness: 0.2, damping: 0.8 });
</script>

<div style:transform="translateX({s.current}px)"></div>
```

- Svelte's `stiffness` and `damping` are 0–1 coefficients, **not** Apple's damping ratio and not Motion's `bounce`/`duration`. Tune by eye. Higher damping means less overshoot.
- `spring.set(v, { instant: true })` jumps, which is right for the track phase of a gesture. `spring.set(v, { preserveMomentum: ms })` keeps a fling's trajectory.
- When the skills specify a spring by `bounce` and `duration`, or seed it with a release velocity in px/s, use `animate()` from `motion` (vanilla) on the element instead: `animate(el, { y: 0 }, { type: 'spring', bounce: 0, visualDuration: 0.4, velocity })`.

### Don't animate through `$state` per frame

Svelte updates the DOM finely, so a `$state` write per `pointermove` costs less than a React re-render. It still runs effects and can drop frames on a busy page. In hot paths (pointer, scroll, rAF), write `node.style.transform` directly. Keep `$state` for what the UI needs to *know*, such as `dragging = true`.

### Gestures with an attachment

```svelte
<script lang="ts">
  import type { Attachment } from 'svelte/attachments';
  import { animate } from 'motion';

  const drag: Attachment<HTMLElement> = (node) => {
    let startY = 0, y = 0, lastY = 0, lastT = 0, velocity = 0;
    let running: ReturnType<typeof animate> | undefined;
    const down = (e: PointerEvent) => {
      if (!e.isPrimary) return;                              // ignore extra fingers
      running?.stop();                                       // catch it mid-flight…
      y = new DOMMatrix(getComputedStyle(node).transform).m42; // …from where it is now
      node.setPointerCapture(e.pointerId);
      startY = e.clientY - y; lastY = e.clientY; lastT = e.timeStamp; velocity = 0;
    };
    const move = (e: PointerEvent) => {
      if (!node.hasPointerCapture(e.pointerId)) return;
      y = Math.max(0, e.clientY - startY);
      node.style.transform = `translateY(${y}px)`;          // track phase: 1:1, no easing
      velocity = ((e.clientY - lastY) / (e.timeStamp - lastT)) * 1000; // px/s
      lastY = e.clientY; lastT = e.timeStamp;
    };
    const up = () => {
      const dismiss = y > node.offsetHeight * 0.4 || velocity > 500;
      const target = dismiss ? node.offsetHeight : 0;
      running = animate(node, { y: target }, { type: 'spring', bounce: 0.2, visualDuration: 0.4, velocity });
      y = target;
    };
    node.addEventListener('pointerdown', down);
    node.addEventListener('pointermove', move);
    node.addEventListener('pointerup', up);
    node.addEventListener('pointercancel', up);
    return () => {
      node.removeEventListener('pointerdown', down);
      node.removeEventListener('pointermove', move);
      node.removeEventListener('pointerup', up);
      node.removeEventListener('pointercancel', up);
    };
  };
</script>

<div class="sheet" {@attach drag} style="touch-action: none">…</div>
```

Without `motion`, finish the release with a CSS transition (`transition: transform 500ms var(--ease-drawer)`) toggled on release. Remove that transition while tracking, or the element trails the finger.

### Stagger

Non-uniform delays per item, one entrance per group (see `../choreograph/SKILL.md`):

```svelte
{#each items as item, i (item.id)}
  <li in:fly={{ y: 8, duration: 300, easing: quintOut, delay: delays[i] ?? 0 }}>…</li>
{/each}
```

Compute `delays` once (e.g. `[0, 50, 90, 120, 140]`). Leave it empty under reduced motion.

### Layout and shared elements

- `animate:flip` on the direct child of a keyed `{#each}` animates reorders, not additions or removals.
- `crossfade` from `svelte/transition` returns `[send, receive]` for an element that moves between two lists.
- For a whole view changing, use the View Transitions API (`document.startViewTransition`); in SvelteKit call it from `onNavigate`.

## Astro

- **Static first.** Most motion on an Astro page is CSS in a component `<style>` block. Reach for an island (`client:*`) only when the motion needs state.
- **Server HTML must already be in its final visible state.** Never hide content with `opacity: 0` and wait for an island to hydrate and reveal it. Without JavaScript, or with slow JavaScript, the content stays invisible. Use `@starting-style` for CSS-only entrances.
- **Page transitions:** either native cross-document view transitions (`@view-transition { navigation: auto; }` in CSS, no JS), or Astro's `<ClientRouter />` from `astro:transitions` with `transition:name`, `transition:animate` and `transition:persist`. With the router, scripts must re-run on `astro:page-load`, not `DOMContentLoaded`. Every view transition needs a reduced-motion rule:
  ```css
  @media (prefers-reduced-motion: reduce) {
    ::view-transition-group(*), ::view-transition-old(*), ::view-transition-new(*) { animation: none !important; }
  }
  ```
- **Theme switching without a flash:** an inline `<script is:inline>` in `<head>` that sets `data-theme` before first paint. No library needed.

## Server-rendered pages: htmx, Blade, Livewire, LiveView

The default is CSS: transitions on classes the server or a small script toggles, plus `@starting-style` for newly inserted elements. Then each tool's hook:

| Tool | Entering | Leaving | Notes |
| --- | --- | --- | --- |
| htmx | `.htmx-added` is on new content for one settle tick: style it as the start state | `.htmx-swapping` on old content; give it time with `hx-swap="outerHTML swap:200ms"` | `hx-swap="… transition:true"` uses the View Transitions API |
| Alpine (Blade, Livewire) | `x-transition:enter` / `enter-start` / `enter-end` classes with your curve tokens | `x-transition:leave…` (shorter) | Plain `x-transition` fades and scales from 0.95 with a weak curve; spell out the classes to use the tokens |
| Livewire 3 | `wire:transition` on elements toggled by `@if` | same | Simple fades only; for more, use Alpine |
| Phoenix LiveView | `JS.show(transition: {"ease-out duration-200", "opacity-0 scale-95", "opacity-100 scale-100"})` | `JS.hide(…)`, `phx-remove` | Transition classes are often Tailwind |

## Tailwind

- Tailwind v4 already defines `--ease-in`, `--ease-out` and `--ease-in-out` in its `@theme` namespace, with weak curves. Either override them deliberately in `@theme` (this changes every `ease-out` utility), or add new names such as `--ease-out-strong` and `--ease-drawer` and use `ease-out-strong`.
- `transition` sets several properties at once. Prefer `transition-transform` / `transition-opacity`, which is the `transition: all` rule in Tailwind form.
- Tailwind v4's `hover:` already applies only under `@media (hover: hover)`. To also require a precise pointer, as the skills do, add a variant:
  ```css
  @custom-variant hover-fine {
    @media (hover: hover) and (pointer: fine) {
      &:hover { @slot; }
    }
  }
  ```
  Use `motion-reduce:` / `motion-safe:` for reduced motion.

## Where motion hides (for audits)

When `review-animations`, `improve-animations`, `remove-animations` or `find-animation-opportunities` say "grep for motion", look here too:

- **Svelte:** `transition:`, `in:`, `out:`, `animate:` directives; imports from `svelte/transition`, `svelte/motion`, `svelte/easing`; `Spring`/`Tween`; `{@attach}` functions with pointer handlers; `<style>` blocks; `{#if}` blocks with no transition (instant appear/disappear).
- **Astro:** `<style>` and `<style is:global>`; `transition:*` directives; `<ClientRouter />`; `@view-transition`.
- **htmx / Alpine / Livewire / LiveView:** `hx-swap` modifiers, `.htmx-*` classes, `x-transition`, `wire:transition`, `JS.show`/`JS.hide`/`JS.transition`, `phx-remove`.
- **Tailwind:** `transition*`, `duration-*`, `ease-*`, `delay-*`, `animate-*`, `motion-*` classes, and `@theme` tokens.

## Libraries

For the Svelte and framework-free equivalents of every library in the curated list, see `../pick-ui-library/SKILL.md` ("Your stack").
