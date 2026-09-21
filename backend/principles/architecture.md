# Solution architecture

## Layers and dependency direction

Clean Architecture, dependencies strictly inward:

```
Web ──▶ Infrastructure.* ──▶ Core (Application) ──▶ Domain ◀── Contracts
```

- `Domain` — entities, value objects, domain rules, invariants. BCL only: no packages, no
  references to other projects, no knowledge of a database, HTTP or DI.
- `Core` / `Application` — use cases, validators, abstractions of the outside world.
  Knows nothing about Infrastructure.
- `Infrastructure.*` — implementations of those abstractions: database, cache, external APIs.
  Split by technology (`Infrastructure.Postgres`, `Infrastructure.Redis`, ...).
- `Web` — transport: controllers, middleware, DI composition.
- `Contracts` — outbound DTOs; may lean on domain types.

The direction is enforced by architecture tests, not by agreement.

## Solution layout

```
backend/
├── Directory.Build.props      # TFM, analysers, TreatWarningsAsErrors
├── Directory.Packages.props   # every package version — here and nowhere else
├── .globalconfig              # analyser rule severities
├── global.json                # SDK pinning
├── tools/                     # build scripts
├── src/<Product>.<Layer>/     # one project per layer
└── tests/
    ├── <Product>.UnitTests/
    ├── <Product>.IntegrationTests/
    └── <Product>.ArchitectureTests/
```

## Domain patterns (mandatory)

1. **Result Pattern.** Expected business errors are returned as values (`Result<T>`,
   `Result<T, Error>`); exceptions are reserved for exceptional situations such as an
   infrastructure failure. An error is typed and carries a code, not one string for everything.
2. **Value objects instead of primitives.** Money, identifiers, ratings, addresses are
   distinct types. Validation lives in the value object's factory, not in a controller or a
   service.
3. **Strongly-typed IDs** for aggregate identifiers.
4. **Entity factories.** `public static Result<T> Create(...)`; there are no public
   constructors facing outward and no setters that break invariants.
5. **Aggregates reference each other by ID.** No navigation collections across an aggregate
   boundary.
6. **Timestamps** for creation and update (UTC) on every persisted entity.
7. **Explicit input validation** at the use-case boundary, with a single error shape.

## What counts as a design mistake

- An anaemic model and "services that do everything", with the logic collected in one class.
- Public setters on entities.
- Logic inside controllers or ORM configurations.
- A use case that knows a concrete database or HTTP client directly.
- An abstraction added "for the future" with no second implementation and no test.
