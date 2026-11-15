---
name: ts-js-conventions
description: Conventions for TypeScript/JavaScript projects (Node, Bun, Astro, Svelte, React, Tailwind). Use when editing or creating TS/JS code.
---

# TypeScript / JavaScript conventions

Node from mise; detect the package manager from the lockfile (`pnpm-lock.yaml` → pnpm, `bun.lock(b)` → bun, `package-lock.json` → npm) and use only that one.

- Before finishing: run the project's `typecheck`/`lint`/`test` scripts (`pnpm run lint`, `pnpm test`, `bun test`, ...). Read `package.json` scripts first.
- TypeScript: `strict` types; no `any` (use `unknown` + narrowing); `type` imports; prefer union types and `as const` over enums unless the codebase uses enums.
- ES modules, `async/await`, no floating promises; handle errors at boundaries.
- Validate external input (e.g. zod/valibot) at API boundaries.
- Framework idioms: follow existing component patterns (Astro islands, Svelte runes/stores, React hooks rules). Keep components small; colocate tests.
- Tailwind: use existing design tokens/config; don't invent arbitrary values when a token exists.
- Formatting comes from Prettier/ESLint/Biome config in the repo — run it, don't hand-format.
- Ask before adding dependencies; prefer the platform (fetch, URL, Intl, structuredClone).
