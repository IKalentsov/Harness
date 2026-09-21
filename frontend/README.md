# frontend — the React + TypeScript section

General principles of client-side development: SPA structure, data and state, UI and
accessibility, quality and definition of done. The section knows nothing about a concrete
product.

## What is here

| Path | What it is | When to read |
|---|---|---|
| `principles/stack-and-structure.md` | Stack, monorepo, layers, import direction | Starting an app, a new module, an argument about where code goes |
| `principles/data-and-state.md` | Server data, client state, URL state, forms, API client | A screen with data, a form, filters, API integration |
| `principles/ui-and-accessibility.md` | Mandatory screen states, WCAG 2.2 AA, semantics | Any screen and any interactive component |
| `principles/quality.md` | Lint, types, tests, DoD, red lines | Accepting work, an argument about a dependency or a rule |
| `skills/` | 16 vendored skills in two official sets: [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) — `react-best-practices` (70 React performance rules), `composition-patterns`, `react-view-transitions`, `web-design-guidelines`, `writing-guidelines`; and [jakubkrehel/skills](https://github.com/jakubkrehel/skills) — `better-interface` with six domain skills (`better-accessibility`, `better-layout`, `better-typography`, `better-colors`, `better-ui`, `better-writing`) and four verb skills (`interface-review`, `variant`, `break`, `explain-interface`) | Work on React, UI, motion, typography, colour, interface copy |
| `templates/` | Config drafts (tsconfig, eslint, prettier) | Starting a frontend build |
| `sources.md` | Official frontend skill sets | Looking for an official skill before writing one |

Every vendored skill carries a `SOURCE.md` next to it: repository, path, branch or commit,
retrieval date, licence and skipped files. Formal properties of every skill in the section
are checked by `scripts/verify-library.ps1`.

Two skills of the Vercel set (`web-design-guidelines`, `writing-guidelines`) are wrappers that
fetch their rules at run time from two other repositories; the deviation and the hash of each
live file are recorded in `sources.md` and in `skills/SOURCES.json`.

## Deploying into a project

1. Copy `principles/` into the project and use them as the draft of the frontend
   `.dsh/AGENTS.md`.
2. Lay the skills out: `scripts/install-skills.ps1 -Project <path> -Set shared,frontend`.
3. Put the drafts from `templates/` at the monorepo root and fill in real versions.
4. Add the project specifics (domains, API, design system, bundle budget) to the project.

## Section boundaries

- **A principle, not a product.** Interface texts, domain entities and routes belong to the
  project, not to the section.
- **Versions live in the project.** The stack table in the section sets the direction; exact
  versions are pinned in the project and updated as a separate change.
- **Accessibility is not up for debate.** WCAG 2.2 AA is an entry requirement, not a wish;
  an exception is granted by the user.
