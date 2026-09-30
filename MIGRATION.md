# Migration log

Date: 2026-09-21. Source: an earlier copy of this base and the working projects listed below,
all read-only — nothing there was changed. Paths in the table are relative to the folder that held
them, never to a particular machine. Purpose: assemble a reference base from which a project
harness is deployed.

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

1. **Closed 2026-09-30.** Original question: process skills (`task-authoring`, micro-task
   review, `systematic-debugging`) stripped of roles — do they belong in the base, or only in a
   project? **They belong in the base.** The invocation finding below answers it: upstream marks
   its own process skills user-invoked, so the base can hold a process without the model running
   it unaided, and the risk that motivated the question does not exist. Closed as a decision
   about the principle; the three named skills stay out for the separate reasons already
   recorded above.
2. `frontend/templates/` — to be filled once the first working frontend monorepo exists
   (the file list is in `frontend/templates/README.md`).
3. `GoogleChrome/modern-web-guidance` — read and declined for now; two ways back are recorded
   in `frontend/skills/SOURCES.json`.
4. `wizard` (mattpocock) — still excluded (it generates an interactive bash script). Revisit if
   a project wants it.

## Skill invocation pass, 2026-09-30

### `shared/principles/skills.md` added

The rule "true for both stacks → `shared/`" had no material behind it: skill selection does not
depend on the stack. `backend/principles/` never used the word `skill`, and
`frontend/principles/` used it once, about UI recipes, not about invocation. `DEPLOY.md` step 3
requires the project's `AGENTS.md` to be drafted from `principles/*.md`, so the deployer was told
to write an invocation rule with nothing to draft it from, and a deployed project filled the gap
with "skills are a possibility, not an obligation" — after which the agent stopped taking them.
The new section holds the rule and nothing else. It creates `shared/principles/`, which did not
exist although the section already had `skills/`.

### The pointer now names the mechanism

`shared/README.md` §"Who can invoke what" ended by naming "a project skill or an explicit
instruction" as the way to make an agent run the pipeline unaided. The first is a dead end: a
duplicated skill breaks "one meaning, one place", and it does not work either. Replaced with the
mechanism that does — an instruction naming the skill's file by path
(`.dsh/skills/<name>/SKILL.md`), because the `skill` tool cannot reach a user-invoked skill —
plus a pointer to `principles/skills.md`.

### Three documentation divergences, closed

| File | Was | Now |
|---|---|---|
| `backend/README.md` "What is here" | The `skills/` row listed the four SQL skills and described the section as "Database skills", silently dropping the four .NET skills. `README.md` described the same section correctly, so the base's own documents disagreed — and `DEPLOY.md` obliges a deployer to read `<section>/README.md` | Two rows: the .NET half with its "When to read", the SQL half with its own |
| `backend/README.md` §"Section boundaries" | Declared "a database is not assumed" and left it there, while `-Set shared,backend` always installs the four SQL skills and `README.md` called `-Only` an exception. The declared project state had no install path | An install command for it, now via `-Exclude` |
| `frontend/README.md` | Nothing on invocation at all — no `disable-model-invocation`, `user-invoked` or `/name`. A frontend deployer counted 16 available skills and got 12 in the catalog and 4 behind `/name` | A §"Who can invoke what" naming all four user-invoked (`break`, `variant`, `interface-review`, `explain-interface`) and all twelve model-invoked |

The base `README.md` gained the layout across all three sections — 50 skills, of which 18 are
user-invoked and 32 model-invoked — and its "an agent-first harness gets the 12 model-invoked
skills" now says that 12 is `shared/` alone. `AGENTS.md` routes the question "the agent does not
take its skills" to `shared/README.md` §"Who can invoke what" and `shared/principles/skills.md`.
Counts were checked against the tree, not copied: `shared` 26 (14/12), `backend` 8 (0/8),
`frontend` 16 (4/12).

### `install-skills.ps1` gained `-Exclude`

A deny-list by exact folder name, applied beside `-Only` and parsed the same way. It exists for
the database-free path above: excluding four is the natural operation there, allow-listing thirty
is not. A name matching no skill in the selected sets is refused rather than ignored, so an
installation that silently did not shrink is impossible. Documented in `README.md` and
`DEPLOY.md`, with the working command in `backend/README.md`.

