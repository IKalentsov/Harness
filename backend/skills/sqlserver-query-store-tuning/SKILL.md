---
name: sqlserver-query-store-tuning
description: "Working with SQL Server Query Store — enabling it, monitoring its state, recovering from read-only, finding query regressions, and forcing plans. USE WHEN: a query got slower, the top resource-consuming queries must be found, plans \"flip\", Query Store went read-only. Keywords: SQL Server, Query Store, sys.database_query_store_options, regressed queries, forced plan, execution plan, T-SQL."
whenToUse: "When query performance regressions must be found and plans stabilized with Query Store."
---

# Query Store: Monitoring and Plan Stabilization

> **Source:** compiled from the official Microsoft articles
> "Best practices for monitoring workloads with Query Store"
> (https://learn.microsoft.com/en-us/sql/relational-databases/performance/best-practice-with-the-query-store,
> updated 2026-07-20) and "Monitor performance by using the Query Store"; retrieved 2026-09-21.
> Local copy, no automatic updates. Applies to SQL Server 2016 and later.

## Enabling

```sql
ALTER DATABASE [DatabaseOne] SET QUERY_STORE = ON;
```

A representative workload data set usually takes about a day to accumulate, but the data can be analyzed
right away.

## Monitoring State (regularly)

Query Store can switch operating mode **silently**. Check it with:

```sql
SELECT actual_state_desc, desired_state_desc, current_storage_size_mb, max_storage_size_mb,
       readonly_reason, interval_length_minutes, stale_query_threshold_days,
       size_based_cleanup_mode_desc, query_capture_mode_desc
FROM sys.database_query_store_options;
```

A mismatch between `actual_state_desc` and `desired_state_desc` means the mode was changed automatically,
most often a switch to read-only. `readonly_reason = 65536` means the size quota was exceeded.

## Returning to Read-Write

```sql
ALTER DATABASE [QueryStoreDB]
SET QUERY_STORE (OPERATION_MODE = READ_WRITE);
```

Before that, if necessary: increase `MAX_STORAGE_SIZE_MB` and/or clear the data
(`ALTER DATABASE [QueryStoreDB] SET QUERY_STORE CLEAR;`).

ERROR state: starting with SQL Server 2017 — turn Query Store off, run
`sys.sp_query_store_consistency_check` in the database, then turn it on and switch it to READ_WRITE.
For SQL Server 2016 — clear (`CLEAR`) and re-enable.

Prevention: keep the size below the maximum, enable size-based and time-based cleanup,
and set `QUERY_CAPTURE_MODE = AUTO`.

## SSMS Views and When to Use Them

| View | What it is for |
|---|---|
| Regressed Queries | queries whose metrics got worse — tie complaints to specific queries |
| Overall Resource Consumption | overall resource consumption by the database, daily and nightly patterns |
| Top Resource Consuming Queries | the most expensive queries over the selected interval |
| Queries With Forced Plans | all currently forced plans |
| Queries With High Variation | queries with high variability: duration, CPU, IO, memory |
| Query Wait Statistics | wait categories and the contribution of queries to them (SSMS 18+, SQL Server 2017+) |
| Tracked Queries | watching important queries in real time |

## What to Do Once the Problem Is Found

- **The plan got worse** → force the plan. If forcing fails,
  an XEvent fires and the optimizer compiles the query in the usual way.
- **An index is missing** → this is visible in the execution plan; create the index and check the effect
  in Query Store. Before creating it, run the index verification — see the `sqlserver-index-verification` skill.
- **A large gap between estimated and actual rows** → consider forcing a statistics recompilation.
- **A bad query** → rewrite it, including for the sake of parameterization.

## Non-Parameterized Queries

They break plan reuse and bloat Query Store. To find them:

```sql
SELECT qsq.query_id, qsqt.query_sql_text
FROM sys.query_store_query AS qsq
JOIN sys.query_store_query_text AS qsqt ON qsq.query_text_id = qsqt.query_text_id
WHERE qsq.query_parameterization_type = 0;
```

Remedies: parameterize the queries (stored procedure, `sp_executesql`), enable `optimize for ad hoc workloads`,
and if necessary forced parameterization or a plan guide; set `QUERY_CAPTURE_MODE = AUTO`.
For EF Core, account for the parameterization specifics of the ORM (LINQ and raw SQL).

## Verifying Forced Plans (regularly)

```sql
SELECT p.plan_id, p.query_id, q.object_id AS containing_object_id,
       force_failure_count, last_force_failure_reason_desc
FROM sys.query_store_plan AS p
JOIN sys.query_store_query AS q ON p.query_id = q.query_id
WHERE is_forced_plan = 1;
```

## Limitations

- Do not use the `DROP` + `CREATE` pattern for procedures, functions, and triggers: it creates a new
  query entry, the statistics are lost, and the plan cannot be forced — use `ALTER` instead.
- Do not rename a database that has forced plans: the forcing will break.
- Mission-critical servers: trace flags 7745 (do not flush data before shutdown)
  and 7752 (asynchronous Query Store load); as of SQL Server 2019, flag 7752 has no effect.
- Query Store performance fixes were shipped for SQL Server 2016/2017 — they are already
  included in current builds.
