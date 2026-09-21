# Adopt the harness base into this repository

> **How to use this file.** Open a session in the target repository and paste this file as the
> first message. Everything below is the prompt; the header you are reading is part of it.
> The prompt is a dispatcher, not a rulebook: the rules live in the reference repository and are
> read from there, so this file does not go stale when the base changes.

---

## Your task

Adopt the harness base into the repository you are working in. That means: lay out its skills,
draft the project's agent instructions from its principles, place its build templates, and create
the project documents its skills expect.

## The reference

The single source of truth is the harness base:

- **local checkout:** `H:\CSharp\Harnes`
- **git:** `https://github.com/IKalentsov/Harness` (`git@github.com:IKalentsov/Harness.git`)

Use the local checkout when it exists. If it does not, clone the repository into a temporary
directory and use that. Read it; never write to it.

**The repository you are working in is a target project, not the base.** The base is only ever
changed in a session that was explicitly opened on the base, by a person who says so. If you
believe the base is wrong or incomplete, write that in your report and stop — do not fix it here.

## Priority when things disagree

1. **The base wins on rules.** Its principles, skills, templates and boundaries replace whatever
   the target project currently says about how agents should work.
2. **The target project wins on facts.** Real paths, solution and layer names, package sets and
   exact versions, scripts and commands, domains, table names, design system, environment limits.
   These are not in the base by design and must be carried over.
3. **Anything else is removed.** Old agent configuration in the target — `AGENTS.md` or
   `CLAUDE.md` at any level, `.cursor/`, `.clinerules/`, `.github/copilot-instructions.md`,
   `memory-bank/`, `ai-tasks/`, role cycles, previously copied skill sets, vendor skill folders —
   is deleted and replaced, not merged. Merging two rulebooks produces a third one that neither
   side wrote.

When a fact is missing and cannot be established from the repository, **ask**. Do not invent it,
and do not leave a placeholder that looks like a decision.

## Read before changing anything

From the base, in this order:

| File | What you take from it |
|---|---|
| `README.md` | What the base is, its layout, the deployment steps, the base rules, how DSH loads skills |
| `AGENTS.md` | The boundaries between sections, and the skill format a project copy must satisfy |
| `MIGRATION.md` | What was deliberately not taken from other sources, and why — so you do not re-add it |
| `<section>/README.md` | For each section you copy: what is in it and what is out of scope for it |
| `<section>/sources.md` | Which official sets exist and what they are for |
| `PLUGINS.md` | Only if the project needs DSH plugins |
| `<section>/principles/*.md` | The draft material for the project's own `AGENTS.md` |

## Procedure

**1. Decide which sections apply.** `shared/` always. `backend/` for .NET. `frontend/` for
React and TypeScript. Read the target's actual stack rather than assuming one; if the repository
is empty or ambiguous, ask which side is being built.

**2. Lay the skills.** Run the base's script against the target:

```powershell
# from the base checkout
pwsh -NoProfile -File .\scripts\install-skills.ps1 -Project <target> -Set shared,backend -Clean
```

Call it through `pwsh`. A bare `.\scripts\install-skills.ps1` is **refused** in the DSH tool's own
shell, which is Windows PowerShell 5.1 with an execution policy of `Restricted`: the call dies
before the script starts, and that is not a sign that the script or the base is broken.

`-Clean` replaces the target's `.dsh/skills` wholesale: skills inside a project are consumables,
never a source of truth, so replacing them is the intended behaviour and the reason re-runs
converge. Add `-Only a,b,c` only if the user asks for a subset. Preview with `-WhatIfOnly` when
the target already has a harness, and report what will disappear before it does.

**Install into the root a session will resolve, or nothing is discovered.** DSH walks up from the
session's working directory to the nearest ancestor containing `.git` and reads
`<that root>/.dsh/skills`; with no `.git` anywhere it uses the working directory itself. In a
monorepo the target is therefore the git root, not `backend/` or `apps/web`. A harness written into
a subdirectory looks exactly like having no skills at all, and the folder containing `.git` is the
thing to check when a session reports an empty catalog.

**Verify it with the base's own checker**, which takes any skills root:

```powershell
pwsh -NoProfile -File <base>\scripts\verify-library.ps1 -SkillsRoot <target>\.dsh\skills
```

