# Observability and configuration

## Logs

- **Structured logs** (Serilog or the built-in structured logger). The message template
  carries named properties, and values are passed as parameters.
- **String interpolation in log templates is forbidden:** it turns structure into a string and
  kills field-based search.
- **We log:** incoming requests (minus sensitive data), the outcome of a use case, failures of
  outbound calls with their context (provider, request, status, duration), and timing metrics.
- **We do not log:** tokens, keys, passwords, personal data, full external responses. Secrets
  that reach an exception object or a URL are masked.
- Levels are meaningful: `Error` needs a human, `Warning` is a deviation from the norm,
  `Information` is a lifecycle event. A "just in case" log line on every step is not written.

## Configuration

- Settings go through typed option objects (`IOptions<T>`) bound to sections; reading by a
  string key deep inside the code is not practised.
- Sources: `appsettings.json` (structure and empty placeholders) →
  `appsettings.{Environment}.json` (environment values) → environment variables →
  user secrets (locally).
- **No secrets in the repository.** The file with real values is closed by `.gitignore`;
  a template without values (`.env.example`, `appsettings.Development.json` with placeholders)
  stays in the repository.
- **A missing or empty secret does not crash the application at start-up:** settings
  validation reports what is missing, and the application either continues in a limited mode
  or stops with a clear message — it never keeps running quietly in a wrong state.
- Configuration is validated at start-up: required fields, ranges, mutual dependencies.

## Errors and diagnosis

- A log record answers three questions: what was being done, what was expected, what happened.
- One exception, one record. Re-logging at every layer is out: whoever handles the error logs
  it.
- Diagnostic messages for the user are separate from technical detail: the user gets a clear
  text and a next step, the log gets the technical context.
