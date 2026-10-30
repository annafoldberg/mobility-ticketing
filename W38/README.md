# MobilityTicketing: Lecture 4
Changes how tickets refer to products.

## Purpose
Give products stable IDs without breaking existing tickets or the application code that still uses product codes.

## Tasks
1. Add the new product ID without removing product_code.
2. Copy the existing ticket references to the new column.
3. Make sure both old and new data can still be read
4. Verify that the migration worked.
5. Finally remove the old way of referencing products.

## Files
### Init
`001_relational_baseline.sql`
- From lecture 1
- Contains initial tables for operators, routes, stops, route stops, and trips, from lecture 1

`002_seed.sql`
- From lecture 1
- Contains initial seed data

`010_ticketing_draft.sql`
- From lecture 2
- Extends the initial schema to support ticketing functionality, related to lecture 2
- Adds capacity and reserved_seats to the existing trips table
- Creates tables for products, users, tickets, payments, and validations
- Additional constraints are added later

`011_ticketing_seed.sql`
- From lecture 2
- Contains initial seed data related to ticketing

`012_completed_integrity.sql`
- Contains a completed set of integrity constraints for ticketing data

`013_migration_fixture.sql`
- Inserts a ticket with a historical price intentionally different from the catalogue price

### Migrations
`030_expand_product_identity.sql`
- Expands the schema with UUID-based product identity while preserving compatibility with the existing product code

`031_backfill_ticket_product.sql`
- Backfills missing ticket product IDs using existing product codes while preserving historical prices

`032_require_ticket_product.sql`
- Validates the product ID foreign key and makes the ticket product ID mandatory

### Experiments
`baseline.sql`
- Verifies the baseline ticket data and product references before migration

`unsafe_change.sql`
- Demonstrates how removing the legacy product code column without first ensuring that readers and writers no longer depend on it, and without checking other database dependencies, can break existing functionality

`old_reader.sql`
- Contains a legacy reader that retrieves tickets using the original product code

`old_writer.sql`
- Contains a legacy writer that inserts tickets using the original product code

`new_reader.sql`
- Contains a compatibility reader that resolves products using either UUID-based references or legacy product codes

`new_writer.sql`
- Contains a new compatibility writer that inserts tickets using both UUID-based product references and legacy product codes

`verify.sql`
- Verifies product references and identifies missing or mismatched product IDs and codes after migration

`final_reader.sql`
- Contains final reader queries using UUID-based product references

`final_writer.sql`
- Contains a final writer that inserts tickets using UUID-based product references without the legacy product code

`remove_legacy.sql`
- Rehearses removal of the legacy product code column after checking for dependencies, without committing the change

## Dossier
Covered in the dossier:
- Predict what will happen when trying to remove the old reference before updating the application code
- Explain how you could lose the link between tickets and products
- Show which old query or insert breaks
- Explain what you would need to consider with a much larger table
- Write an insert and a query that use only `product_code`, as the old application would. Show that both still work after you add the new columns
- Test results
    - Give a real product_id and verify that the inserted ticket gets both that id and the corresponding code. Also verify that the ticket gets the supplied price rather than the product's current catalogue price
    - Give a UUID that doesn't exist in products. Should insert 0 rows
    - Give a conflicting product id and product code. Should ignore product code
    - New reader before backfill
    - Backfill
    - Backfill after old writer
- Compare the original tickets, prices and currencies with your starting data
- Try writing a mismatched pair directly in SQL and record whether the database rejects it
- Test results
    - Make `product_id` required while one ticket still has a null reference
    - Old writer fails after applying `032_require_ticket_product.sql`
- Test after removing the product code column from tickets
- Add a small table showing which inserts and queries work before expansion, after expansion, once the ID is required, and after the old column is removed. Note any query that runs but misses tickets
- When would you stop the old writers, and could you still return to the old application version? Support your answer with a result from your tests
- Moodle Step 8: EF Core migration comparison
    - Migration 1: Expand schema
    - Migration 2: Backfill existing tickets
    - Migration 3: Require product_id
    - Migration 4: Remove old ticket reference
    - Comparison
        - When product_id becomes nullable or required
        - Creation of the foreign key
        - How existing rows are updated
        - Removal of product_code
        - Anything destructive

## Setup and Execution
> Run the following commands from this directory

The database is available at `localhost:5432` with database `mobility`, user `mobility`, and password `mobility`.

### Start Database
```bash
docker compose up -d
```

### Apply Migrations
`030_expand_product_identity.sql`
```bash
docker compose exec -T postgres psql -U mobility -d mobility < database/postgres/migrations/030_expand_product_identity.sql
```

`031_backfill_ticket_product.sql`
```bash
docker compose exec -T postgres psql -U mobility -d mobility < database/postgres/migrations/031_backfill_ticket_product.sql
```

`032_require_ticket_product.sql`
```bash
docker compose exec -T postgres psql -U mobility -d mobility < database/postgres/migrations/032_require_ticket_product.sql
```

### Run Experiments
`baseline.sql`
```bash
docker compose exec -T postgres psql -U mobility -d mobility < database/postgres/experiments/baseline.sql
```

`unsafe_change.sql`
```bash
docker compose exec -T postgres psql -U mobility -d mobility < database/postgres/experiments/unsafe_change.sql
```

`baseline.sql`
```bash
docker compose exec -T postgres psql -U mobility -d mobility < database/postgres/experiments/baseline.sql
```

`old_reader.sql`
```bash
docker compose exec -T postgres psql -U mobility -d mobility < database/postgres/experiments/old_reader.sql
```

`old_writer.sql`
```bash
docker compose exec -T postgres psql -U mobility -d mobility < database/postgres/experiments/old_writer.sql
```

`new_reader.sql`
```bash
docker compose exec -T postgres psql -U mobility -d mobility < database/postgres/experiments/new_reader.sql
```

`new_writer.sql`
```bash
docker compose exec -T postgres psql -U mobility -d mobility < database/postgres/experiments/new_writer.sql
```

`verify.sql`
```bash
docker compose exec -T postgres psql -U mobility -d mobility < database/postgres/experiments/verify.sql
```

`final_reader.sql`
```bash
docker compose exec -T postgres psql -U mobility -d mobility < database/postgres/experiments/final_reader.sql
```

`final_writer.sql`
```bash
docker compose exec -T postgres psql -U mobility -d mobility < database/postgres/experiments/final_writer.sql
```

`remove_legacy.sql`
```bash
docker compose exec -T postgres psql -U mobility -d mobility < database/postgres/experiments/remove_legacy.sql
```

### Stop Database
```bash
docker compose down -v
```