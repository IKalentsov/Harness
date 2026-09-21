# AGENTS.md — working with the harness base

> This is a knowledge base, not a project: no builds, no tests, no project state.
> Its job is to hand out ready-made sections that a project harness is assembled from.

## What to read per task

| Task | Read |
|---|---|
| Understand the base and how to deploy it | `README.md` |
| Adopt the base into a new project | `DEPLOY.md` |
| Set up a .NET project harness | `backend/README.md`, `backend/principles/*` |
| Set up a React project harness | `frontend/README.md`, `frontend/principles/*` |
| Add or fix a skill | `shared/README.md`, `sources.md` of the section |
| Trace where a vendored skill came from | `backend/sources.md`, `frontend/sources.md`, `SOURCE.md` next to the skill |
| Look up a DSH plugin | `PLUGINS.md` |
| Check the whole library | `scripts/verify-library.ps1` |

## Boundaries

- **One meaning, one place.** A skill or principle lives in exactly one section; pointing at
  it from another section is fine, copying it is not.
- **The section is chosen by knowledge, not by taste.** Rules about layers, EF Core, ASP.NET
  and migrations go to `backend/`. Rules about React, the browser, layout and accessibility
  go to `frontend/`. Rules true for both stacks go to `shared/`.
- **Project specifics stay out of the base:** roles and models, task cycles, `ai-tasks`,
  reports, micro-task reviews, paths of concrete projects, solution and table names.
- **Official skills are vendored, not rewritten.** Copy them as they are and record the
  source and date in `SOURCE.md`. Adapting the text is allowed only as an explicit deviation
  block with a reason and a date.
- **Skills are not nested.** DSH reads `<root>/<name>/SKILL.md` and nothing deeper;
  a project gets its flat layout from `scripts/install-skills.ps1`.
- **The base is edited on purpose or not at all.** A session opened on a target project reads
  the base and never writes to it. Changes here happen in a session opened on the base itself,
  with the user saying that is what is being done. On any disagreement between a project and the
  base, the base wins on rules and the project wins on its own facts.
- **The tracked `.dsh/skills` follows its sections.** The base commits its own build so a clone
  works immediately, which makes it a second copy that must not drift: changing a skill in a
  section means re-running `scripts/install-skills.ps1` and committing the copy.
  `scripts/verify-library.ps1` fails when the two disagree.

## Skill format

```
<section>/skills/<kebab-case-name>/SKILL.md
```

- the directory name equals the `name` field, both kebab-case;
- `description` and `whenToUse` state what the skill does and when it is invoked.
  **Vendored** skills keep the frontmatter of their source, in its original language:
  translating it would edit the official text;
- a colon inside `description` or `whenToUse` is allowed only inside quotes — an unquoted
  `USE WHEN:` breaks the YAML frontmatter and the provider skips the file without a word;
- a skill's resources (references, scripts) live inside its own directory and are linked
  relatively;
- every vendored skill carries a `SOURCE.md` next to it: repository, path, branch or commit,
  retrieval date, licence, files that were skipped. `SKILL.md` itself is never edited;
- run `scripts/verify-library.ps1` before handing work over: it checks frontmatter, names,
  quoting and relative links.