It applies the loader's own rules — kebab-case `name`, `description`, one level deep, no UTF-8 BOM
hiding the frontmatter, nothing DSH would read as directory instructions — and exits non-zero on
the first problem.

**3. Draft `<target>/.dsh/AGENTS.md`.** Start from the applicable `principles/*.md`, drop what
does not apply to this project, and add the project's own specifics. Keep the project's facts in
one clearly marked section so a later re-run knows what to preserve.

**4. Backend templates.** Copy `backend/templates/` — `Directory.Build.props`,
`Directory.Packages.props`, `.globalconfig`, `global.json`, `.gitignore` — into the root of the
target's backend build, then replace the sample packages with the project's real set and write
versions exactly. No ranges, no `latest`. Versions in `.csproj` stay out.

**5. Frontend templates.** `frontend/templates/` is intentionally empty and holds only a README
explaining what belongs there. **Do not invent tsconfig, ESLint, Prettier or root scripts.**
Report the gap.

**6. Project documents the base's skills expect.** Create the ones the project can actually fill
from what exists, and ask for the facts you lack:

| Document | Purpose | Creating skill |
|---|---|---|
| `.dsh/AGENTS.md` | The project's agent instructions: rules plus project facts | — |
| `ARCHITECTURE.md` | How the system is built: layers, dependency direction, contracts, stack | `architecture-drift-check` |
| `WORKFLOW.md` | Build, test and run commands, and the definition of done for this project | — |
| `CONTEXT.md` | The project's own terminology, with the words to avoid | `domain-modeling` |
| ADRs | Decisions that are hard to reverse | `domain-modeling` |

**7. Record the baseline.** Put one line in the header of `.dsh/AGENTS.md`:

```
Harness base: IKalentsov/Harness @ <commit>, adopted <date>
```

A later run compares it with the base's current commit and reports what moved in between.

**8. Verify the layout.** Skills sit exactly one level deep, `skills/<name>/SKILL.md`, never
`skills/<group>/<name>/`. No skill directory contains an `AGENTS.md` — DSH reads that file as
directory instructions and would load it into every session. Every skill folder has `SKILL.md`;
every vendored one has `SOURCE.md`; frontmatter `name` and `description` are present and a colon
inside a value is quoted. Run the base's checker rather than eyeballing it:
`pwsh -NoProfile -File <base>\scripts\verify-library.ps1 -SkillsRoot <target>\.dsh\skills`.

**9. Report** in this shape, and keep it short:

- which sections were taken, and why those and not the others;
- how many skills were installed, from which base commit;
- what was created, what was replaced, and exactly what was deleted;
- the project facts that are still missing, as a list of questions;
- deviations and gaps, including the empty `frontend/templates/`.

## Never

- Modify the base. It is read-only during an adoption.
- Edit a vendored `SKILL.md` or its frontmatter, `disable-model-invocation` included. A
  divergence is recorded as an explicit deviation in that skill's `SOURCE.md`, with a reason.
- Put an `AGENTS.md`, `CLAUDE.md` or provider rule file inside a skill directory.
- Nest skills or copy them into `~/.dsh/skills`. The global layer holds model connections and
  session data only; rules belong to the base and to the project's `.dsh/`.
- Delete anything that is not agent or harness configuration. Project source, docs, tests,
  migrations and git history are out of scope for a cleanup — ask first, always.
- Invent a version, a licence, a command, a file's contents, or a project fact.

## Re-running

This procedure is idempotent, and re-running it after the base changes is the normal way to
update a project:

- `.dsh/skills` is replaced wholesale;
- the rules in `.dsh/AGENTS.md` are re-drafted from the base;
- the marked project-facts section and every project document are preserved;
- the base commit in the header is updated, and the difference from the previous one is reported
  from the base's `MIGRATION.md` and `git log`.

## One decision to confirm with the user

Whether `.dsh/skills` is committed in this project or git-ignored and re-deployed from the base.
Committing it makes a clone self-contained; ignoring it keeps the project free of copies and
requires the base to be reachable. The base commits its own `.dsh/` for that first reason: cloning
the base restores its working harness without running anything. A project can go either way, and
if it commits them, a re-run shows up as a diff that has to be committed. Ask; do not decide
silently.
