# MobilityTicketing: Lecture 1
Contains a small PostgreSQL slice for route maintenance and timetable queries.

## Purpose
Create the smallest relational model that can support route maintenance and upcoming-trip queries. The implementation is not expected to represent the complete MobilityTicketing platform. It should make your modelling assumptions executable.

## Tasks
1. Create tables for operators, routes, stops, route stops, and trips.
2. Decide the primary key of the route-stop relation and explain the decision.
3. Add primary-key and foreign-key relationships.
4. Insert the supplied seed data.
5. Write the three workload queries:
    - Show the next 20 scheduled trips for a route after a supplied timestamp.
    - Show the ordered stops belonging to a route.
    - Show all routes and the number of scheduled trips on a supplied service date, including routes with no trips.
6. Compare the implemented schema with your ER diagram and record any difference.

## Files
`001_relational_baseline.sql`  
- Creates tables for operators, routes, stops, route stops, and trips
- Decides the primary key of the route-stop relation and explains the decision
- Adds primary-key and foreign-key relationships

`002_seed.sql`  
- Contains seed data
- Adds route_stops rows after deciding the key
- Adds two trips per route on the same service date

`003_queries.sql`  
- Contains queries:
    - Upcoming trips
    - Ordered route stops
    - Routes and trip count, including routes with zero trips

## Dossier
Covered in the dossier:
- Decide whether a route may visit the same stop more than once, and explain the choice
- Decide the primary key of the route-stop relation and explain the decision
- Record one assumption that may change later
- Describe the customers, operators, and city transport context without naming a database product
- Cover route search, ticket purchase, ticket validation, timetable updates, real-time availability, and reporting in the access-pattern map
- Include identifiers, relationships, and cardinalities in the ER diagram
- Explain one functional dependency and what normalization prevents
- Explain how a query uses the model
- State what the implementation proves and what remains unknown

## Setup and Execution
> Run the following commands from this directory

The database is available at `localhost:5432` with database `mobility`, user `mobility`, and password `mobility`.

### Start Database
```bash
docker compose up -d
```

### Stop Database
```bash
docker compose down -v
```