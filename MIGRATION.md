# Журнал переноса

Дата: 2026-09-21. Источник: `H:\CSharp\MeProjects\AIProjects` (только чтение — там ничего
не менялось). Цель переноса: собрать референсную базу, из которой разворачивается харнесс
под конкретный проект.

## Что перенесено

| Откуда | Куда | Что именно |
|---|---|---|
| `Harnes\.dsh\skills` (вендоренный набор) | `shared/skills` | 24 скилла mattpocock + `karpathy-guidelines` + `architecture-drift-check` + `SOURCES.json` + `verify-set.ps1/.cmd` |
| `AI-Projects\.dsh\skills` | `backend/skills` | 4 скилла SQL Server (адаптация официальных agent skills Microsoft Learn) |
| `WeatherBot\backend` | `backend/templates` | `Directory.Build.props`, `Directory.Packages.props`, `.globalconfig`, `global.json`, `.gitignore` |
| `WeatherBot\.dsh\AGENTS.md` §7–8 | `backend/principles/*` | Устройство слоёв, паттерны, красные линии, сборка, стек |
| `marketsniper-mvp\backend\AGENTS.md` | `backend/principles/*` | Слои и структура решения, данные, API, интеграции, логи, тесты, анализаторы |
| `marketsniper-mvp\frontend\AGENTS.md` | `frontend/principles/*` | Стек, структура монорепо, данные и состояние, формы, состояния экрана, доступность, запреты, DoD |

При переносе убрана проектная конкретика: имена решений, сущностей и таблиц, площадки,
пути, версии пакетов конкретного проекта, ограничения его среды.

## Что НЕ перенесено и почему

| Что | Причина |
|---|---|
| `task-authoring` (постановка микро-задачи для исполнителя) | Ролевое: существует только внутри цикла «архитектор → исполнитель». Не инженерный принцип |
| `code-review` (ревью микро-задачи по постановке) | То же. В базе есть `shared/skills/code-review` — ревью по двум осям, без привязки к ролям |
| `systematic-debugging` | Дублирует `shared/skills/diagnosing-bugs` |
| `memory-bank/`, `.clinerules/` | Состояние и легаси конкретного проекта |
| `ai-tasks/**` (постановки, отчёты, ревью) | Артефакты процесса проекта, а не база |
| Глобальный `~/.dsh/AGENTS.md` (удалён ранее) | Ролевые правила харнесса; в базе им места нет по определению |

## Официальные наборы, вендоренные 2026-09-21

| Раздел | Источник | Что вендорено |
|---|---|---|
| `backend/skills` | [dotnet/skills](https://github.com/dotnet/skills), MIT, коммит `8bbfe7a4` | `dotnet-webapi`, `optimizing-ef-core-queries`, `create-datadriven-aspnetcore`, `analyzing-dotnet-performance` (+7 references) |
| `frontend/skills` | [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills), MIT, коммит `063bee94` | `react-best-practices` (+72 файла правил), `composition-patterns`, `web-design-guidelines`, `react-view-transitions`, `writing-guidelines` |

Способ: скачивание через сетевой инструмент харнесса по `raw.githubusercontent.com`,
сверка каждого файла с размером и SHA-256 источника, `SOURCE.md` рядом с каждым скиллом,
манифесты — `backend/skills/SOURCES.json` и `frontend/skills/SOURCES.json`.

**Независимая проверка.** Полные наборы были скачаны в `_vendor/` через
`scripts/fetch-sources.ps1` (curl + codeload + tar), после чего все вендоренные файлы
сверены с ними по SHA-256: frontend — 98 файлов, backend — 11 файлов, расхождений
и пропусков нет. Каталог `_vendor/` после проверки удалён.

Не взято осознанно, решение пользователя (2026-09-21):

- **`dotnet/skills` — 43 скилла в репозиторий не тянем.** Держим только указатели
  (путь `plugins/<плагин>/skills/<имя>` и команду загрузки) — перечень в `backend/sources.md`,
  машинный список — `notVendored` в `backend/skills/SOURCES.json`.
- **`vercel-labs/agent-skills` — 4 скилла не берём** (деплой и платформа Vercel, React Native):
  перечень в `frontend/sources.md`.

Из вендоренных наборов исключены скомпилированные `AGENTS.md`: DSH читает любой
`AGENTS.md` в дереве как инструкции каталога.

## Скиллы Matt Pocock: оставлены все

Решение пользователя (2026-09-21): **ничего не удалять.** 12 скиллов ниже — процесс
Matt Pocock и обёртки; они остаются в `shared/skills` как есть. Таблица — справка о том,
что это за скиллы, а не список на удаление.

| Скилл | Что это |
|---|---|
| `ask-matt` | Роутер по набору: подсказывает, какой скилл подходит под ситуацию |
| `setup-matt-pocock-skills` | Разовая настройка репозитория под его процесс |
| `triage`, `wayfinder`, `to-tickets`, `to-spec`, `implement` | Работа с тикетами и планированием |
| `grill-me`, `grill-with-docs` | Короткие обёртки вокруг `grilling` |
| `improve-codebase-architecture` | Поиск возможностей углубить модули (пересекается с `codebase-design`) |
| `teach`, `to-questionnaire`, `wait-what`, `handoff` | Не про разработку: обучение, опросники, пересказ, передача контекста |

## Открытые вопросы

1. Процессные скиллы (`task-authoring`, ревью микро-задач, `systematic-debugging`)
   в очищенном от ролей виде — нужны ли в базе или их место только в проекте?
2. `frontend/templates/` — заполнить, когда появится первый рабочий фронтенд-монорепо
   (перечень файлов — `frontend/templates/README.md`).
