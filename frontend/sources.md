# Источники скиллов — frontend

Правило раздела: **сначала официальное, своё — только если официального нет.** Скилл
из источника вендорится копией, в шапку добавляется источник и дата получения.

## Официальные наборы

| Источник | Что берём | Куда |
|---|---|---|
| [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) | React и Next.js: компоненты, серверные и клиентские границы, производительность, доступность | `skills/` |
| [anthropics/skills](https://github.com/anthropics/skills) | Работа с документами и артефактами (PDF, таблицы, слайды) — общая часть | `shared/skills/` |
| [github/awesome-copilot](https://github.com/github/awesome-copilot) | Приёмы работы с кодом и ревью, не привязанные к стеку | `shared/skills/` |

## Что уже лежит в разделе

Источник: [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills), MIT,
ветка `main`, коммит `063bee94c3f4df8453406c830b0a7df0f2860278` (2026-08-28), получено 2026-09-21.

| Скилл | Что внутри | Файлов |
|---|---|---|
| `react-best-practices` | 70 правил производительности React по 8 категориям (водопады, бандл, серверные компоненты, клиентские данные, ре-рендеры, рендеринг, JS, продвинутые приёмы) | 76 |
| `composition-patterns` | Композиция компонентов: compound components, отказ от boolean-пропов, контекст, React 19 | 15 |
| `react-view-transitions` | View Transition API в React: навигация, shared elements, Suspense-reveal, Next.js | 9 |
| `web-design-guidelines` | Ревью UI по Web Interface Guidelines (доступность, UX) | 2 |
| `writing-guidelines` | Ревью текстов документации и интерфейса на соответствие голосу и тону | 2 |

Манифест вендоринга с путями, коммитом и отклонениями — `skills/SOURCES.json`.

**Отклонения от источника.** У `react-best-practices` и `react-view-transitions` не
вендорен `AGENTS.md`: это скомпилированная версия тех же правил (у первого — 108 КБ),
она дублирует `rules/` и `references/`. У скиллов `vercel-*` поле `name` в frontmatter
отличается от имени папки — это нормально: DSH берёт имя скилла из frontmatter, а папка
служит только адресом.

## Не вендорено (решение пользователя)

| Скилл | Почему не взят |
|---|---|
| `deploy-to-vercel` | Процесс деплоя на платформу Vercel, а не про код |
| `react-native-skills` | Другой стек (мобильная разработка) |
| `vercel-cli-with-tokens` | Специфика CLI платформы и работы с токенами |
| `vercel-optimize` | Оптимизация на платформе Vercel, а не в коде |

## Как забрать набор

```powershell
# на машине с сетью (из песочницы DSH сеть закрыта)
.\scripts\fetch-sources.ps1 -Source vercel,anthropic,copilot
```

Скрипт клонирует источники в `_vendor/` (каталог не коммитится); оттуда нужные скиллы
переносятся в `skills/` вручную, с указанием источника и даты.
