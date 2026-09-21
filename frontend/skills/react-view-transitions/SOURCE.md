# Источник скилла: react-view-transitions

- **Репозиторий:** [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills)
- **Путь в репозитории:** `skills/react-view-transitions/`
- **Ветка:** `main`
- **Коммит:** `063bee94c3f4df8453406c830b0a7df0f2860278` (28.08.2026, «Merge pull request #328 … Update React View Transitions guidance and troubleshooting»)
- **Дата получения:** 2026-09-21
- **Лицензия:** MIT (указана в README репозитория; отдельного файла `LICENSE` в корне репозитория нет)
- **Способ получения:** `web_fetch` + `write`, а для шести файлов (`metadata.json`, `README.md`, `references/css-recipes.md`, `references/implementation.md`, `references/nextjs.md`, `references/patterns.md`) — прямая загрузка `curl -sSL --fail`, потому что `web_fetch` искажал содержимое при декодировании (размер выходил меньше на 1–177 байт, SHA-1 не сходился). Каждый файл сверен с git-blob-SHA1 из GitHub API — размер и SHA-1 совпали побайтово.

## Что вендорено

8 файлов, 62 688 байт.

| Файл | Байт |
|---|---|
| `SKILL.md` | 14407 |
| `README.md` | 2231 |
| `metadata.json` | 852 |
| `references/css-recipes.md` | 8337 |
| `references/implementation.md` | 9280 |
| `references/nextjs.md` | 10700 |
| `references/patterns.md` | 11941 |
| `references/troubleshooting.md` | 4940 |

## Не вендорено

- Бинарных и не-текстовых файлов внутри самого скилла нет.
- `AGENTS.md` — скомпилированная версия тех же материалов (`SKILL.md` + `references/**` одной сборкой, 58 993 байта), не вендорена: дублирует уже скачанные файлы, доступна по источнику
  <https://raw.githubusercontent.com/vercel-labs/agent-skills/main/skills/react-view-transitions/AGENTS.md>.
- Рядом со скиллом в репозитории лежит бинарный артефакт `skills/react-view-transitions.zip` (28 866 байт) — упакованная версия того же скилла. Не скачивался (бинарь), в локальную копию не входит.

## Замечания

- `SKILL.md` и frontmatter не правились: поле `name` равно `vercel-react-view-transitions` и не совпадает с именем каталога `react-view-transitions` (так в источнике). `scripts/verify-library.ps1` из-за этого сообщает `frontmatter name does not match the folder`.

Локальная копия, автообновления нет: при изменениях у источника обновлять вручную.
