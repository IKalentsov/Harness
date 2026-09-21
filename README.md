# Harnes — reference harness

A knowledge base for deploying an agent working environment for a concrete project.
It holds the sections `backend/`, `frontend/` and `shared/`: skills, engineering principles
and build templates. A project's `.dsh/` is **assembled from this base by copying** —
the base is not a project and is never linked into one.

Deliberately absent: the roles and process of concrete projects ("who is the architect",
"who is the executor", `ai-tasks`, reports, micro-task reviews, git conventions). Those are
properties of a project, not of an engineering base; they live in the project's own
`.dsh/AGENTS.md`.

## Layout

```
Harnes/
├── README.md               # this file
├── AGENTS.md               # how to work with the base
├── MIGRATION.md            # migration log: what was taken, what was not, and why
├── PLUGINS.md              # DSH plugin reference: name and purpose
├── DEPLOY.md               # prompt to paste into a project: adopt this base there
├── shared/                 # true for both backend and frontend
│   ├── skills/             # 26 skills; a vendored one carries SOURCE.md next to SKILL.md
│   └── README.md
├── backend/                # .NET: architecture, data, API, tests, toolchain
│   ├── principles/         # engineering principles (reference)
│   ├── skills/             # 8 skills: dotnet/skills (4) + SQL Server (Microsoft Learn, 4)
│   ├── templates/          # build config templates
│   ├── sources.md          # official skill sources and what to take from them
│   └── README.md
├── frontend/               # React + TypeScript: structure, data, UI, quality
│   ├── principles/
│   ├── skills/             # 16 skills: vercel-labs (React) + jakubkrehel (interface quality)
│   ├── templates/
│   ├── sources.md
│   └── README.md
└── scripts/
    ├── install-skills.ps1  # lays a set from the base into <project>/.dsh/skills
    ├── verify-library.ps1  # checks frontmatter, names and links across all skills
    └── fetch-sources.ps1   # clones official sets into _vendor/ (network required)
```

## Deploying a project harness

`DEPLOY.md` is this procedure as a prompt: paste it into a session opened on the target project
and the agent reads the base, lays the skills out and drafts the project files. The steps below
are the same thing by hand.

1. Copy the sections the project needs: `backend/` for the server side, `frontend/` for the
   client side, `shared/` in both cases.
2. Lay the skills into the project:

   ```powershell
   # shared + backend only
   .\scripts\install-skills.ps1 -Project H:\path\to\project -Set shared,backend

   # shared + frontend only
   .\scripts\install-skills.ps1 -Project H:\path\to\project -Set shared,frontend
   ```

   The script copies `<name>/SKILL.md` directories into `<project>/.dsh/skills`. The flat
   layout is mandatory: DSH reads exactly one level (`skills/<name>/SKILL.md`) and never
   looks into subfolders such as `skills/backend/...`.
3. Use the section's principles as the draft of the project's `.dsh/AGENTS.md`: drop what
   does not apply and add the project's specifics. Principles are an input, not a finished
   project file.
4. Put the files from `templates/` at the root of the backend build (`Directory.Build.props`,
   `Directory.Packages.props`, `.globalconfig`, `global.json`, `.gitignore`) and fill in real
   package versions.
