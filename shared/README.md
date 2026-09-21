# shared — общий раздел

Скиллы и правила, которые верны в любом стеке: дисциплина разработки, ревью, работа
с доменом, отладка, писательство для агентов. Раздел попадает в окружение и бэкенда,
и фронтенда.

## Что здесь

| Путь | Что это |
|---|---|
| `skills/` | 26 скиллов: 24 из [mattpocock/skills](https://github.com/mattpocock/skills) + `karpathy-guidelines` + `architecture-drift-check` |

Источник, версия и хеши вендоренного набора — `skills/SOURCES.json`.
Проверка целостности — `skills/verify-set.cmd` (запускать из каталога `skills`).
Верификатор покрывает 24 скилла из манифеста; `karpathy-guidelines` и
`architecture-drift-check` лежат рядом как отдельные записи и проверяются вручную.
Формальные признаки всех скиллов раздела проверяет `scripts/verify-library.ps1`.

## Что берут из раздела

- **Дисциплина кода:** `karpathy-guidelines`, `codebase-design`, `tdd`, `prototype`.
- **Понимание задачи:** `domain-modeling`, `grilling`, `research`, `wayfinder`.
- **Качество сдачи:** `code-review`, `diagnosing-bugs`, `resolving-merge-conflicts`,
  `architecture-drift-check`.
- **Документы для агентов:** `writing-for-agents`, `handoff`, `teach`.

## Что сюда не кладут

- Всё, что знает про конкретный стек: EF Core, ASP.NET, React, браузер, вёрстку —
  это `backend/` и `frontend/`.
- Роли и процесс проекта: постановки для исполнителя, ревью микро-задач, `ai-tasks`,
  циклы «архитектор → исполнитель». Это `.dsh/AGENTS.md` проекта.
