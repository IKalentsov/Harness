# Tests

## Levels

| Level | What it checks | What it uses |
|---|---|---|
| Unit | Domain, value objects, validators, use cases with substituted dependencies | Fast, no network and no database |
| Integration | HTTP plus a real database and cache, an end-to-end scenario through the app | Containers, fixtures |
| Architecture | Dependency direction and structural conventions | Assembly inspection (ArchUnitNET or an equivalent) |

- **TDD where a rule is involved:** a failing test on the business rule first, then the
  implementation.
- **One test, one behaviour.** The name describes the scenario and the expected outcome.
- **Duplicated test bodies are removed by parameterisation** (`[Theory]` and the like), not by
  silencing an analyser rule.

## Architecture tests as fitness functions

- Every architecture rule has an executable check: no upward references between layers, no
  `async void`, mandatory type suffixes, no forbidden dependencies.
- **A new boundary comes with a negative fixture:** an assembly that violates it, on which the
  check must fail. Without that, the check is not considered working.
- A rule without an executable check is a wish, not an architecture.

## Keeping the test contour clean

- **References point from tests to code only.** Production projects know nothing about tests:
  no `InternalsVisibleTo`, no "test" branches in the code.
- A test that the design obstructs is a signal to fix the design (an explicit contract,
  dependency injection, a time abstraction), not to add a back door to production code.
- Module tests make no external calls: abstractions are substituted.
- Execution order does not affect the result; tests are isolated by state.

## Acceptance

- The build is clean, with no errors **and no warnings**: under `TreatWarningsAsErrors` a
  warning is a build error.
- All tests are green, including the pre-existing ones: regressions are not acceptable.
- New functionality is covered at the matching level; an exception is granted by the user.
- Tests are run the way the project runs them: the commands come from the project's
  `WORKFLOW.md`, not from memory.
