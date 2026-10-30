-- =====================================================================================
-- Contains a query for calculating daily captured revenue and
-- payment counts per operator
-- =====================================================================================

-- =====================================================================================
-- Daily captured revenue
-- - Calculates total captured revenue and payment counts per operator and date
-- - Includes only payments with Captured status
-- - Calculates results directly from the underlying tables without storing them
-- =====================================================================================
select
    r.operator_id,
    p.created_utc::date as revenue_date,
    sum(p.amount) as captured_amount,
    count(*) as captured_payments
from payments p
join tickets t on t.id = p.ticket_id
join trips tr on tr.id = t.trip_id
join routes r on r.id = tr.route_id
where p.status = 'Captured'
group by r.operator_id, p.created_utc::date
order by r.operator_id, p.created_utc::date;