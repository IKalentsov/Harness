# Skill sources — backend

Section rule: **official first; write your own only when no official skill exists.** A skill
from a source is vendored as a copy, with its source and retrieval date added to its header.

## Official sets

| Source | What to take | Where |
|---|---|---|
| [dotnet/skills](https://github.com/dotnet/skills) | ASP.NET Core (web API, minimal API), EF Core and queries, .NET diagnostics and performance, tracing and dumps | `skills/`, `principles/` when needed |
| [neondatabase/postgres-skills](https://github.com/neondatabase/postgres-skills) | PostgreSQL: schema, indexes, query plans, diagnostics | `skills/` |
| [redis/agent-skills](https://github.com/redis/agent-skills) | Redis: data structures, caching, access patterns | `skills/` |
| [mongodb/agent-skills](https://github.com/mongodb/agent-skills) | MongoDB: document schema, aggregations, indexes | `skills/` |
| [supabase/agent-skills](https://github.com/supabase/agent-skills) | The Postgres platform: access, RLS, Edge Functions | `skills/` |
| Microsoft Learn, [Agent skills in SSMS](https://learn.microsoft.com/en-us/ssms/github-copilot/agent-skills) | SQL Server diagnostics: blocking, Query Store, indexes, agent job failure | `skills/` (vendored, see below) |

## What already sits in the section

| Skill | Source | Retrieved |
|---|---|---|
| `dotnet-webapi` | [dotnet/skills](https://github.com/dotnet/skills), `plugins/dotnet-aspnetcore/skills/dotnet-webapi` | 2026-09-21 |
| `optimizing-ef-core-queries` | [dotnet/skills](https://github.com/dotnet/skills), `plugins/dotnet-data/skills/optimizing-ef-core-queries` | 2026-09-21 |
| `create-datadriven-aspnetcore` | [dotnet/skills](https://github.com/dotnet/skills), `plugins/dotnet-data/skills/create-datadriven-aspnetcore` | 2026-09-21 |
| `analyzing-dotnet-performance` | [dotnet/skills](https://github.com/dotnet/skills), `plugins/dotnet-diag/skills/analyzing-dotnet-performance` | 2026-09-21 |
| `sqlserver-blocking-troubleshooting` | Microsoft Learn, "Understand and resolve SQL Server blocking problems" (KB 224453) | 2026-09-21 |
| `sqlserver-query-store-tuning` | Microsoft Learn, "Best practices for monitoring workloads with Query Store" | 2026-09-21 |
| `sqlserver-index-verification` | The official `index-verification` example from Agent skills for SSMS | 2026-09-21 |
| `sqlserver-agent-job-failure-triage` | The official `agent-job-failure-triage` example from Agent skills for SSMS | 2026-09-21 |

Vendored copies have no auto-update: when the source changes, they are refreshed by hand and
the date in the header moves forward.

## Not vendored — fetch on demand

User decision (2026-09-21): **keep them out of the repository, keep the pointers.** 43 skills
in `dotnet/skills` are available and not vendored: they cover one-off jobs (the test contour,
build, NuGet) rather than daily work.

A skill's path in the source is `plugins/<plugin>/skills/<name>`.

| Plugin | Path | Skills |
|---|---|---|
| `dotnet` | `plugins/dotnet/skills/<name>` | `csharp-refactoring`, `setup-local-sdk` |
| `dotnet-test` | `plugins/dotnet-test/skills/<name>` | `assertion-quality`, `code-testing-agent`, `code-testing-extensions`, `coverage-analysis`, `crap-score`, `detect-static-dependencies`, `filter-syntax`, `find-untested-sources`, `generate-testability-wrappers`, `grade-tests`, `migrate-static-to-wrapper`, `mtp-hot-reload`, `platform-detection`, `run-tests`, `scaffold-dotnet-test-project`, `test-analysis-extensions`, `test-anti-patterns`, `test-gap-analysis`, `test-smell-detection`, `test-tagging`, `testability-obstacle`, `writing-mstest-tests` |
| `dotnet-msbuild` | `plugins/dotnet-msbuild/skills/<name>` | `binlog-failure-analysis`, `binlog-generation`, `build-parallelism`, `build-perf-baseline`, `build-perf-diagnostics`, `check-bin-obj-clash`, `copy-to-output-directory`, `directory-build-organization`, `eval-performance`, `extension-points`, `including-generated-files`, `incremental-build`, `item-management`, `msbuild-antipatterns`, `msbuild-modernization`, `property-patterns`, `resolve-project-references`, `target-authoring` |
| `dotnet-nuget` | `plugins/dotnet-nuget/skills/<name>` | `convert-to-cpm` |

**How to fetch.** Download the whole set and copy the directory you need:

```powershell
pwsh -NoProfile -File .\scripts\fetch-sources.ps1 -Source dotnet   # -> _vendor/dotnet/plugins/<plugin>/skills/<name>
```

From there the skill moves into `backend/skills/<name>/` together with its `references/` and
`scripts/`, a `SOURCE.md` goes next to it, and an entry is added to
`backend/skills/SOURCES.json`.

Closest candidates when the need appears: `run-tests`, `coverage-analysis`,
`test-anti-patterns` (the test contour), `directory-build-organization`, `incremental-build`
(build), `csharp-refactoring`.
