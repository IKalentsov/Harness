# Build toolchain

## Centralised settings

| File | Purpose |
|---|---|
| `Directory.Build.props` | TFM, `Nullable`, `ImplicitUsings`, analysers, `TreatWarningsAsErrors`, style rules at build time |
| `Directory.Packages.props` | **Every** package version; `.csproj` files carry `<PackageReference>` without `Version` |
| `.globalconfig` | Analyser rule severities (levels, not versions) |
| `global.json` | SDK version pinning and the test runner mode |
| `.gitignore` | Build output and files holding real secrets |

- **A package version is stated in exactly one place** — `Directory.Packages.props`. Editing a
  version in a `.csproj`, or adding a package outside the central file, is a mistake.
- **Versions are pinned exactly and deliberately.** Floating tags, ranges and `latest` are out.
  A version bump is a separate change, made after reading the release notes.
- Shared build properties are inherited by every project in the solution automatically;
  repeating them in individual `.csproj` files is unnecessary.

## Analysers and warnings

- Enabled: general style and refactoring rules, security and correctness rules, async/await
  rules, and a code-quality and security analyser.
- `TreatWarningsAsErrors` plus the top analysis level is a deliberate mode: the build must be
  clean, not nearly clean.
- **Silencing an analyser is not a substitute for fixing the code.** The order of work on a
  finding:
  1. fix the code — the analyser is almost always right;
  2. suppression (`#pragma`, an attribute, an edit to `.globalconfig`) is not done on one's own;
  3. the user is told: the rule code, its exact text, the file and line, and whether the case
     is single or widespread. The decision is theirs.
- **The project keeps a registry of disabled rules:** the rule, the reason, the date, who
  decided. A suppression without a registry entry does not count as a decision.
- "The rule is absent from `.globalconfig`, therefore it is off" is **false**: the SDK enables
  hundreds of rules by default, and only a build reveals the truth.

## Building inside the agent environment

- A multi-process build uses named pipes, which the sandbox blocks: build and restore run with
  `-m:1`.
- Without network access the NuGet audit turns into an error: restore runs with the audit
  disabled or from the local cache.
- Packages missing from the cache are restored by the user; the agent builds without restore.
- Running the application and its containers is the user's job; the agent builds and tests.
