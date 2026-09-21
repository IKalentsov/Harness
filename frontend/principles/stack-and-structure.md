# Stack and structure

## Stack (reference)

| Layer | Technologies |
|---|---|
| Build | Vite, React, TypeScript, React Router |
| UI | Tailwind CSS, design-system components living in the repository |
| Data | TanStack Query, a light store (Zustand), URL state (nuqs) |
| Forms | react-hook-form + zod |
| API | Backend OpenAPI schema → generated client and query hooks |
| Tests | Vitest, React Testing Library, MSW, Playwright |
| Quality | ESLint (flat config), typescript-eslint, Prettier, git hooks |

Exact versions are pinned in the monorepo root `package.json`; a version bump is a separate
change with a reason.

## Monorepo layout (pnpm)

```
frontend/
├── apps/web/                 # the SPA
├── apps/<second-app>/        # a landing page or a second client — its own app
├── packages/ui/              # design system: components, tokens, styles
├── packages/api-client/      # generated client + query hooks
├── packages/shared/          # types, utilities, constants
├── packages/eslint-config/   # shared linter configs
├── packages/tsconfig/        # base tsconfigs
├── pnpm-workspace.yaml
└── package.json              # root scripts and versions
```

## Layers inside the app

- `app/` — providers, router, error boundary. Minimal logic.
- `routes/` — a thin routing layer: assemble features and entities into a screen.
- `features/` — one folder per business capability.
- `entities/` — domain entities, reusable only.
- `shared/` — UI kit, utilities, config, test utilities; knows nothing about features.

Dependencies point one way only:

```
shared → entities → features → routes/app
```

- **Importing one `features/*` from another is forbidden.** Composition happens at the
  `routes/` level. A linter rule enforces it, not discipline.
- **Barrel files** (re-exporting everything) are out: they break tree-shaking. The exception is
  `features/<name>/index.ts` as the feature's public API, with explicit exports.
- Generated files (the API client) are never edited by hand and never imported into the UI
  directly.
