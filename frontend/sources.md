# Skill sources — frontend

Section rule: **official first; write your own only when no official skill exists.** A skill
from a source is vendored as a copy, with its source and retrieval date added to its header.

## Official sets

| Source | What to take | Where |
|---|---|---|
| [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) | React and Next.js: components, server and client boundaries, performance, accessibility | `skills/` |
| [jakubkrehel/skills](https://github.com/jakubkrehel/skills) | Interface quality, framework-agnostic: typography, colour systems and contrast measurement, layout and spacing, accessibility recipes, motion and visual polish | `skills/` |
| [GoogleChrome/modern-web-guidance](https://github.com/GoogleChrome/modern-web-guidance) | The web platform itself: CSS, accessibility, performance, privacy, security | read and declined for now, see below |
| [anthropics/skills](https://github.com/anthropics/skills) | Work with documents and artefacts (PDF, spreadsheets, slides) — the common part. **The repository declares no licence**, so it is a pointer, not a source to vendor from until that is settled | `shared/skills/` |
| [github/awesome-copilot](https://github.com/github/awesome-copilot) | Code and review techniques with no stack attached | `shared/skills/` |

Nothing from the last two is in the section yet: they are recorded so nobody looks for an
official skill twice.

## What already sits in the section

### vercel-labs/agent-skills

Source: [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills), MIT (stated in
the README; the repository has no `LICENSE` file), branch `main`, commit
`063bee94c3f4df8453406c830b0a7df0f2860278` (2026-08-28), retrieved 2026-09-21.

| Skill | What is inside | Files |
|---|---|---|
| `react-best-practices` | 70 React performance rules in 8 categories (waterfalls, bundle, server components, client data, re-renders, rendering, JS, advanced patterns) | 76 |
| `composition-patterns` | Component composition: compound components, dropping boolean props, context, React 19 | 14 |
| `react-view-transitions` | The View Transition API in React: navigation, shared elements, Suspense reveals, Next.js | 9 |
| `web-design-guidelines` | Reviewing UI against the Web Interface Guidelines (accessibility, UX) | 2 |
| `writing-guidelines` | Reviewing docs and interface copy for voice and tone | 2 |

**Deviations from the source.** In `react-best-practices` and `react-view-transitions` the
`AGENTS.md` is not vendored: it is the same rules compiled into one document (108 KB in the
first case) and duplicates `rules/` and `references/`. In the `vercel-*` skills the `name`
field of the frontmatter differs from the folder name — that is normal: DSH takes the skill
name from the frontmatter, and the folder only serves as an address.

**Two skills are wrappers, not rules.** `web-design-guidelines` and `writing-guidelines` keep
no rules locally: on every invocation they send the agent to a `command.md` in **another**
repository — [vercel-labs/web-interface-guidelines](https://github.com/vercel-labs/web-interface-guidelines)
and [vercel-labs/writing-guidelines](https://github.com/vercel-labs/writing-guidelines) — which
this section does not pin. So the pinned commit above pins the wrapper, not the rules, and the
rules can move under a project without a byte here changing. Both need network access to work
at all. The live files were fetched and hashed on 2026-09-21 so a change can be detected:

| Wrapper | Live file | SHA-256 |
|---|---|---|
| `web-design-guidelines` | `web-interface-guidelines/command.md` | `5a775e6411f790f518dbc9c1fa7c50a89e6873502d9a3530a6eb223a590bcfe8` (7760 B) |
| `writing-guidelines` | `writing-guidelines/command.md` | `fb638d7821bb4472e4492aedcfb51f2636c7d31d34ff9f01cca5bcdce9b1841f` (14228 B) |

Vendoring those two files was rejected on purpose: `SKILL.md` would have to be edited to read a
local copy, and vendored text is not edited in this base. The deviation is recorded in
`skills/SOURCES.json` and in each `SOURCE.md`.

### jakubkrehel/skills

Source: [jakubkrehel/skills](https://github.com/jakubkrehel/skills), MIT (Copyright (c) 2026
Jakub Krehel), branch `main`, commit `267330e1adfc66a718fb65fa6918c1f06d0a689e` (2026-08-29),
retrieved 2026-09-21. Method: repository tarball; all 65 files of the commit were compared
against its git-blob SHA-1 — no mismatch, no extra file, nothing missing.

The set is used whole. It splits into seven domain skills that hold knowledge and four verb
skills that hold a procedure, and the domain skills hand off to each other by name rather than
restating a rule, so taking a subset would leave dangling hand-offs.

| Skill | What is inside | Files | Who starts it |
|---|---|---|---|
| `better-interface` | The orchestrator: routes to every `better-*` skill, consolidates one ranked verdict, owns severity, the finding cap and the review format | 4 | model |
| `better-accessibility` | Semantic HTML, keyboard and focus, accessible names, forms, assistive technology, hit areas | 9 | model |
| `better-layout` | Grouping and alignment, spacing, responsive structure, logical CSS properties, spatial RTL | 5 | model |
| `better-typography` | Type scale and sizing, variable fonts and OpenType, wrapping and truncation, a Tailwind cheat sheet | 9 | model |
| `better-colors` | Palette structure and step roles, token naming, colour notation, gamut, measuring a rendered pair | 9 | model |
| `better-ui` | Surfaces and concentric radius, optical alignment, icons, motion and timing, `will-change` | 9 | model |
| `better-writing` | Interface copy: terminology, voice, labels, error and empty-state text | 3 | model |
| `interface-review` | Change-scoped review of uncommitted work, branches and pull requests; classifies each finding | 5 | person |
| `variant` | Design exploration: throwaway variants of one interface on a chosen axis, with a picker | 4 | person |
| `break` | Stress-testing one component with a throwaway harness page across scenario axes | 4 | person |
| `explain-interface` | Reading an interface you did not build: the layer stack, measured vs derived vs inferred | 7 | person |

The four verb skills carry `disable-model-invocation: true` in the source, for reasons the
source states: a design exploration, a throwaway test harness and an analysis of someone else's
site are things a person asks for, and an agent firing them unprompted litters a repository.
The seven domain skills are model-invocable — `better-interface` has to be able to reach them.

**Why this set, and not the Next.js-flavoured ones.** The section's stack is a Vite SPA with
Tailwind, so a rule about the App Router or React Server Components does not apply, while
typography, colour contrast, spacing and motion apply to every screen. This is also the first
material in the section on motion, timing and easing, and on measuring contrast instead of
eyeballing it.

## Not vendored — fetch on demand

### vercel-labs/agent-skills

| Skill | Why it is not taken |
|---|---|
| `deploy-to-vercel` | A deployment process for the Vercel platform, not about code |
| `react-native-skills` | A different stack (mobile) |
| `vercel-cli-with-tokens` | Platform CLI and token specifics |
| `vercel-optimize` | Platform-side optimisation, not code |

### GoogleChrome/modern-web-guidance

Read, then declined. `SKILL.md` is 123 lines of wrapper around an npm CLI: every step is
`npx -y modern-web-guidance@latest search|retrieve`, the package is unpinned, network and npm
are needed at run time, and the skill itself warns that `npx` may fail on Windows and that a
sandboxed host needs the command allow-listed before it runs. The 144 `guides/` files next to it
are the data of that npm package, not reference material `SKILL.md` reads, so vendoring the
folder would add 145 files that nothing loads. The skill is Apache-2.0 and the knowledge is
worth having, so two ways back are recorded in `skills/SOURCES.json`: vendor the wrapper and
record the npm dependency as a deviation, or vendor `guides/` alone as reference material and
say so in its `SOURCE.md`. Until then it stays fetchable:

```powershell
pwsh -NoProfile -File .\scripts\fetch-sources.ps1 -Source modern-web   # -> _vendor/modern-web/skills/<name>
```

### jakubkrehel/skills

No skill of the set was left out. The files outside `skills/` are not vendored, as in every
other set: `AGENTS.md`, `CLAUDE.md`, `README.md` and the plugin manifests describe the source
repository rather than the skills.

**How to fetch.** Download the whole set and copy what you need:

```powershell
pwsh -NoProfile -File .\scripts\fetch-sources.ps1 -Source vercel        # -> _vendor/vercel/skills/<name>
pwsh -NoProfile -File .\scripts\fetch-sources.ps1 -Source better-ui     # -> _vendor/better-ui/skills/<name>
```

Then copy the folder into `skills/<name>/`, add a `SOURCE.md` next to it with the repository,
path, commit, date and licence, and record it in `skills/SOURCES.json`. Verify the copy against
the commit before trusting it: `git hash-object` on every file against the blob SHA-1 in
`https://api.github.com/repos/<owner>/<repo>/git/trees/<commit>?recursive=1`.
