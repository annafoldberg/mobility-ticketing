-- =====================================================================================
-- Verifies product references and identifies missing or mismatched product IDs and
-- codes after migration
-- -------------------------------------------------------------------------------------
-- Completed:
-- - Join products and return only tickets with a null ID, a missing product,
--   or a code and ID that refer to different products
-- - Expect no rows after the final backfill
-- - Test the check with a deliberate mismatch inside a transaction, then roll it back
-- =====================================================================================

-- =====================================================================================
-- Stored product references
-- - Retrieves ticket IDs, product codes, product IDs, prices, and currencies
-- - Provides an overview of the stored references after expansion
-- =====================================================================================
select t.id, t.product_code, t.product_id, t.price, t.currency
from tickets t
order by t.id;

-- =====================================================================================
-- Product reference validation
-- - Joins tickets to products using the UUID-based product_id
-- - Identifies tickets with missing or unresolved product IDs
-- - Identifies tickets whose product codes do not match the referenced products
-- - Expects no rows when all product references are consistent
-- =====================================================================================
select t.id, t.product_code, t.product_id, t.price, t.currency
from tickets t
left join products p
    on p.id = t.product_id
where t.product_id is null
   or p.id is null
   or p.code <> t.product_code
order by t.id;