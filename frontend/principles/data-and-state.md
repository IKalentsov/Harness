# Data, state and forms

## Server data

- **A query library only** (TanStack Query and the like). The effect-plus-fetch pair and
  home-made caches are out.
- **A query key comes from the feature's key factory** and carries every request parameter: a
  key that lost a parameter serves someone else's data from the cache.
- `queryFn` lives in `features/<name>/api/`; a component calls the feature's hook, never the
  client directly.
- **A mutation invalidates the affected keys** when it settles. A mutation without invalidation
  leaves stale data on screen.
- An API response is validated against a schema before it reaches the UI: an unknown shape is
  an error, not "we will render something".

## Client state

- **Client state is for client concerns only.** Server data is not duplicated in a client store.
- A local store (Zustand) holds UI state and drafts that have not been applied yet.
- **State that must be shareable through a link lives in the URL** (query, filters, sorting,
  page): a link to a result survives a reload and forwarding.
- Derived values are computed, not stored as a second field.

## Forms

- Only the form-plus-schema pair (`react-hook-form` + `zod` through a resolver); a separate
  `useState` per field is out.
- **The schema is the single source of the form's type** (inferred from the schema), not a
  hand-written interface next to it.
- Error messages come from the schema and are not duplicated in the markup.
- A validation error is tied to its field: invalid and described-by attributes are set on the
  input element.

## API client

- The client and its hooks are **generated from the backend OpenAPI schema**; generated files
  in the repository are never edited by hand.
- When the backend schema changes, the client is regenerated in the same change; a divergence
  is caught by CI.
- The UI works only through the feature's hooks: calling the client directly from a component
  is out.
