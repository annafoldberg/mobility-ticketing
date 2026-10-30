-- =====================================================================================
-- Contains final reader queries using UUID-based product references
-- -------------------------------------------------------------------------------------
-- Completed:
-- - Join products through product_id and include the product code
-- - Do not use tickets.product_code: this query must survive its removal
-- =====================================================================================

-- =====================================================================================
-- Final reader: Ticket data
-- - Retrieves ticket IDs, product IDs, prices, and currencies directly from tickets
-- - Provides a baseline for comparison with the resolved product references
-- =====================================================================================
select t.id, t.product_id, t.price, t.currency
from tickets t
order by t.id;

-- =====================================================================================
-- Final reader: Product lookup
-- - Joins tickets to products using the UUID-based product_id
-- - Returns the resolved product ID alongside the ticket details
-- - Allows verification that ticket product references resolve to existing products
-- =====================================================================================
select t.id, t.product_id, p.id as resolved_product_id, t.price, t.currency
from tickets t
join products p
    on p.id = t.product_id
order by t.id;