# MobilityTicketing: Lecture 3
Compares four ways to produce daily captured revenue:
1. a direct aggregate query
2. a SQL function over the base tables
3. a materialized view
4. a trigger-maintained summary table
The differences between the four ways to produce daily captured revenue are observable, explained, and tied to a recommendation.

## Purpose
Implement and compare a direct SQL query, a user-defined function, a materialized view and a trigger-maintained summary for daily captured revenue. Use the differences to decide where the responsibility belongs.

## Tasks
1. Run the reference revenue query and verify its result from the base tables.
2. Wrap the read logic in a SQL function.
3. Create a materialized view and observe when it becomes stale.
4. Create the supplied trigger-maintained summary.
5. Test all four approaches against:
    - a captured payment insert
    - a failed payment insert
    - a status correction from Failed to Captured
    - a correction from Captured to Refunded
    - deletion or replacement of test data
    - duplicate delivery of the same external payment reference
6. Produce a responsibility matrix comparing correctness, freshness, write cost, read cost, hidden side effects, rebuildability and operational complexity.
7. Recommend one approach for the current case. A hybrid answer is allowed, but each stored copy must have a clear authority and rebuild path.

## Files
### Init
`001_relational_baseline.sql`
- Contains initial tables for operators, routes, stops, route stops, and trips, from lecture 1

`002_seed.sql`
- Contains initial seed data

`010_ticketing_draft.sql`
- Extends the initial schema to support ticketing functionality, related to lecture 2
- Adds capacity and reserved_seats to the existing trips table
- Creates tables for products, users, tickets, payments, and validations
- Additional constraints are intentionally left out

`011_ticketing_seed.sql`
- Contains initial seed data related to ticketing

### Queries
`base_revenue.sql`
- Contains a query for calculating daily captured revenue and payment counts per operator

### Migrations
`020_reporting_function.sql`
- Contains a function for calculating daily captured revenue and payment count for an operator

`021_daily_revenue_trigger.sql`
- Contains a table and trigger for maintaining daily captured revenue and payment counts per operator
- Handles only payment inserts

`021_daily_revenue_trigger_extended.sql`
- Contains an extended implementation of daily revenue tracking with triggers for payment inserts, updates, and deletes

`022_daily_captured_revenue.sql`
- Contains a materialized view for storing daily captured revenue and payment counts per operator

### Experiments
`reporting_cases.sql`
- Contains test scenarios for comparing reporting mechanisms under different payment operations:
    - Baseline result before changing source data
    - Captured payment insert
    - Failed payment insert
    - Status correction from Failed to Captured
    - Status correction from Captured to Refunded
    - Delete or replace test data
    - Duplicate delivery of an external payment reference

## Dossier
Covered in the dossier:
- Test results
- Disagreement example
- Side-effect trace
- Responsibility matrix
- Issue register
- Decision

## Setup and Execution
> The database is available at `localhost:5432` with database `mobility`, user `mobility`, and password `mobility`.

### Start Database
```bash
docker compose up -d
```

### Apply Migrations
`020_reporting_function.sql`
```bash
docker compose exec -T postgres psql -U mobility -d mobility < database/postgres/migrations/020_reporting_function.sql
```

`021_daily_revenue_trigger.sql`
```bash
docker compose exec -T postgres psql -U mobility -d mobility < database/postgres/migrations/021_daily_revenue_trigger.sql
```

`021_daily_revenue_trigger_extended.sql`
```bash
docker compose exec -T postgres psql -U mobility -d mobility < database/postgres/migrations/021_daily_revenue_trigger_extended.sql
```

`022_daily_captured_revenue.sql`
```bash
docker compose exec -T postgres psql -U mobility -d mobility < database/postgres/migrations/022_daily_captured_revenue.sql
```

### Run Query
```bash
docker compose exec -T postgres psql -U mobility -d mobility < database/postgres/migrations/base_revenue.sql
```

### Run Experiments
```bash
docker compose exec -T postgres psql -U mobility -d mobility < database/postgres/migrations/reporting_cases.sql
```

### Stop Database
```bash
docker compose down -v
```