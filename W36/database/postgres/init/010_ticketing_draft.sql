-- =====================================================================================
-- Extends the initial schema to support ticketing functionality, related to lecture 2
-- - Adds capacity and reserved_seats to the existing trips table
-- - Creates tables for products, users, tickets, payments, and validations
-- Additional constraints are intentionally left out to be added through migrations
-- =====================================================================================

-- =====================================================================================
-- Trips
-- - Adds capacity
-- - Adds reserved seats
-- =====================================================================================
alter table trips
    add column capacity integer,
    add column reserved_seats integer default 0;

-- =====================================================================================
-- Products:
-- - Defines ticket products, including their prices and currency
-- =====================================================================================
create table products (
    code text primary key,
    name text,
    price numeric,
    currency text
);

-- =====================================================================================
-- Users:
-- - Represents a customer
-- - Searches for routes
-- - Views departures and delays
-- - Buys digital tickets
-- - Validates tickets when boarding
-- =====================================================================================
create table users (
    id text primary key,
    email text,
    full_name text,
    is_disabled boolean default false
);

-- =====================================================================================
-- Tickets:
-- - Represents purchased tickets, including their validity, status, and price
-- =====================================================================================
create table tickets (
    id text primary key,
    user_id text,
    trip_id text,
    ticket_code text,
    status text,
    product_code text,
    valid_from_utc timestamptz,
    valid_to_utc timestamptz,
    price numeric,
    currency text
);

-- =====================================================================================
-- Payments:
-- - Records payments associated with ticket purchases
-- =====================================================================================
create table payments (
    id text primary key,
    user_id text,
    ticket_id text,
    external_payment_reference text,
    amount numeric,
    currency text,
    status text,
    created_utc timestamptz default now()
);

-- =====================================================================================
-- Validations:
-- - Records ticket validation attempts, including their results
-- =====================================================================================
create table validations (
    id text primary key,
    ticket_id text,
    ticket_code text,
    vehicle_id text,
    stop_id text,
    device_id text,
    result text,
    validated_utc timestamptz default now()
);