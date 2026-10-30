-- =====================================================================================
-- From Lecture 1
-- Contains initial seed data
-- =====================================================================================

-- =====================================================================================
-- Operators
-- Inserts two operators, OP-METRO and OP-BUS
-- =====================================================================================
insert into operators (id, name) values
    ('OP-METRO', 'City Metro'),
    ('OP-BUS', 'City Bus')
on conflict do nothing;

-- =====================================================================================
-- Routes
-- Inserts two routes:
-- - LINE-M2 managed by the OP-METRO operator
-- - LINE-5C managed by the OP-BUS operator
-- =====================================================================================
insert into routes (id, operator_id, city_id, mode, short_name) values
    ('LINE-M2', 'OP-METRO', 'CPH', 'metro', 'M2'),
    ('LINE-5C', 'OP-BUS', 'CPH', 'bus', '5C')
on conflict do nothing;

-- =====================================================================================
-- Stops
-- Inserts 4 stops throughout Copenhagen
-- =====================================================================================
insert into stops (id, city_id, name) values
    ('STOP-NORREPORT', 'CPH', 'Nørreport'),
    ('STOP-KONGENS-NYTORV', 'CPH', 'Kongens Nytorv'),
    ('STOP-AIRPORT', 'CPH', 'Copenhagen Airport'),
    ('STOP-CENTRAL', 'CPH', 'Copenhagen Central Station')
on conflict do nothing;

-- =====================================================================================
-- Route stops
-- Inserts 3 stops along the LINE-M2 route
-- Inserts 3 stops along the LINE-5C route
-- =====================================================================================
insert into route_stops (route_id, stop_id, stop_sequence) values
    ('LINE-M2', 'STOP-NORREPORT', 1),
    ('LINE-M2', 'STOP-KONGENS-NYTORV', 2),
    ('LINE-M2', 'STOP-AIRPORT', 3),
    ('LINE-5C', 'STOP-CENTRAL', 1),
    ('LINE-5C', 'STOP-NORREPORT', 2),
    ('LINE-5C', 'STOP-KONGENS-NYTORV', 3)
on conflict (route_id, stop_sequence) do nothing;