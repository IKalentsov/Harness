# Skills: which ones the agent reaches on its own

The catalog of skill descriptions sits in the session from the start, so a skill is chosen by
matching that catalog against the task. The library is large; the matching is the work.

- **On a task inside a skill's scope, the skill is loaded.** Read the catalog, take the one
  whose description matches the task, and follow it.
- **A user-invoked skill is reached by pointer.** Skills carrying
  `disable-model-invocation: true` never enter the catalog; the list per section is in
  `shared/README.md`, `frontend/README.md`. The `skill` tool cannot reach them — an instruction
  that names the skill's file by path (`.dsh/skills/<name>/SKILL.md`) can.
- **One skill per task.** A second skill is a separate task.
