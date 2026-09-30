# backend — the .NET section

General principles of server-side development on .NET, database skills and build templates.
The section knows nothing about a concrete project: solution, table and path names come
from the project.

## What is here

| Path | What it is | When to read |
|---|---|---|
| `principles/architecture.md` | Layers, dependency direction, domain patterns | Designing a solution layout, a new entity or use case |
| `principles/data-and-storage.md` | EF Core, migrations, indexes, cache, transactions | Work on the database, queries, schema |
| `principles/api.md` | Controllers, errors, OpenAPI, health checks, outbound calls | A new endpoint, an integration, a contract |
| `principles/observability-and-config.md` | Logs, configuration, secrets | Logging, settings, keys |
| `principles/testing.md` | Test levels, architecture tests, DoD | Writing and accepting tests |
| `principles/toolchain.md` | Analysers, central package versions, build | Build setup, analyser findings |
| `skills/` | 8 skills in two halves. The .NET half, from [dotnet/skills](https://github.com/dotnet/skills): `dotnet-webapi`, `optimizing-ef-core-queries`, `analyzing-dotnet-performance`, `create-datadriven-aspnetcore` | Working on an endpoint or an integration |
| | The SQL Server half, from Microsoft Learn: `sqlserver-blocking-troubleshooting`, `sqlserver-query-store-tuning`, `sqlserver-index-verification`, `sqlserver-agent-job-failure-triage` | Working with a real database and its problems |
| `templates/` | `Directory.Build.props`, `Directory.Packages.props`, `.globalconfig`, `global.json`, `.gitignore` | Starting a backend build |
| `sources.md` | Official .NET and database skill sets | Looking for an official skill before writing one |

Every vendored skill carries a `SOURCE.md` next to it: repository, path, branch or commit,
retrieval date, licence and skipped files. Formal properties of every skill in the section
are checked by `scripts/verify-library.ps1`.

## Deploying into a project

1. Copy `principles/` and `skills/` into the project (or use them as the draft of its
   `.dsh/AGENTS.md`).
2. Lay the skills out: `scripts/install-skills.ps1 -Project <path> -Set shared,backend`.
3. Put the files from `templates/` at the root of the backend build and fill in real package
   versions in `Directory.Packages.props`.
4. Add the project specifics (solution paths, layer names, package set, environment limits)
   to the project's `.dsh/AGENTS.md` — the section's principles do not carry them.

## Section boundaries

- **A principle, not a command.** Build and test commands depend on the project: they belong
  in the project's `WORKFLOW.md` or `AGENTS.md`.
- **No project specifics.** Project, schema, table, marketplace and path names never enter
  the section.
- **A database is not assumed.** The data principles apply only when the project has a
  database; "no database, none planned" is a legitimate project state.

  Such a project takes the section without its SQL half — the four .NET skills and nothing
  else. `-Set shared,backend` always brings all four SQL skills along, so name them in
  `-Exclude`:

  ```powershell
  pwsh -NoProfile -File .\scripts\install-skills.ps1 -Project <path> -Set shared,backend -Exclude sqlserver-agent-job-failure-triage,sqlserver-blocking-troubleshooting,sqlserver-index-verification,sqlserver-query-store-tuning
  ```

  `-Exclude` takes exact folder names, comma-separated, and refuses a name that matches no
  skill in the selected sections. The rest of the section is unaffected: the SQL skills are
  the only part of it that presumes a database.
