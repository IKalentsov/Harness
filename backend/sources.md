# Источники скиллов — backend

Правило раздела: **сначала официальное, своё — только если официального нет.** Скилл
из источника вендорится копией, в шапку добавляется источник и дата получения.

## Официальные наборы

| Источник | Что берём | Куда |
|---|---|---|
| [dotnet/skills](https://github.com/dotnet/skills) | ASP.NET Core (web API, minimal API), EF Core и запросы, диагностика и производительность .NET, работа с трассировкой и дампами | `skills/`, при необходимости `principles/` |
| [neondatabase/postgres-skills](https://github.com/neondatabase/postgres-skills) | PostgreSQL: схема, индексы, планы запросов, диагностика | `skills/` |
| [redis/agent-skills](https://github.com/redis/agent-skills) | Redis: структуры данных, кэширование, паттерны доступа | `skills/` |
| [mongodb/agent-skills](https://github.com/mongodb/agent-skills) | MongoDB: схема документов, агрегации, индексы | `skills/` |
| [supabase/agent-skills](https://github.com/supabase/agent-skills) | Postgres-платформа: доступ, RLS, Edge Functions | `skills/` |
| Microsoft Learn, [Agent skills в SSMS](https://learn.microsoft.com/en-us/ssms/github-copilot/agent-skills) | Диагностика SQL Server: блокировки, Query Store, индексы, сбой задания агента | `skills/` (уже вендорено, см. ниже) |

## Что уже лежит в разделе

| Скилл | Источник | Получено |
|---|---|---|
| `dotnet-webapi` | [dotnet/skills](https://github.com/dotnet/skills), `plugins/dotnet-aspnetcore/skills/dotnet-webapi` | 2026-09-21 |
| `optimizing-ef-core-queries` | [dotnet/skills](https://github.com/dotnet/skills), `plugins/dotnet-data/skills/optimizing-ef-core-queries` | 2026-09-21 |
| `create-datadriven-aspnetcore` | [dotnet/skills](https://github.com/dotnet/skills), `plugins/dotnet-data/skills/create-datadriven-aspnetcore` | 2026-09-21 |
| `analyzing-dotnet-performance` | [dotnet/skills](https://github.com/dotnet/skills), `plugins/dotnet-diag/skills/analyzing-dotnet-performance` | 2026-09-21 |
| `sqlserver-blocking-troubleshooting` | Microsoft Learn, статья «Understand and resolve SQL Server blocking problems» (KB 224453) | 2026-09-21 |
| `sqlserver-query-store-tuning` | Microsoft Learn, «Best practices for monitoring workloads with Query Store» | 2026-09-21 |
| `sqlserver-index-verification` | Официальный пример `index-verification` из Agent skills для SSMS | 2026-09-21 |
| `sqlserver-agent-job-failure-triage` | Официальный пример `agent-job-failure-triage` из Agent skills для SSMS | 2026-09-21 |

Локальные копии автообновления не имеют: при изменениях у источника актуализируются
вручную, дата в шапке сдвигается.

## Не вендорено — берём по требованию

Решение пользователя (2026-09-21): **в репозиторий не тянем, но держим указатели**,
чтобы взять в любой момент. Из `dotnet/skills` доступны и не вендорены 43 скилла: они
покрывают разовые задачи (тестовый контур, сборка, NuGet), а не постоянную работу.

Путь каждого скилла в источнике: `plugins/<плагин>/skills/<имя>`.

| Плагин | Путь | Скиллы |
|---|---|---|
| `dotnet` | `plugins/dotnet/skills/<имя>` | `csharp-refactoring`, `setup-local-sdk` |
| `dotnet-test` | `plugins/dotnet-test/skills/<имя>` | `assertion-quality`, `code-testing-agent`, `code-testing-extensions`, `coverage-analysis`, `crap-score`, `detect-static-dependencies`, `filter-syntax`, `find-untested-sources`, `generate-testability-wrappers`, `grade-tests`, `migrate-static-to-wrapper`, `mtp-hot-reload`, `platform-detection`, `run-tests`, `scaffold-dotnet-test-project`, `test-analysis-extensions`, `test-anti-patterns`, `test-gap-analysis`, `test-smell-detection`, `test-tagging`, `testability-obstacle`, `writing-mstest-tests` |
| `dotnet-msbuild` | `plugins/dotnet-msbuild/skills/<имя>` | `binlog-failure-analysis`, `binlog-generation`, `build-parallelism`, `build-perf-baseline`, `build-perf-diagnostics`, `check-bin-obj-clash`, `copy-to-output-directory`, `directory-build-organization`, `eval-performance`, `extension-points`, `including-generated-files`, `incremental-build`, `item-management`, `msbuild-antipatterns`, `msbuild-modernization`, `property-patterns`, `resolve-project-references`, `target-authoring` |
| `dotnet-nuget` | `plugins/dotnet-nuget/skills/<имя>` | `convert-to-cpm` |

**Как взять.** Скачать набор целиком и скопировать нужный каталог:

```powershell
.\scripts\fetch-sources.ps1 -Source dotnet     # -> _vendor/dotnet/plugins/<плагин>/skills/<имя>
```

Оттуда скилл переносится в `backend/skills/<имя>/` вместе с его `references/` и `scripts/`,
рядом кладётся `SOURCE.md`, а запись добавляется в `backend/skills/SOURCES.json`.

Ближайшие кандидаты, если понадобятся: `run-tests`, `coverage-analysis`,
`test-anti-patterns` (тестовый контур), `directory-build-organization`, `incremental-build`
(сборка), `csharp-refactoring`.

## Как забрать набор

**Через плагин.** Набор из git-источников ставится плагином `dsh-skills-anywhere`
(маркет DSH): он клонирует источники, отдаёт каталог описаний и грузит текст по требованию.
Скиллы из источников не правятся, не переименовываются и не удаляются — обновляет
автосинхронизация.

**Копией в базу.** Для вендоринга в этот раздел:

```powershell
# на машине с сетью (из песочницы DSH сеть закрыта)
.\scripts\fetch-sources.ps1 -Source dotnet,postgres
```

Скрипт клонирует источники в `_vendor/` (каталог не коммитится) — оттуда нужные скиллы
переносятся в `skills/` вручную, с указанием источника и даты.
