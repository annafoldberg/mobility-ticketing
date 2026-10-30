-- =====================================================================================
-- Rehearses removal of the legacy product code column after checking for dependencies,
-- without committing the change
-- -------------------------------------------------------------------------------------
-- Completed:
-- - Inspect views and functions that use tickets.product_code
-- - Update or remove those dependencies deliberately
-- - Drop the column without CASCADE and test your final reader and writer
-- - Keep this rehearsal reversible. Record what would need to happen before
--   you committed the same change in a real rollout.
-- =====================================================================================

-- =====================================================================================
-- Transaction
-- - Starts a reversible transaction for testing legacy-column removal
-- - Sets a lock timeout to avoid waiting indefinitely for database locks
-- Start only after your ID-only reader and writer are ready.
-- =====================================================================================
begin;

set local lock_timeout = '3s';

-- =====================================================================================
-- View dependencies
-- - Finds views that reference the legacy product_code column
-- =====================================================================================
select schemaname, viewname, definition
from pg_views
where definition ilike '%product_code%';

-- =====================================================================================
-- Function dependencies
-- - Finds functions that reference the legacy product_code column
-- =====================================================================================
select routine_schema, routine_name, routine_definition
from information_schema.routines
where routine_definition ilike '%product_code%';

-- =====================================================================================
-- Legacy column removal
-- - Attempts to remove tickets.product_code without CASCADE
-- - Prevents automatic removal of dependent database objects
-- =====================================================================================
alter table tickets
    drop column product_code;

rollback;