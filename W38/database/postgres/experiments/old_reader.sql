
-- =====================================================================================
-- Contains a legacy reader that retrieves tickets using the original product code
-- -------------------------------------------------------------------------------------
-- Run before and after expansion.
-- =====================================================================================

-- =====================================================================================
-- Legacy reader
-- - Represents the old application
-- - Retrieves tickets using the legacy product_code column
-- - Returns ticket IDs, product codes, prices, and currencies
-- - Does not reference the UUID-based product_id column
-- =====================================================================================
select id, product_code, price, currency
from tickets
order by id;