5. Pull official skill sets with `scripts/fetch-sources.ps1` (the list of sources is in each
   section's `sources.md`).

## Base rules

- **One meaning, one place.** A skill, a principle or a template lives in one section; copies
  inside projects are consumables, never the source of truth.
- **The section decides ownership.** True for both stacks → `shared/`; knows about layers,
  a database or ASP.NET → `backend/`; knows about React, the browser or layout → `frontend/`.
- **Vendor the official, leave the local behind.** Skills from official sources are kept as
  copies with their source and date recorded; home-made skills for a project's process never
  enter the base.
- **Versions are pinned exactly.** No floating ranges and no `latest` in the templates.
- **A third-party licence stays third-party.** A vendored skill arrives with its source
  licence; it is recorded in `SOURCE.md` and travels with the skill into a project. The skill
  text is not rewritten: a divergence from the official line is written as an explicit
  deviation block with a reason and a date.
- **Keep the global layer minimal.** The user's `~/.dsh` holds model connections and session
  data only; rules and skills live in the base (sections) or in the project (`.dsh/`).
  Configuring an environment through `~/.dsh/skills` is unnecessary.

## How DSH sees the skills

DSH reads exactly one level (`skills/<name>/SKILL.md`) and loads a skill in two steps: the
`description` (with `whenToUse` when the skill has one) enters the session catalog, and only
the skill a task actually needs is read in full. A section of forty skills therefore costs
forty short lines until one of them is used.

Two frontmatter keys decide who can reach a skill:

| Frontmatter | Effect |
|---|---|
| neither key | The model sees the skill in the catalog and may invoke it on its own |
| `disable-model-invocation: true` | The skill is absent from the catalog and from the `skill` tool; a person opens it with `/name` |

In `shared/skills` **14 of 26 skills are user-invoked** — the whole Matt Pocock pipeline among
them. The list is in `shared/README.md`. This matters when a project expects the agent to run a
flow by itself: an agent-first harness gets the 12 model-invoked skills, and the pipeline
starts when a person types the command.

**Vocabulary of the source.** A vendored skill is not edited, so it speaks the vocabulary of
the tool it was written for: "the Skill tool" is DSH's `skill` tool, `/clear` and `/compact`
are context commands of the host, `/name` is a user-invoked skill. Read them as host concepts,
not as literals.

**The base's own `.dsh/`.** This repository runs on a hand-picked subset of its own sections
placed in `.dsh/skills` (7 skills). That directory is a local build, not a source: `.dsh/` is
git-ignored by decision, and the sections stay the single source of truth. Rebuild it after a
section changes:

```powershell
.\scripts\install-skills.ps1 -Project . -Set shared,backend `
  -Only architecture-drift-check,codebase-design,domain-modeling,karpathy-guidelines,research,sqlserver-index-verification,writing-for-agents
```

**Where provenance lives.** A vendored skill carries `SOURCE.md` next to `SKILL.md`; in the base
it points at the section manifest `../SOURCES.json` for the per-file hashes. The manifest and
`verify-set.cmd` stay in the base — `install-skills.ps1` copies skill folders only, so a project
receives the provenance record, not the checker.

## Checking the base

```powershell
# every section
powershell -ExecutionPolicy Bypass -File .\scripts\verify-library.ps1

# one section
powershell -ExecutionPolicy Bypass -File .\scripts\verify-library.ps1 -Set frontend
```

It checks the properties that make DSH skip a skill without a word: a present `SKILL.md`,
frontmatter with `name` and `description`, the name matching the folder, unquoted colons
inside a value, broken relative links. The vendored set in `shared/skills` is additionally
checked for integrity: `shared\skills\verify-set.cmd` compares SHA-256 against its manifest.
That manifest lists upstream files only — a `SOURCE.md` next to a skill is this base's own
provenance record and is skipped by the comparison. Neither script looks at `.dsh/skills`,
which is a local build of the sections; rebuild it and compare, as above.

## Environment notes

- The DSH tool runs commands in **Windows PowerShell 5.1**, not `pwsh` 7: keep inline commands
  in ASCII, because Cyrillic in command text is mangled before the child process starts.
- Non-ASCII text belongs in a `.ps1` file written as **UTF-8 with BOM**: PowerShell 5.1 reads
  a BOM-less `.ps1` as ANSI and turns the text into garbage.
- Network: `curl.exe` works and is how official sets are fetched (`codeload` + `tar`).
  `git clone` fails inside the sandbox on TLS (`schannel: SEC_E_NO_CREDENTIALS`) and
  `Invoke-WebRequest` fails while receiving the response. The fetcher therefore uses `curl`
  by default, with git available behind `-UseGit`.
- The agent edits files one at a time (`write`/`edit`) rather than through `Set-Content` or a
  write-back `-replace`: a bulk edit is irreversible and leaves no trace of what changed.
- A skill directory never contains an `AGENTS.md`: DSH reads that file as directory
  instructions and loads it into context, duplicating `SKILL.md`. Compiled `AGENTS.md` files
  from official sets are not vendored.
