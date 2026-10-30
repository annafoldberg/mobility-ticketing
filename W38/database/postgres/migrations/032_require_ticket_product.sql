-- =====================================================================================
-- Validates the product ID foreign key and makes the ticket product ID mandatory
-- -------------------------------------------------------------------------------------
-- Completed (migration DDL):
-- - Apply only after retiring old writers and passing final verification.
-- - Validate the product-ID foreign key, then require the ticket reference.
-- - Rehearse legacy-column removal separately after dependency checks.
-- =====================================================================================

begin;

set local lock_timeout = '3s';

-- =====================================================================================
-- Validates the existing product ID foreign key
-- =====================================================================================
alter table tickets
    validate constraint tickets_product_id_fk;

-- =====================================================================================
-- Requires all tickets to have a product ID
-- =====================================================================================
alter table tickets
    alter column product_id set not null;

commit;