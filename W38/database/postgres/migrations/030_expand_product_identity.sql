-- =====================================================================================
-- Expands the schema with UUID-based product identity while
-- preserving compatibility with the existing product code
-- -------------------------------------------------------------------------------------
-- Completed (migration DDL):
-- - Add a stored UUID to each product and a unique key.
-- - Add the nullable ticket reference and a NOT VALID foreign key.
-- - Keep the original product code contract usable.
-- =====================================================================================

begin;

set local lock_timeout = '3s';

-- =====================================================================================
-- Products
-- - Adds UUID column, id, with a unique constraint
-- =====================================================================================
alter table products
    add column id uuid default gen_random_uuid(),
    add constraint products_id_unique unique (id);

-- =====================================================================================
-- Products
-- - Generates and sets id to random uuid
-- =====================================================================================
update products
set id = gen_random_uuid()
where id is null;

-- =====================================================================================
-- Products
-- - Requires id is not null
-- =====================================================================================
alter table products
    alter column id set not null;

-- =====================================================================================
-- Tickets
-- - Adds nullable column product_id
-- - Making it nullable ensures we can continue with the old product_code reference
--   alongside the new product_id and apply the switch gradually
-- =====================================================================================
alter table tickets
    add column product_id uuid;

-- =====================================================================================
-- Tickets
-- - Adds the FK constraint as not valid
-- - Not valid ensures that PostreSQL doesn't scan all existing rows to validate them
-- =====================================================================================
alter table tickets
    add constraint tickets_product_id_fk foreign key (product_id) references products(id)
    not valid;

commit;