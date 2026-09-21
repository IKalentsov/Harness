---
name: sqlserver-agent-job-failure-triage
description: "Use when an automated job, workflow, maintenance task, or agent execution fails. Determines root cause and appropriate remediation while avoiding unsafe recovery actions. Keywords: SQL Server Agent, job failure, triage, root cause, safe remediation, T-SQL."
whenToUse: "When a SQL Server Agent job or other automated task has failed and the cause must be understood before any intervention."
---

# Agent Job Failure Triage

> **Source:** official `agent-job-failure-triage` example from the Microsoft Learn documentation
> "Use Agent skills with GitHub Copilot in SQL Server Management Studio"
> (https://learn.microsoft.com/en-us/ssms/github-copilot/agent-skills), retrieved 2026-09-21.
> Reproduced in the original English. This is a local copy — it does not update automatically;
> when Microsoft changes the source, update it by hand.

## Objective

Identify root cause before attempting remediation.

## First Rule

Never retry repeatedly without understanding why the job failed.

## Investigation Order

### 1. Collect Failure Details

Gather:

- Job name
- Error message
- Start time
- End time
- Retry history

### 2. Classify Failure

Determine whether failure is:

- Resource-related
- Permission-related
- Configuration-related
- Data-related
- Dependency-related
- Other or unknown

### 3. Check Recent Changes

Investigate:

- Deployments
- Configuration changes
- Schema changes
- Security changes
- Infrastructure changes

### 4. Determine Blast Radius

Identify:

- Data modified by job
- Schema modified by job
- Affected users or departments
- Downstream jobs
- SLA impact
- Data correctness risk

## Safe Actions

- Collect logs
- Validate dependencies
- Escalate when root cause is unknown

## Unsafe Actions

- Retry job
- Disable job
- Force-completing jobs
- Disabling validation checks
- Modifying production data to "make it pass"
- Restarting the SQL Agent service
