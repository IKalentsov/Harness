# Источник скилла: composition-patterns

- **Репозиторий:** [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills)
- **Путь в репозитории:** `skills/composition-patterns/`
- **Ветка:** `main`
- **Коммит:** `063bee94c3f4df8453406c830b0a7df0f2860278` (28.08.2026)
- **Дата получения:** 2026-09-21
- **Лицензия:** MIT (указана в README репозитория и в поле `license` файла `SKILL.md`; отдельного файла `LICENSE` в корне репозитория нет)
- **Способ получения:** `web_fetch` + `write`; каждый файл сверен с git-blob-SHA1 из GitHub API — размер и SHA-1 совпали побайтово.

## Что вендорено

13 файлов, 27 712 байт.

| Файл | Байт |
|---|---|
| `SKILL.md` | 2886 |
| `README.md` | 2140 |
| `metadata.json` | 530 |
| `rules/_sections.md` | 829 |
| `rules/_template.md` | 329 |
| `rules/architecture-avoid-boolean-props.md` | 2267 |
| `rules/architecture-compound-components.md` | 2600 |
| `rules/patterns-children-over-render-props.md` | 1886 |
| `rules/patterns-explicit-variants.md` | 2395 |
| `rules/react19-no-forwardref.md` | 953 |
| `rules/state-context-interface.md` | 4974 |
| `rules/state-decouple-implementation.md` | 2699 |
| `rules/state-lift-state.md` | 3224 |

## Не вендорено

- Бинарных и не-текстовых файлов внутри скилла нет.
- `AGENTS.md` (22 627 байт) — скомпилированная версия тех же правил (`SKILL.md` + `rules/**`
  одной сборкой). **Удалён из базы:** DSH читает любой `AGENTS.md` в дереве как инструкции
  каталога, поэтому он автоматически грузился бы в контекст каждой сессии и дублировал
  `SKILL.md` вместе с `rules/**`. Доступен по источнику:
  <https://raw.githubusercontent.com/vercel-labs/agent-skills/main/skills/composition-patterns/AGENTS.md>

## Замечания

- `SKILL.md` и frontmatter не правились: поле `name` равно `vercel-composition-patterns`
  и не совпадает с именем каталога `composition-patterns` — так в источнике. DSH берёт имя
  скилла из frontmatter, поэтому расхождение безопасно; `scripts/verify-library.ps1`
  вендоренные имена с именем папки не сверяет.

Локальная копия, автообновления нет: при изменениях у источника обновлять вручную.
