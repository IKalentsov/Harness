# API and external integrations

## HTTP contract

- **A thin controller:** validate input → call the use case → map the result to an HTTP
  response. No business logic in the controller.
- **Contracts are separate DTOs**, not domain entities: the domain does not leak outward.
- **One error shape** (ProblemDetails or a single error response type); no bare 500s and no
  stack traces on the wire.
- **Versioning from day one:** the `/api/v{n}` prefix.
- **Documentation comes from the code:** OpenAPI is generated, and an interactive page
  (Scalar or an equivalent) is available in the development environment.
- **Health checks are split:** `/health/live` — the process is alive; `/health/ready` — it can
  serve traffic (database, cache, external dependencies).
- **A correlation ID** is taken from the header or generated, and reaches every log line and
  the response.

## Outbound calls

- Only through an HTTP client factory and typed clients; base addresses and keys come from
  configuration, never from code.
- Mandatory: a timeout, retries with backoff and jitter, a circuit breaker, a concurrency
  limit and respect for the remote side's rate limits.
- **A raw external response never reaches the domain.** It is first mapped into our own model,
  then validated, then logged as a fact and a result.
- Parsing and scraping live in their own layer, with fixtures in tests.
- **External API secrets** come from environment variables or user secrets only; in
  `appsettings.json` there are empty placeholders.
- An external failure does not travel through the layers as an exception: infrastructure
  catches the concrete exceptions and returns a typed error.

## Responsibility boundaries

| Layer | Does | Does not |
|---|---|---|
| Controller | Accepts the request, validates the shape, returns a response | Hold domain rules |
| Use case | Orchestrates domain and infrastructure, owns the transaction | Know about HTTP |
| Domain | Rules and invariants | Know about a database, the network or DI |
| Infrastructure | Implements abstractions, absorbs the outside world's exceptions | Make business decisions |
