-- =====================================================================================
-- From Lecture 1
-- Contains initial tables for:
-- - Operators
-- - Routes
-- - Stops
-- - Route stops
-- - Trips
-- =====================================================================================

-- =====================================================================================
-- Operators:
-- - Maintain routes and timetables
-- - Update products and prices
-- - View usage and revenue support
-- =====================================================================================
create table operators (
    id text primary key,
    name text not null
);

-- =====================================================================================
-- Routes:
-- - Defines transport routes within a city
-- - References the operator maintaining the route
-- =====================================================================================
create table routes (
    id text primary key,
    operator_id text not null references operators(id),
    city_id text not null,
    mode text not null,
    short_name text not null
);

-- =====================================================================================
-- Stops:
-- - Defines stops within a city
-- =====================================================================================
create table stops (
    id text primary key,
    city_id text not null,
    name text not null
);

-- =====================================================================================
-- Route_Stops:
-- - Defines the ordered stops belonging to each route
-- - Allows the same stop to occur multiple times along a route
-- - Uses (route_id, stop_sequence) as the composite primary key
-- - Ensures only one stop can exist at each sequence position along a route
-- =====================================================================================
create table route_stops (
    route_id text not null references routes(id),
    stop_id text not null references stops(id),
    stop_sequence integer not null,
    constraint route_stops_pk primary key (route_id, stop_sequence),
    constraint route_stops_sequence_positive check (stop_sequence > 0)
);

-- =====================================================================================
-- Trips:
-- - Defines scheduled journeys for a route
-- - References the route the trip follows
-- =====================================================================================
create table trips (
    id text primary key,
    route_id text not null references routes(id),
    service_date date not null,
    scheduled_departure_utc timestamptz not null,
    status text not null
);