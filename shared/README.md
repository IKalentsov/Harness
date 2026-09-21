# shared — common section

Skills and rules that hold in any stack: engineering discipline, review, domain work,
debugging, writing for agents. The section goes into both a backend and a frontend harness.

## What is here

| Path | What it is |
|---|---|
| `skills/` | 26 skills: 24 from [mattpocock/skills](https://github.com/mattpocock/skills) + `karpathy-guidelines` + `architecture-drift-check` |

Source, version and hashes of the vendored set — `skills/SOURCES.json`.
Integrity check — `skills/verify-set.cmd` (run it from the `skills` directory).
The manifest covers the 24 `mattpocock/skills` entries. `karpathy-guidelines` comes from another
repository and records its blob hash in `SOURCE.md`; `architecture-drift-check` is written for
this base and has no source. Every vendored skill carries a `SOURCE.md` next to `SKILL.md`.
Formal properties of every skill in the section are checked by `scripts/verify-library.ps1`.

## The pipeline

The Matt Pocock set is not a flat list, it is a flow. `ask-matt` is the router that owns the
description of that flow (`SKILL.md` plus `PHASE-BOUNDARIES.md` next to it); the table below is
the short version, and `ask-matt` stays the single source of truth.

| Phase | Skill | Who starts it |
|---|---|---|
| Which skill fits this situation | `ask-matt` | person |
| Sharpen an idea by interview | `grill-with-docs` (keeps `CONTEXT.md` and ADRs) or `grill-me` when there is no working directory | person |
| Settle the words while you go | `domain-modeling` | model |
| Answer a question with throwaway code | `prototype`, bridged on both sides by `handoff` | model |
| Turn the thread into a spec | `to-spec` | person |
| Split it into tracer-bullet tickets | `to-tickets` | person |
| Build one ticket | `implement` — drives `tdd`, closes with `code-review` | person |
| Raw issues piling up | `triage` | person |
| Something is broken | `diagnosing-bugs`; a missing seam hands off to `improve-codebase-architecture` | model |
| A huge, foggy effort | `wayfinder`, which hands off to `to-spec` rather than building | person |
| Keep the codebase habitable | `improve-codebase-architecture` (the survey) and `codebase-design` (the vocabulary) | mixed |
| Keep the context sharp | `handoff`, `wait-what`, `research`, `teach`, `to-questionnaire` | mixed |
| The architecture document drifted | `architecture-drift-check` | model |

Steps 1–3 belong to one unbroken context window: the grilling, the spec and the tickets build
on the same thinking. Each `implement` then starts fresh from its ticket.

## Who can invoke what

`disable-model-invocation: true` keeps a skill out of the catalog and out of the `skill` tool;
its only entry point is a person typing `/name`. In this section that is 14 of 26 skills:

`ask-matt`, `grill-me`, `grill-with-docs`, `handoff`, `implement`,
`improve-codebase-architecture`, `setup-matt-pocock-skills`, `teach`, `to-questionnaire`,
`to-spec`, `to-tickets`, `triage`, `wait-what`, `wayfinder`.

The other 12 the model reaches on its own: `architecture-drift-check`, `codebase-design`,
`code-review`, `diagnosing-bugs`, `domain-modeling`, `grilling`, `karpathy-guidelines`,
`prototype`, `research`, `resolving-merge-conflicts`, `tdd`, `writing-for-agents`.

The flag is upstream frontmatter and is not edited here. A harness that wants the agent to run
the pipeline unaided has to say so in the project's own `AGENTS.md` — a project skill or an
explicit instruction, not a change to a vendored file.

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
