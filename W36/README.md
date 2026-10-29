# MobilityTicketing: Lecture 2
Carries forward the small relational MobilityTicketing slice and adds an intentionally permissive ticketing schema.

## Purpose
Strengthen the initial PostgreSQL schema for ticket purchase and validation. The focus is *not* API validation. The focus is what the database can guarantee when writes arrive from different applications, scripts or future services.

## Tasks
1. Read the supplied DDL before changing it.
2. Extract at least ten domain invariants from the scenario and schema.
3. Classify each invariant as one of:
    - directly enforceable with a column or table constraint
    - enforceable with a unique or exclusion rule
    - dependent on more than one row or external system
    - currently ambiguous and requiring a domain decision
4. Implement the constraints that belong in this lecture.
5. Write negative tests that attempt invalid inserts or updates.
6. Record at least two important invariants that cannot be solved by a simple constraint. Keep them for the transactions lecture.

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
- Additional constraints are intentionally left out to be added through migrations

`011_ticketing_seed.sql`  
- Contains initial seed data related to ticketing

### Migrations
`011_ticketing_integrity.sql`
- Adds constraints for the minimum invariants and requirements specified in the TODO

### Experiments
`constraints_success_tests.sql`
- Contains valid writes for testing constraints after migration:
    - Valid capacity and reserved seats
    - Valid product price and currency
    - Valid ticket
    - Valid payment referencing the ticket created above
    - Valid validation where ticket_id and ticket_code identify the same ticket

`constraints_should_fail.sql`  
- Contains invalid writes for testing constraints after migration:
    - Negative capacity (CHECK violation)
    - More reserved seats than capacity (CHECK violation)
    - Unknown trip (FOREIGN KEY violation)
    - Reserved validity window (CHECK violation)
    - Duplicate ticket code (UNIQUE violation)
    - Unknown ticket status (CHECK violation)
    - Negative product price (CHECK violation)
    - Payment for an unknown ticket (FOREIGN KEY violation)
    - Duplicate external payment reference (UNIQUE violation)
    - Mismatched ticket id and ticket code (FOREIGN KEY violation)

`constraints_failure_tests.sql`
- Contains additional invalid writes for testing constraints after migration:
    - Negative ticket price (CHECK violation)
    - Negative payment amount (CHECK violation)
    - Missing product currency (NOT NULL violation)
    - Missing ticket currency (NOT NULL violation)
    - Missing payment currency (NOT NULL violation)
    - Unknown product referenced by ticket (FOREIGN KEY violation)
    - Unknown validation result (CHECK violation)
    - Unknown trip status (CHECK violation)
    - Unknown payment status (CHECK violation)
    - Validation for an unknown ticket (FOREIGN KEY violation)

`reference_negative_tests.sql`
- Contains reference tests for verifying expected SQLSTATE codes

## Dossier
Covered in the dossier:
- Domain invariants and classification
- Integrity map
- Two important rules
    - Rule 1: Reserved seats cannot exceed capacity
    - Rule 2: A payment must reference an existing ticket
- Issue register
    - Issue 1: Overselling
    - Issue 2: Invalid ticket acceptance
- State-transition trace
    - Ticket purchase
    - Ticket validation
    - Delete and update behaviour
- Invariants that cannot be solved by a simple constraint

## Setup and Execution
> The database is available at `localhost:5432` with database `mobility`, user `mobility`, and password `mobility`.

### Start Database
```bash
docker compose up -d
```

### Check Starter Tables
```bash
docker compose exec -T postgres psql -U mobility -d mobility -c '\dt'
```

### Apply Migration
```bash
docker compose exec -T postgres psql -U mobility -d mobility < database/postgres/migrations/011_ticketing_integrity.sql
```

### Run Experiments
`constraints_success_tests.sql`
```bash
docker compose exec -T postgres psql -U mobility -d mobility < database/postgres/experiments/constraints_success_tests.sql
```

`constraints_should_fail.sql`  
```bash
docker compose exec -T postgres psql -U mobility -d mobility < database/postgres/experiments/constraints_should_fail.sql
```

`constraints_failure_tests.sql`
```bash
docker compose exec -T postgres psql -U mobility -d mobility < database/postgres/experiments/constraints_failure_tests.sql
```

`reference_negative_tests.sql`
```bash
docker compose exec -T postgres psql -U mobility -d mobility < database/postgres/experiments/reference_negative_tests.sql
```

### Stop Database
```bash
docker compose down -v
```