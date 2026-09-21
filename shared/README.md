# shared — common section

Skills and rules that hold in any stack: engineering discipline, review, domain work,
debugging, writing for agents. The section goes into both a backend and a frontend harness.

## What is here

| Path | What it is |
|---|---|
| `skills/` | 26 skills: 24 from [mattpocock/skills](https://github.com/mattpocock/skills) + `karpathy-guidelines` + `architecture-drift-check` |

Source, version and hashes of the vendored set — `skills/SOURCES.json`.
Integrity check — `skills/verify-set.cmd` (run it from the `skills` directory).
The verifier covers the 24 skills in the manifest; `karpathy-guidelines` and
`architecture-drift-check` sit next to them as separate entries and are checked by hand.
Formal properties of every skill in the section are checked by `scripts/verify-library.ps1`.

## What is taken from the section

- **Code discipline:** `karpathy-guidelines`, `codebase-design`, `tdd`, `prototype`.
- **Understanding the task:** `domain-modeling`, `grilling`, `research`, `wayfinder`.
- **Quality of delivery:** `code-review`, `diagnosing-bugs`, `resolving-merge-conflicts`,
  `architecture-drift-check`.
- **Documents for agents:** `writing-for-agents`, `handoff`, `teach`.

## What does not go here

- Anything that knows a concrete stack — EF Core, ASP.NET, React, the browser, layout:
  that is `backend/` and `frontend/`.
- Roles and project process: briefs for an executor, micro-task reviews, `ai-tasks`,
  "architect → executor" cycles. That is the project's own `.dsh/AGENTS.md`.
