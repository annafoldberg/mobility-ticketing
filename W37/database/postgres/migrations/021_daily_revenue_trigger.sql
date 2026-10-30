-- =====================================================================================
-- Contains a table and trigger for maintaining daily captured revenue
-- and payment counts per operator.
-- Handles only payment inserts
-- -------------------------------------------------------------------------------------
-- Completed:
-- - This is deliberately incomplete
-- - Document the behaviour before extending it
-- - Analysis and extension can be found in `021_daily_revenue_trigger_extended.sql`
-- =====================================================================================

-- =====================================================================================
-- Daily revenue by operator
-- - Stores daily captured revenue and payment counts for each operator
-- - Uses (operator_id, revenue_date) as the composite primary key
-- =====================================================================================
create table daily_revenue_by_operator (
    operator_id text not null references operators(id),
    revenue_date date not null,
    captured_amount numeric not null default 0,
    captured_payments bigint not null default 0,
    primary key (operator_id, revenue_date)
);

-- =====================================================================================
-- INSERT function
-- - Adds newly captured payments to the daily revenue summary
-- - Updates existing summaries when payments belong to the same operator and date
-- =====================================================================================
create or replace function add_inserted_payment_to_daily_revenue()
returns trigger
language plpgsql
as $$
declare
    payment_operator_id text;
begin
    -- If payment does not have status Captured, do nothing
    if new.status is distinct from 'Captured' then
        return new;
    end if;
    
    -- Finds operator related to the ticket through trips and routes
    -- and stores its id in a variable payment_operator_id
    select r.operator_id
    into payment_operator_id
    from tickets t
    join trips tr on tr.id = t.trip_id
    join routes r on r.id = tr.route_id
    where t.id = new.ticket_id;

    -- Inserts into daily_revenue_by_operator the payment_operator_id, the utc date,
    -- the payment amount, and sets captured payments to 1.
    insert into daily_revenue_by_operator (
        operator_id, revenue_date, captured_amount, captured_payments
    ) values (
        payment_operator_id, new.created_utc::date, new.amount, 1
    )
    -- If there is a conflict for the operator id and the revenue date,
    -- which means that a summary row for that operator on that date already exists,
    -- instead of inserting, it makes an update where it sets
    -- captured_amount to the opeator's captured amount plus the excluded captured amount
    -- (excluded.captured_amount is PostgreSQL's way of referring to the value that
    -- PostgreSQL tried to insert, but couldn't because a conflicting row already existed)
    -- and the captured_payments to daily_revenue_by_operator's captured_payments + 1.
    on conflict (operator_id, revenue_date)
    do update set
        captured_amount = daily_revenue_by_operator.captured_amount + excluded.captured_amount,
        captured_payments = daily_revenue_by_operator.captured_payments + 1;
    return new;
end;
$$;

-- =====================================================================================
-- INSERT trigger
-- - Executes the function after a payment row is inserted
-- =====================================================================================
create trigger payments_daily_revenue_after_insert
after insert on payments
for each row
execute function add_inserted_payment_to_daily_revenue();