-- =====================================================================================
-- Contains queries:
-- - Upcoming trips
-- - Ordered route stops
-- - Routes and trip count, including routes with zero trips
-- =====================================================================================

-- =====================================================================================
-- Query 1: Upcoming trips
-- =====================================================================================
select
    t.id,
    t.scheduled_departure_utc,
    t.status
from trips t
where t.route_id = :route_id
  and t.scheduled_departure_utc >= :after_utc
order by t.scheduled_departure_utc
limit 20;

-- -------------------------------------------------------------------------------------
-- Example
-- -------------------------------------------------------------------------------------
select
    t.id,
    t.scheduled_departure_utc,
    t.status
from trips t
where t.route_id = 'LINE-M2'
  and t.scheduled_departure_utc >= '2026-08-28 08:30:00+00'
order by t.scheduled_departure_utc
limit 20;

-- =====================================================================================
-- Query 2: Ordered route stops
-- -------------------------------------------------------------------------------------
-- Completed:
-- - Show the ordered stops belonging to a route
-- =====================================================================================
select
    rs.route_id,
    rs.stop_id,
    rs.stop_sequence
from route_stops rs
join stops s on s.id = rs.stop_id
where rs.route_id = :route_id
order by rs.stop_sequence;

-- -------------------------------------------------------------------------------------
-- Example
-- -------------------------------------------------------------------------------------
select
    rs.route_id,
    rs.stop_id,
    rs.stop_sequence
from route_stops rs
join stops s on s.id = rs.stop_id
where rs.route_id = 'LINE-M2'
order by rs.stop_sequence;

-- =====================================================================================
-- Query 3: Routes and trip count, including routes with zero trips
-- -------------------------------------------------------------------------------------
-- Completed:
-- - Show all routes and the number of scheduled trips on a supplied service date
-- - Include routes with no trips
-- =====================================================================================
select
    r.id,
    count(t.id) AS number_of_trips
from routes r
left join trips t
    on t.route_id = r.id
    and t.service_date = :service_date
group by r.id;

-- -------------------------------------------------------------------------------------
-- Example
-- -------------------------------------------------------------------------------------
select
    r.id,
    count(t.id) AS number_of_trips
from routes r
left join trips t
    on t.route_id = r.id
    and t.service_date = '2026-08-28'
group by r.id;