# Harness

Воркспейс для сессий DeepSeek Harness, настроенный **локально под этот проект**:
здесь лежит скилл `karpathy-guidelines`, установленный только для этого
воркспейса, а не глобально.

## Структура

```
.dsh/skills/karpathy-guidelines/SKILL.md   скилл: проектный скоуп DSH
.gitignore                                 .dsh/ — локальное состояние харнеса
```

## Скилл karpathy-guidelines

Правила поведения агента при работе с кодом. Файл `SKILL.md` перенесён из
[multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills)
(MIT) дословно, без правок: четыре принципа — Think Before Coding,
Simplicity First, Surgical Changes, Goal-Driven Execution.

### Почему это проектный скоуп

DSH ищет локальные скиллы по корням с приоритетом (меньший ранг важнее):

| Ранг | Источник | Путь |
|---|---|---|
| 100 | проект | `<projectRoot>/.dsh/skills` |
| 200 | проект | `<projectRoot>/.agents/skills` |
| 400 | пользователь | `<dshHome>/skills` |

Корень проекта — ближайший каталог с `.git`, иначе текущий рабочий каталог.

Скилл лежит в `.dsh/skills` внутри корня проекта, а не в `%USERPROFILE%\.dsh\skills`,
поэтому он виден только в этом воркспейсе и не появляется в других проектах.

### Как запускается

Установка, включение и отдельная команда запуска не нужны — DSH сканирует корень
и отслеживает изменения, скилл попадает в каталог сессии без перезапуска.

- **Неявно:** агент видит каталог (`name` + `description`) и сам загружает
  инструкции перед работой с кодом — условия применения описаны в `description`.
- **Явно:** `/karpathy-guidelines` в сообщении пользователя подставляет полный
  текст инструкций в текущий шаг.

### Обновление из апстрима

```powershell
irm https://raw.githubusercontent.com/multica-ai/andrej-karpathy-skills/main/skills/karpathy-guidelines/SKILL.md `
  -OutFile .dsh/skills/karpathy-guidelines/SKILL.md
```

Файл можно сравнить с апстримом напрямую — он не переписывался.
