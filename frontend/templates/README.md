# Frontend templates

A directory for monorepo config blanks: the base `tsconfig`, a flat ESLint config,
formatting settings, the root `package.json` with scripts.

**For now the directory is intentionally empty.** In none of the user's projects has
frontend code been started yet, so there is nothing to vendor here: versions and rules
invented "by eye" would diverge from reality at the very first `pnpm install`.

## What to put here once the first frontend project appears

| File | Where to take it from |
|---|---|
| `tsconfig.base.json` + `packages/tsconfig/*` | From the first working monorepo, after the types and paths have settled |
| `eslint.config.js` (flat) + `packages/eslint-config/*` | From there as well; the rules — from `principles/stack-and-structure.md` (no imports between features, no barrel files) |
| `.prettierrc`, `.editorconfig` | From there as well |
| `package.json` (root, with scripts) | From there as well: `dev`, `build`, `lint`, `typecheck`, `test`, `api:generate` |
| `pnpm-workspace.yaml` | From there as well |

## Order of vendoring

1. Take the files from a **working** project — that is the only way versions and rules are verified.
2. Remove project specifics: package names, domains, application paths.
3. Put them here and record the source and the date in the file header or in this README.
4. Do not substitute versions "from memory": ranges and `latest` are forbidden.

## Stack guidelines

The approximate composition of the stack and the code placement rules — `principles/stack-and-structure.md`.
Official skill sets for React and TypeScript — `sources.md`.
