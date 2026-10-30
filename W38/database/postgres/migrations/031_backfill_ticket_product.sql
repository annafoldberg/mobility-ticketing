-- =====================================================================================
-- Backfills missing ticket product IDs using existing product codes
-- while preserving historical prices
-- -------------------------------------------------------------------------------------
-- Completed:
-- - Resolve only tickets whose product_id is null
-- - Match the existing product code and preserve assigned IDs and historical prices
-- - The second run must change zero rows
-- =====================================================================================

-- =====================================================================================
-- Repeatable UPDATE
-- - Assigns product IDs to tickets where product_id is null
-- - Leaves already assigned IDs and historical prices unchanged
-- - Changes no rows when repeated after a successful backfill
-- =====================================================================================
update tickets t
set product_id = p.id
from products p
where t.product_id is null
    and t.product_code = p.code;