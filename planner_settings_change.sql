-- Planner settings configuration
ALTER SYSTEM SET work_mem = '256MB'; -- Allows PostgreSQL to utilize up to 256 MB of RAM per query step
ALTER SYSTEM SET shared_buffers = '4GB'; -- All PostgreSQL to utilize 4 GB of RAM for cache
SELECT pg_reload_conf(); -- Apply settings