Verified: `-Exclude` with the four SQL names installs 30 of 34 for `shared,backend`; the same
command without `-Exclude` still installs 34, byte-identical to the original script's output;
a misspelled name exits 1 with the name in the message. `scripts/verify-library.ps1` ran at exit
0 before and after: 50 skills checked and 7 `.dsh` copies in step, so the layout and the
provenance records are untouched. No `SKILL.md` and no frontmatter was edited, `.dsh/skills` was
not rebuilt, and `.dsh/` is unchanged because no skill file changed.

## Hardening pass, 2026-09-21

### Provenance closed for `shared/skills`

`AGENTS.md` has always said that every vendored skill carries a `SOURCE.md`, but the 24
`mattpocock/skills` entries and `karpathy-guidelines` had only the set manifest. **25 `SOURCE.md`
files were added**, each recording repository, path, commit, date, licence, the file list and
deviations. Two consequences: `scripts/verify-library.ps1` now classifies the whole section as
`[vendored]` instead of `[own]`, and provenance travels into a project together with the skill.
No `SKILL.md` was touched.

`shared/skills/verify-set.ps1` was adjusted to skip `SOURCE.md` in the hash comparison: the
manifest keeps listing upstream files only, so a `SOURCE.md` is neither required in it nor
reported as an extra file.

`karpathy-guidelines` comes from
[multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills) — MIT
per its own frontmatter, and the repository has **no `LICENSE` file**. Verified byte for byte at
commit `2c606141936f1eeef17fa3043a72095b4765b9c2`: local and upstream blob SHA-1 are both
`6a62d0441753157ca6ca50479e490c2948033adb`.

### The mattpocock pin, stated precisely

`SOURCES.json` said `ref: main`, `commit: c55ee460…`, `version: 1.2.3`. Checked against upstream:
the vendored files match `main@c55ee460` (`ask-matt` 11417 B, `wait-what` 394 B), while the
`v1.2.3` tag points at a **different tree** (`ask-matt` 11491 B, `wait-what` 325 B) — published
skills were edited after the tag while `package.json` still said 1.2.3. The manifest now records
`main past v1.2.3` and states that the SHA-256 map, not the version string, is the guarantee.

### Frontend: `jakubkrehel/skills` vendored

11 skills, in the two shapes the source itself defines: seven domain skills that hold knowledge
(`better-interface` as the orchestrator, plus accessibility, layout, typography, colors, ui,
writing) and four verb skills that hold a procedure (`interface-review`, `variant`, `break`,
`explain-interface`).

Verification: tarball at commit `267330e1adfc66a718fb65fa6918c1f06d0a689e`; all 65 files of the
tree compared against its git-blob SHA-1 — no mismatch, no extra file, nothing missing. Recorded
in `frontend/sources.md`, `frontend/skills/SOURCES.json` and a `SOURCE.md` per skill.

Why: the section's stack is a Vite SPA with Tailwind, and this set is framework-agnostic, so it
applies where the Next.js-flavoured rules do not. It is the first material in the base on
typography, colour systems, contrast measurement, spacing and motion.
`frontend/principles/ui-and-accessibility.md` now points at those recipes instead of pretending
to hold them.

### Two Vercel wrappers: the deviation is recorded

`web-design-guidelines` and `writing-guidelines` keep no rules locally: they fetch them at run
time from `vercel-labs/web-interface-guidelines` and `vercel-labs/writing-guidelines`, which the
section does **not** pin — so the pinned commit pins the wrapper, not the rules. `SOURCES.json`
claimed `deviation: none` for both. They now carry the deviation, the external repository and the
SHA-256 of the live file as of 2026-09-21, so a change upstream is detectable. Vendoring the file
was rejected because `SKILL.md` would have to be edited to read a local copy.

### Read and declined

