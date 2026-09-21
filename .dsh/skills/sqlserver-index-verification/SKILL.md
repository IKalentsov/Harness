---
name: sqlserver-index-verification
description: "Use when an index recommendation has been generated and must be validated before implementation. Verifies workload benefit, redundancy, write overhead, storage impact, and existing index coverage. Keywords: SQL Server, index, missing index DMV, redundant index, write overhead, index verification, T-SQL."
whenToUse: "When a ready index recommendation exists and it must be validated before it is implemented."
---

# Index Verification

> **Source:** official `index-verification` example from the Microsoft Learn documentation
> "Use Agent skills with GitHub Copilot in SQL Server Management Studio"
> (https://learn.microsoft.com/en-us/ssms/github-copilot/agent-skills), retrieved 2026-09-21.
> Reproduced in the original English. This is a local copy — it does not update automatically;
> when Microsoft changes the source, update it by hand.

## Use this skill when

- A missing index recommendation exists
- An agent generated an index recommendation
- Query tuning suggests adding an index
- A user asks whether an index should be created

## Never assume

- Missing index DMVs are recommendations, not requirements.
- Do not recommend index creation until validation is complete.

## Verification Checklist

### 1. Check Existing Indexes

Determine whether:

- An equivalent index already exists
- A wider index already covers the workload
- Included columns already satisfy the query
- The recommendation duplicates another recommendation

### 2. Estimate Read Benefit

Evaluate:

- Query execution frequency
- Current execution cost
- Expected seek/selectivity improvement
- Number of affected queries

### 3. Evaluate Write Cost

Determine:

- Insert impact
- Update impact
- Delete impact
- Additional maintenance cost

### 4. Evaluate Storage Impact

Estimate:

- Index size on disk
- Memory pressure
- Replication impact

### 5. Make Recommendation

Return one of:

- Create index
- Modify existing index
- Consolidate with existing recommendation
- Reject recommendation

## Avoid

- Blindly trusting missing-index DMVs
- Creating overlapping indexes
- Recommending indexes for one-off queries
- Ignoring write-heavy workloads

## Output Format

Format output as a table: index name, columns, type, and recommendation (create / modify / consolidate / reject).
