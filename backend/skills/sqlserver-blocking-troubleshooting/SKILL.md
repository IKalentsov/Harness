---
name: sqlserver-blocking-troubleshooting
description: "Finding the head blocker in SQL Server and diagnosing the causes of long blocking with DMVs and Extended Events, with typical scenarios and resolutions. USE WHEN: queries hang, application timeouts, blocking, \"who holds the lock\", deadlocks, KILLED/ROLLBACK, uncommitted transaction. Keywords: SQL Server, blocking, head blocker, sys.dm_exec_requests, blocking_session_id, sys.dm_tran_locks, wait_type, Extended Events, deadlock, T-SQL."
whenToUse: "When queries block each other, the application hits timeouts, or the session holding a lock must be found."
---

# Troubleshooting Blocking in SQL Server

> **Source:** compiled from the official Microsoft article "Understand and resolve SQL Server blocking problems"
> (KB 224453) — https://learn.microsoft.com/en-us/troubleshoot/sql/database-engine/performance/understand-resolve-blocking,
> retrieved 2026-09-21, article last updated 2026-08-04. Local copy, no automatic updates.

## What Counts as Normal

Blocking is a normal property of any relational database engine that uses locks. A problem begins when
a session holds locks **for a long time** or **never releases them**: throughput drops and
the application starts hitting timeouts.

How long locks are held is determined by the transaction and the isolation level:
- outside a transaction, `SELECT` holds locks only for the moment the resource is read;
- `INSERT`/`UPDATE`/`DELETE` hold locks for the duration of the statement;
- inside a transaction — until it completes.

## Investigation Order

1. Find the **head blocker** — the session at the head of the blocking chain.
2. Find the query and the transaction that hold locks for a long time.
3. Understand **why** this happens.
4. Fix the cause: rework the query and the transaction (do not "tune" the server).

## Collecting Data

**Quick ways in SSMS:**
- Object Explorer → Reports → Standard Reports → **Activity - All Blocking Transactions**
  (shows the transactions at the head of the chain, Blocking SQL Statement and Blocked SQL Statement);
- Activity Monitor, the **Blocked By** column.

**DMVs/DMFs:**
- `sys.dm_exec_requests` — the `blocking_session_id` column (`0` = not blocked);
- `sys.dm_exec_sessions` — all connections, including inactive ones;
- `sys.dm_exec_sql_text(sql_handle)` — the text of the running batch (`NULL` = no query is running);
- `sys.dm_exec_input_buffer(session_id, request_id)` — the last text submitted to the engine;
- `sys.dm_os_waiting_tasks` — the `wait_type` values active requests are waiting on;
- `sys.dm_tran_locks` — which locks are held (careful: on production it returns many rows);
- `sys.dm_tran_active_transactions`, `sys.dm_tran_session_transactions`,
  `sys.dm_tran_database_transactions` — open transactions and how long they have been open.

A short "who blocks whom" query:

```sql
SELECT r.session_id, r.blocking_session_id, r.wait_type, r.wait_time, r.wait_resource,
       r.status, r.command, t.text
FROM sys.dm_exec_requests AS r
OUTER APPLY sys.dm_exec_sql_text(r.sql_handle) AS t
WHERE r.blocking_session_id <> 0;
```

Large ready-made scripts (the full blocking chain, the list of locks held per table)
are given in the source article KB 224453 — take them from there rather than inventing your own.

**Extended Events (SQL Trace and SQL Server Profiler are deprecated).** To troubleshoot blocking you
usually enable the categories: `blocked_process_report`, `lock_deadlock`, `attention`, `error_reported`,
`sql_batch_starting`/`sql_batch_completed`, `rpc_starting`/`rpc_completed`, `login`/`logout`,
`existing_connection`, as well as the warnings `sort_warning`, `hash_warning`,
`missing_join_predicate`, `missing_column_statistics`.
`blocked_process_report` **is not produced by default** — the threshold is set with the
`blocked process threshold` option through `sp_configure` (in seconds).

## Typical Scenarios

`wait_type`, `open_transaction_count`, and `status` come from `sys.dm_exec_requests`
and `sys.dm_exec_sessions`.

| # | wait_type | open_tran | status | Will it resolve on its own? | Symptoms |
|---|-----------|-----------|--------|-----------------------------|----------|
| 1 | NOT NULL | >= 0 | runnable | Yes, when the query completes | `reads`, `cpu_time`, `memory_usage` grow; long query duration |
| 2 | NULL | > 0 | sleeping | No, but the SPID can be killed | `attention` is visible in XEvents — a timeout or a canceled query |
| 3 | NULL | >= 0 | runnable | No, until the client consumes all rows or closes the connection | `open_transaction_count = 0` under READ COMMITTED is a typical sign |
| 4 | varies | >= 0 | runnable | No, until the client cancels the queries or closes the connections | the head blocker's `hostname` matches the `hostname` of the blocked session |
| 5 | NULL | > 0 | rollback | Yes | `attention` in XEvents: timeout, cancellation, or rollback |
| 6 | NULL | > 0 | sleeping | Eventually — when the OS determines the session is inactive | `last_request_start_time` is well before the current time |

## Resolutions

- **Scenario 1** — optimize the query (this is a performance issue): look at Query Store, and if that
  is not possible, move the heavy query off OLTP to a reporting system or a read-only replica.
  Also account for lock escalation (row/page → table): keep transactions short.
- **Scenario 2** — the application must run `IF @@TRANCOUNT > 0 ROLLBACK TRAN` in its error handler;
  for procedures that start a transaction, consider `SET XACT_ABORT ON`. Keep in mind that with
  connection pooling the transaction lives until the connection is reused.
- **Scenario 3** — the application must consume **all** rows of the result set to the end;
  server-side paging with `OFFSET/FETCH` does not conflict with this.
- **Scenario 4 (distributed deadlock)** — SQL Server cannot detect it, because one of the parties
  lives at the application level. A configured query timeout helps by breaking the deadlock.
- **Scenario 5 (`KILLED/ROLLBACK`)** — wait for the rollback to finish; forcibly stopping the instance
  is usually counterproductive. Do not run large batch operations during peak hours.
- **Scenario 6 (orphaned transaction)** — fix the error handling in the application
  (`try/catch/finally`, `SET XACT_ABORT ON`); the connection can be terminated with `KILL <spid>`.

## Limitations and Cautions

- `KILL` can take up to 30 seconds; do not kill sessions blindly, without understanding the cause.
- Diagnose the application side too: timeouts, query cancellation, connection management,
  and consuming all rows are common sources of blocking.
- Take DMV snapshots over time: a single measurement does not show a trend.
