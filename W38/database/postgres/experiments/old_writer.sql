-- =====================================================================================
-- Contains a legacy writer that inserts tickets using the original product code
-- =====================================================================================

-- =====================================================================================
-- Variables
-- - Defines the ticket ID and ticket code for the new ticket
-- - Use a new ticket ID and ticket code for each insert,
--   including the late-write test, which verifies that the legacy
--   writer still works after introducing UUID-based product references
-- =====================================================================================
\set ticket_id 'LAB04-OLD-6'
\set ticket_code 'LAB04-CODE-OLD-6'

-- =====================================================================================
-- Legacy writer
-- - Inserts a new ticket using the legacy product_code column
-- - Reuses existing ticket details from TICKET-1
-- - Uses the specified ticket ID and ticket code
-- - Does not reference the UUID-based product_id column
-- =====================================================================================
insert into tickets
    (id, user_id, trip_id, ticket_code, status, product_code,
     valid_from_utc, valid_to_utc, price, currency)
select :'ticket_id', user_id, trip_id, :'ticket_code', status, product_code,
       valid_from_utc, valid_to_utc, price, currency
from tickets
where id = 'TICKET-1';