| Source | Verdict | Reason |
|---|---|---|
| [GoogleChrome/modern-web-guidance](https://github.com/GoogleChrome/modern-web-guidance) | declined | `SKILL.md` wraps an npm CLI (`npx -y modern-web-guidance@latest`), unpinned, network and npm required; the skill itself warns `npx` is unreliable on Windows. Its 144 `guides/` files are the package's data and are not read by `SKILL.md` |
| [anthropics/skills](https://github.com/anthropics/skills) | pointer only | **declares no licence**; of its 19 skills only `frontend-design` was relevant to the section |
| [pbakaus/impeccable](https://github.com/pbakaus/impeccable) | declined | a product rather than a skill: CLI, browser automation, six provider copies, a 1.1 MB font index |
| [Leonxlnx/taste-skill](https://github.com/Leonxlnx/taste-skill) | declined | prompt megafiles (one `SKILL.md` of 87 KB) with no reference material behind them |
| [Jakubantalik/transitions-dev](https://github.com/Jakubantalik/transitions-dev) | does not exist | HTTP 404; the link that circulates is dead |
| [vercel-labs/skills](https://github.com/vercel-labs/skills) | declined | the `npx skills` CLI, not a skill set; skill discovery is already covered by the DSH plugins in `PLUGINS.md` |
| [DenisSergeevitch/agents-best-practices](https://github.com/DenisSergeevitch/agents-best-practices) | pointer | about designing agent harnesses, not about a stack; useful when working on the harness itself |
| [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) | declined | split licence with a BSL component |
| [Kappaemme-git/codex-complexity-optimizer](https://github.com/Kappaemme-git/codex-complexity-optimizer) | declined | one commit, never touched since; the substance is a single Python script |
| [Graphify-Labs/graphify](https://github.com/Graphify-Labs/graphify) | declined | no `SKILL.md` anywhere in the tree (default branch `v8`), so there is nothing to vendor as a skill |
| [hardikpandya/stop-slop](https://github.com/hardikpandya/stop-slop) | pointer | a small prose de-slopper; overlaps `writing-guidelines` and `writing-for-agents` |

`scripts/fetch-sources.ps1` gained four catalog entries — `better-ui`, `modern-web`, `stop-slop`,
`agents-bp` — so the two pointers above can be pulled on demand.

### Invocation, and the base's own `.dsh/skills`

Checked in the DSH implementation: `disable-model-invocation: true` keeps a skill out of the
model-facing catalog and loader, and its only entry point is the user's `/name` gesture. In
`shared/skills` that is **14 of 26 skills, the whole Matt Pocock pipeline among them** — the
model never sees them. `README.md` now documents the mechanism, `shared/README.md` carries the
pipeline map and the list of which skills the model reaches on its own, and the vendored
frontmatter was not edited to change any of it.

The base's own `.dsh/skills` (7 skills) was rebuilt from the sections with the command now
documented in `README.md`; the copies are byte-identical to their sources. `.dsh/` stays
git-ignored by the decision in `d4e1ac1`.

`_vendor/` was removed again after the verification — a stale `_vendor/dotnet` from the earlier
check had survived the previous cleanup.

## `.dsh/` is tracked again, 2026-09-21

`d4e1ac1` stopped tracking `.dsh/` and the README said the directory was ignored by decision.
Reversed by the user's decision: the base commits its own build of the library, so cloning it
restores a working harness without running the installer, and nothing is lost when a local copy
goes away.

Checked before reversing, because the old ignore line claimed it held "sessions, caches,
settings": DSH writes nothing machine-local under a project's `.dsh/`. The harness keeps all user
data under one root, `$DSH_HOME` (`~/.dsh`), and inside a project `dsh-skill-filesystem` reads
exactly one path, `<projectRoot>/.dsh/skills`. The ignore line was protecting the wrong
directory — the global home sits outside any repository and cannot be committed by accident.

The cost is a second copy inside the repository, which "one meaning, one place" does not love. It
is paid for by a check rather than by discipline: `scripts/verify-library.ps1` now compares every
entry in `.dsh/skills` against the section it came from and fails on a missing, extra or changed
file, so a section edit that was never re-installed cannot be committed silently. The check was
tested against a deliberately drifted copy: it named the file and exited 1, and the copy was
restored from its section afterwards.

If the duplication ever becomes noise, the way back is one line: restore `.dsh/` in `.gitignore`
and delete the copies from the index. The sections are still the only source of truth.
