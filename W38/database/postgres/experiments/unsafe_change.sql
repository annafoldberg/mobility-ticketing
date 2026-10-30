-- =====================================================================================
-- Demonstrates how removing the legacy product code column without first ensuring
-- that readers and writers no longer depend on it, and without checking other
-- database dependencies, can break existing functionality
-- -------------------------------------------------------------------------------------
-- Completed:
-- - Drop tickets.product_code, then run the old reader or writer
-- Use only your disposable lab database. Predict the failure first.
-- =====================================================================================

begin;

-- =====================================================================================
-- Legacy column removal
-- - Removes tickets.product_code without checking existing dependencies
-- - Demonstrates how removing the column can break legacy readers and writers
-- =====================================================================================
alter table tickets
    drop column product_code;

commit;

-- =====================================================================================
-- Product reference recovery
-- -------------------------------------------------------------------------------------
-- Completed:
-- - What information would you need to reconstruct the product links?
-- 
-- Response:
-- - The existing product_code values should be mapped to the new product_id
-- =====================================================================================

-- =====================================================================================
-- Rollback
-- - If psql stops on the expected error, the connection closing rolls back
--   this transaction. In an interactive session, issue ROLLBACK yourself.
-- =====================================================================================
-- rollback;