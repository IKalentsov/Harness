# Migration log

Date: 2026-09-21. Source: `H:\CSharp\MeProjects\AIProjects` (read-only — nothing there was
changed). Purpose: assemble a reference base from which a project harness is deployed.

## What was migrated

| From | To | What exactly |
|---|---|---|
| `Harnes\.dsh\skills` (vendored set) | `shared/skills` | 24 mattpocock skills + `karpathy-guidelines` + `architecture-drift-check` + `SOURCES.json` + `verify-set.ps1/.cmd` |
| `AI-Projects\.dsh\skills` | `backend/skills` | 4 SQL Server skills: 2 official Microsoft Learn examples reproduced in the original English, 2 compiled from the official articles |
| `WeatherBot\backend` | `backend/templates` | `Directory.Build.props`, `Directory.Packages.props`, `.globalconfig`, `global.json`, `.gitignore` |
| `WeatherBot\.dsh\AGENTS.md` §7–8 | `backend/principles/*` | Layer layout, patterns, red lines, build, stack |
| `marketsniper-mvp\backend\AGENTS.md` | `backend/principles/*` | Solution layers and layout, data, API, integrations, logs, tests, analysers |
| `marketsniper-mvp\frontend\AGENTS.md` | `frontend/principles/*` | Stack, monorepo layout, data and state, forms, screen states, accessibility, prohibitions, DoD |

Project specifics were stripped during migration: solution, entity and table names,
marketplaces, paths, the package versions of a concrete project, its environment limits.

## What was NOT migrated, and why

| What | Reason |
|---|---|
| `task-authoring` (writing a micro-task brief for an executor) | Role-bound: it exists only inside the "architect → executor" cycle. Not an engineering principle |
| `code-review` (reviewing a micro-task against its brief) | Same. The base has `shared/skills/code-review` — a review along two axes, with no roles attached |
| `systematic-debugging` | Duplicates `shared/skills/diagnosing-bugs` |
| `memory-bank/`, `.clinerules/` | State and legacy of one concrete project |
| `ai-tasks/**` (briefs, reports, reviews) | Artefacts of a project process, not a base |
| The global `~/.dsh/AGENTS.md` (removed earlier) | Role rules of a harness; by definition they have no place in the base |

## Official sets vendored on 2026-09-21

| Section | Source | What was vendored |
|---|---|---|
| `backend/skills` | [dotnet/skills](https://github.com/dotnet/skills), MIT, commit `8bbfe7a4` | `dotnet-webapi`, `optimizing-ef-core-queries`, `create-datadriven-aspnetcore`, `analyzing-dotnet-performance` (+7 references) |
| `frontend/skills` | [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills), MIT, commit `063bee94` | `react-best-practices` (+72 rule files), `composition-patterns`, `web-design-guidelines`, `react-view-transitions`, `writing-guidelines` |

Method: files were fetched with the harness network tool from `raw.githubusercontent.com`,
each one checked against the source size and SHA-256, a `SOURCE.md` placed next to every
skill, manifests written to `backend/skills/SOURCES.json` and `frontend/skills/SOURCES.json`.

**Independent check.** The full sets were downloaded into `_vendor/` with
`scripts/fetch-sources.ps1` (curl + codeload + tar) and every vendored file was compared
against them by SHA-256: frontend 98 files, backend 11 files, no mismatches and no missing
files. `_vendor/` was removed after the check.

Consciously not taken, by the user's decision (2026-09-21):

- **`dotnet/skills` — 43 skills are not pulled into the repository.** Only pointers are kept
  (the `plugins/<plugin>/skills/<name>` path and the fetch command): the list is in
  `backend/sources.md` and the machine-readable list in `notVendored` of
  `backend/skills/SOURCES.json`.
- **`vercel-labs/agent-skills` — 4 skills are not taken** (Vercel deployment and platform,
  React Native): the list is in `frontend/sources.md`.

Compiled `AGENTS.md` files were excluded from the vendored sets: DSH reads any `AGENTS.md`
in the tree as directory instructions.

## Matt Pocock skills: all kept

User decision (2026-09-21): **delete nothing.** The 12 skills below are Matt Pocock's process
and wrappers; they stay in `shared/skills` as they are. The table is a reference to what they
are, not a removal list.

| Skill | What it is |
|---|---|
| `ask-matt` | Router over the set: suggests which skill fits a situation |
| `setup-matt-pocock-skills` | One-off setup of a repository for his process |
| `triage`, `wayfinder`, `to-tickets`, `to-spec`, `implement` | Ticket work and planning |
| `grill-me`, `grill-with-docs` | Short wrappers around `grilling` |
| `improve-codebase-architecture` | Finding opportunities to deepen modules (overlaps `codebase-design`) |
| `teach`, `to-questionnaire`, `wait-what`, `handoff` | Not about development: teaching, questionnaires, re-explaining, context hand-off |

## Open questions

1. Process skills (`task-authoring`, micro-task review, `systematic-debugging`) stripped of
   roles — do they belong in the base, or only in a project?
2. `frontend/templates/` — to be filled once the first working frontend monorepo exists
   (the file list is in `frontend/templates/README.md`).
