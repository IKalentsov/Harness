# Skill sources — frontend

Section rule: **official first; write your own only when no official skill exists.** A skill
from a source is vendored as a copy, with its source and retrieval date added to its header.

## Official sets

| Source | What to take | Where |
|---|---|---|
| [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) | React and Next.js: components, server and client boundaries, performance, accessibility | `skills/` |
| [anthropics/skills](https://github.com/anthropics/skills) | Work with documents and artefacts (PDF, spreadsheets, slides) — the common part | `shared/skills/` |
| [github/awesome-copilot](https://github.com/github/awesome-copilot) | Code and review techniques with no stack attached | `shared/skills/` |

## What already sits in the section

Source: [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills), MIT, branch
`main`, commit `063bee94c3f4df8453406c830b0a7df0f2860278` (2026-08-28), retrieved 2026-09-21.

| Skill | What is inside | Files |
|---|---|---|
| `react-best-practices` | 70 React performance rules in 8 categories (waterfalls, bundle, server components, client data, re-renders, rendering, JS, advanced patterns) | 76 |
| `composition-patterns` | Component composition: compound components, dropping boolean props, context, React 19 | 15 |
| `react-view-transitions` | The View Transition API in React: navigation, shared elements, Suspense reveals, Next.js | 9 |
| `web-design-guidelines` | Reviewing UI against the Web Interface Guidelines (accessibility, UX) | 2 |
| `writing-guidelines` | Reviewing docs and interface copy for voice and tone | 2 |

The vendoring manifest with paths, commit and deviations is `skills/SOURCES.json`.

**Deviations from the source.** In `react-best-practices` and `react-view-transitions` the
`AGENTS.md` is not vendored: it is the same rules compiled into one document (108 KB in the
first case) and duplicates `rules/` and `references/`. In the `vercel-*` skills the `name`
field of the frontmatter differs from the folder name — that is normal: DSH takes the skill
name from the frontmatter, and the folder only serves as an address.

## Not vendored — fetch on demand

| Skill | Why it is not taken |
|---|---|
| `deploy-to-vercel` | A deployment process for the Vercel platform, not about code |
| `react-native-skills` | A different stack (mobile) |
| `vercel-cli-with-tokens` | Platform CLI and token specifics |
| `vercel-optimize` | Platform-side optimisation, not code |

**How to fetch.** Download the whole set and copy what you need:

```powershell
.\scripts\fetch-sources.ps1 -Source vercel     # -> _vendor/vercel/skills/<name>
```
