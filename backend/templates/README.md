# Backend build templates

Ready-to-copy files that set the shared build rules for all projects of the
solution. They are placed in the root of the project's `backend/` directory.

| File | What it sets | What to substitute per project |
|---|---|---|
| `Directory.Build.props` | TFM, `Nullable`, `ImplicitUsings`, `TreatWarningsAsErrors`, style rules in the build, analyzer hookup | The target .NET version and the set of analyzers |
| `Directory.Packages.props` | Central version management: all package versions only here | Your own set of packages and versions (the template holds examples and shared ones) |
| `.globalconfig` | Analyzer rule levels: severity and suppressions | Your own suppressions — with a reason and an entry in the project registry |
| `global.json` | Test run mode (Microsoft.Testing.Platform) | The SDK version, if the project pins it |
| `.gitignore` | Build exclusions and files with real secrets | Paths to local settings and secret files |

## Order of application

1. Copy the files into the root of `backend/`.
2. Replace the sample packages in `Directory.Packages.props` with the actual ones; write versions
   exactly, without ranges and `latest`.
3. Do not specify versions in `.csproj` — only `<PackageReference Include="..." />`.
4. Check the build: with `TreatWarningsAsErrors` it must be clean.

## Caveats

- **Suppressions in `.globalconfig` are not a universal truth.** The template holds rules
  disabled in the source project, with comments. Each project decides for itself; the registry
  of disabled rules is kept in the project.
- **`global.json` without an SDK version** pins only the test runner mode. If the project
  requires a specific SDK — add the `sdk` field.
- **Files with secrets** must not end up in the repository: real values — in environment
  variables or in a local file excluded by `.gitignore`; only placeholders and examples remain
  in the repository.
