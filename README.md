# Harness

Воркспейс для сессий DeepSeek Harness, настроенный **локально под этот проект**:
здесь лежат скиллы, установленные только для этого воркспейса, а не глобально.

## Структура

```
.dsh/skills/<name>/SKILL.md          скилл: проектный скоуп DSH
.dsh/skills/SOURCES.json             манифест вендоренного набора (репозиторий, commit, хеши)
.dsh/skills/verify-set.ps1           проверка целостности набора
.dsh/skills/verify-set.cmd           то же самое в обход execution policy
.gitignore                           .dsh/* игнорируется, кроме .dsh/skills/
```

Скиллов всего 25: 24 из набора [mattpocock/skills](https://github.com/mattpocock/skills)
и один сторонний (`karpathy-guidelines`).

### Почему это проектный скоуп

DSH ищет локальные скиллы по корням с приоритетом (меньший ранг важнее):

| Ранг | Источник | Путь |
|---|---|---|
| 100 | проект | `<projectRoot>/.dsh/skills` |
| 200 | проект | `<projectRoot>/.agents/skills` |
| 400 | пользователь | `<dshHome>/skills` |

Корень проекта — ближайший каталог с `.git`, иначе текущий рабочий каталог.

Скиллы лежат в `.dsh/skills` внутри корня проекта, а не в `%USERPROFILE%\.dsh\skills`,
поэтому они видны только в этом воркспейсе и не появляются в других проектах.

### Как запускается

Установка, включение и отдельная команда запуска не нужны — DSH сканирует корень
и отслеживает изменения, скиллы попадают в каталог сессии без перезапуска.

- **Неявно:** агент видит каталог (`name` + `description`) и сам загружает
  инструкции, когда задача совпадает. Так работают скиллы без пометки
  `disable-model-invocation`.
- **Явно:** `/имя-скилла` в сообщении пользователя подставляет полный текст
  инструкций в текущий шаг.

У части скиллов в frontmatter стоит `disable-model-invocation: true`. Это значит,
что агент не может вызвать их сам — только вы, явно (например `/grill-me`,
`/to-spec`). В каталоге сессии они поэтому не видны, но на диске лежат и работают.

## Скиллы из mattpocock/skills

Вендоренный набор — 24 папки, скопированные из апстрима как обычные файлы,
которые можно править под себя. Ничего не обновляется втихую: версия зафиксирована
в `SOURCES.json`.

### Engineering

| Скилл | Вызов | Назначение |
|---|---|---|
| `ask-matt` | пользователь | Роутер: какой скилл/флоу подходит под ситуацию |
| `grill-with-docs` | пользователь | Гриллинг + построение доменной модели (`CONTEXT.md`, ADR) |
| `triage` | пользователь | Движение issue по состояниям триажа |
| `improve-codebase-architecture` | пользователь | Поиск возможностей «углубить» модули, отчёт + гриллинг |
| `setup-matt-pocock-skills` | пользователь | Разовая настройка репозитория: issue tracker, метки, доменные доки |
| `to-spec` | пользователь | Превратить текущий разговор в спек и опубликовать его |
| `to-tickets` | пользователь | Разбить план/спек на tracer-bullet тикеты с блокировками |
| `implement` | пользователь | Реализация по спеку/тикетам: TDD на согласованных швах, затем code-review |
| `wayfinder` | пользователь | Планирование объёма работ больше одной сессии как карты решений |
| `prototype` | модель | Выкидной прототип для проверки модели состояний или UI |
| `diagnosing-bugs` | модель | Дисциплинированный цикл диагностики сложных багов и регрессий |
| `research` | модель | Исследование по первоисточникам с сохранением цитируемого MD-файла |
| `tdd` | модель | Red-green-refactor, вертикальными срезами |
| `domain-modeling` | модель | Термины против глоссария, обновление `CONTEXT.md` и ADR |
| `codebase-design` | модель | Словарь и дисциплина «глубоких модулей» |
| `code-review` | модель | Ревью диффа по двум осям (Standards, Spec) параллельными субагентами |
| `resolving-merge-conflicts` | модель | Разрешение конфликтов merge/rebase по смыслу, без `--abort` |
| ~~`wizard`~~ | — | **Не установлен:** генерирует интерактивный bash-скрипт |

### Productivity

| Скилл | Вызов | Назначение |
|---|---|---|
| `grill-me` | пользователь | Жёсткое интервью по плану, пока не закрыты все ветки |
| `handoff` | пользователь | Сжать текущий разговор в документ для другого агента |
| `teach` | пользователь | Обучение теме в несколько сессий, текущая папка как рабочая область |
| `to-questionnaire` | пользователь | Опросник для человека, который может принять решение |
| `wait-what` | пользователь | Переобъяснить непонятное сообщение простым языком |
| `grilling` | модель | Переиспользуемый примитив интервью (за `grill-me`, `triage` и др.) |
| `writing-for-agents` | модель | Как писать документы для агентов: скиллы, `AGENTS.md`, указатели |

### Что не установлено

- **`wizard`** — генерирует bash-скрипт; под Windows неудобно, исключён осознанно.
- **`skills/in-progress/*`** (`claude-handoff`, `implement-spec`, `loop-me`, `pr`,
  `retro`, `setup-ts-deep-modules`, `writing-beats/fragments/shape`) — неопубликованные.
- **`skills/misc/*`** (`git-guardrails-claude-code` — хуки Claude Code,
  `migrate-to-shoehorn` — TypeScript, `scaffold-exercises`, `setup-pre-commit`).
- **`skills/deprecated/*`** — устаревшее.

## Скилл karpathy-guidelines

Правила поведения агента при работе с кодом. Файл `SKILL.md` перенесён из
[multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills)
(MIT) дословно, без правок: четыре принципа — Think Before Coding,
Simplicity First, Surgical Changes, Goal-Driven Execution. Хеш файла записан в
`SOURCES.json`, так что расхождение с апстримом видно через верификатор.

## Проверка и обновление

### Как убедиться, что скиллы подтянулись

Всё держится на двух путях вызова, и каждый проверяется отдельно.

**Модельный путь** (скиллы без `disable-model-invocation`): спросите агента
«какие скиллы тебе доступны» — в каталоге сессии должны быть `code-review`,
`codebase-design`, `diagnosing-bugs`, `domain-modeling`, `grilling`,
`prototype`, `research`, `resolving-merge-conflicts`, `tdd`, `writing-for-agents`
(10 из набора + `karpathy-guidelines` = 11).

**Пользовательский путь**: наберите `/` в поле ввода — DSH строит меню через
`remote.skills.list`, то есть из всех user-invocable скиллов, и для не-модельных
показывает пометку «user only». В меню должны быть все 25 скиллов, из них 14 с
пометкой «user only».

Набор делится так: **11 модельных** (`code-review`, `codebase-design`,
`diagnosing-bugs`, `domain-modeling`, `grilling`, `prototype`, `research`,
`resolving-merge-conflicts`, `tdd`, `writing-for-agents` + `karpathy-guidelines`)
и **14 только пользовательских** (`ask-matt`, `grill-me`, `grill-with-docs`,
`handoff`, `implement`, `improve-codebase-architecture`, `setup-matt-pocock-skills`,
`teach`, `to-questionnaire`, `to-spec`, `to-tickets`, `triage`, `wait-what`,
`wayfinder`).

Проверено, что попытка вызвать пользовательский скилл со стороны модели упирается
в `skill "X" is not available for model invocation` — это признак, что скилл
загружен и его политика вызова прочитана верно, а не что он не найден.

При явном вызове DSH рендерит скилл в блок `<skill_content name="...">` и
подставляет его base directory, поэтому относительные ссылки внутри инструкций
(`./tests.md`, `./CONTEXT-FORMAT.md`) резолвятся от папки скилла. В наборе 40
markdown-ссылок, из них битых нет: 36 ведут на файлы внутри скиллов, 4 —
намеренные примеры в шаблонах (`[Ordering](./src/ordering/CONTEXT.md)` в
`CONTEXT-FORMAT.md`, `[<closed ticket title>](link)` в `wayfinder`).

### Целостность файлов

```powershell
.dsh\skills\verify-set.cmd                 # exit 0 = всё сходится
.dsh\skills\verify-set.cmd -CheckUpstream  # плюс проверка, не ушёл ли апстрим вперёд
```

Скрипт проверяет три вещи: frontmatter каждого `SKILL.md` (имя совпадает с папкой,
есть `description`), SHA-256 всех файлов набора и отсутствие лишних файлов.
`-CheckUpstream` сравнивает записанный commit с текущим `main` апстрима и печатает
ссылку на дифф.

Обновление набора (когда апстрим ушёл вперёд) — это осознанное копирование, а не
автоматика:

```powershell
# 1. скачать апстрим во временную папку
$tmp = Join-Path $env:TEMP 'mp-skills-src'
Invoke-WebRequest -UseBasicParsing 'https://codeload.github.com/mattpocock/skills/tar.gz/refs/heads/main' -OutFile "$tmp\src.tar.gz"
tar -xzf "$tmp\src.tar.gz" -C $tmp
# 2. перенести нужные папки skills/engineering/* и skills/productivity/* (кроме wizard)
# 3. обновить SOURCES.json: commit, version, sha256
# 4. .dsh\skills\verify-set.cmd
```

## Заметки по окружению

- PowerShell 7 (`7.6.6`) установлен и доступен как `pwsh`. Но **инструмент DSH
  запускает команды в Windows PowerShell 5.1** (`$PSVersionTable` внутри
  tool-вызова = `5.1.26100.9444`, `PSEdition Desktop`), так что оба ходят рядом:
  `pwsh` — для ручных запусков, 5.1 — для того, что выполняет агент.
- `-File verify-set.ps1` из 5.1 напрямую не запустится: политика по умолчанию
  `Undefined` (то есть `Restricted`). Поэтому рядом лежит `verify-set.cmd`,
  который предпочитает `pwsh` и падает на `powershell`, вызывая скрипт с
  `-ExecutionPolicy Bypass` для одного процесса. Ничего system-wide не меняется.
- Windows PowerShell 5.1 читает `.ps1` без BOM как ANSI, из-за чего кириллица в
  скриптах превращается в мусор. Файл `verify-set.ps1` записан в UTF-8 **с BOM**
  (pwsh 7 читает такой файл корректно), а сообщения в нём — ASCII. Если будете
  править его из другого инструмента, сохраняйте BOM.
- Кириллица искажается **в тексте самой команды**, ещё до запуска дочернего
  процесса: `pwsh -Command '"Проверка"'` доезжает как `Проверка`, и pwsh пытается
  выполнить это как имя команды. Проверено и на 5.1, и на 7.6.6 — дело не в
  версии PowerShell, а в кодировке командной строки харнеса.
  Практический вывод: в inline-командах держите ASCII, а русский текст либо
  пишите в файл и читайте его через read-инструмент, либо заворачивайте в
  скрипт (`.ps1` с BOM, как `verify-set.ps1`).
