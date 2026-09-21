# Quality and definition of done

## Lint and types

- ESLint (flat config) and `tsc --noEmit` pass with **no errors and no warnings**.
- Forbidden without a justifying comment: `any`, type suppression (`@ts-expect-error`,
  `@ts-ignore`), double casting through `unknown`, default exports (except where a tool
  requires them), barrel files.
- **A linter or type rule is not switched off instead of fixing the code.** Relaxing a rule is
  the user's decision, with a reason and a registry entry in the project.
- A git hook runs lint and types on the changed files: a defect does not reach review.

## Tests

| Level | What it checks |
|---|---|
| Unit | Utilities, reducers, pure functions, validation schemas |
| Component | Component behaviour through accessible roles and text (React Testing Library) |
| Integration | A screen with a substituted network (MSW): loading, empty, error, success |
| End-to-end | A critical user path in a browser (Playwright) |

- Tests check **behaviour, not implementation**: markup snapshots and reaching into internal
  state are out.
- The network is substituted at the request level, not by mocking modules.
- New functionality arrives with a test at the matching level.

## Definition of done

1. `typecheck` and `lint` pass with no errors and no warnings.
2. Tests are green; new functionality is covered at the matching level.
3. The build passes and the bundle stays inside the project's budget.
4. The screen implements every mandatory state and passes the accessibility checklist.
5. State that must be shareable through a link is reproducible from the URL.
6. No forbidden techniques; new dependencies are either absent or agreed.
7. Documentation and derived artefacts (the generated client, the stack schema) are updated
   when versions, structure or a contract changed.

## Red lines

- Switching off a linter or type rule instead of fixing the code.
- Committing a generated client that diverges from the backend OpenAPI schema.
- Duplicating server data into a client store or local state "for convenience".
- Working around types and "temporarily" breaking the import direction between features.
- Editing generated code by hand.
- Implementing a screen without handling the empty result and the error.
- Adding a dependency without justification and a check of its licence and freshness.
