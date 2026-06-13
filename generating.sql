CREATE OR REPLACE FUNCTION random_status()
RETURNS varchar
LANGUAGE SQL
AS $$
    SELECT (ARRAY['standard', 'premium'])[floor(random() * 2 + 1)]
$$;

CREATE OR REPLACE FUNCTION random_client_uuid()
RETURNS UUID
LANGUAGE SQL
AS $$
    SELECT
        id
    FROM clients
    ORDER BY random()
    LIMIT 1
$$;

CREATE OR REPLACE FUNCTION random_burger_id()
RETURNS INTEGER
LANGUAGE SQL
AS $$
    SELECT
        id
    FROM burgers
    ORDER BY random()
    LIMIT 1
$$;

TRUNCATE TABLE clients CASCADE;
TRUNCATE TABLE burgers CASCADE;
TRUNCATE TABLE orders  CASCADE;

INSERT INTO clients (id, name, email, status)
    SELECT
        gen_random_uuid(),
        'John Doe #' || i,
        'john.doe.' || i || '@mit.edu',
        random_status()
    FROM generate_series(1, 10000) as i;

INSERT INTO burgers (id, name, calories_k, price)
    SELECT
        i,
        'Burger #' || i,
        floor(random() * 3000 + 1000),
        round((random() * 50 + 10)::NUMERIC, 2)
    FROM generate_series(1, 10000) as i;

INSERT INTO orders (id, burger_id, quantity, client_id)
    SELECT
        i,
        random_burger_id(),
        floor(random() * 10 + 1),
        random_client_uuid()
    FROM generate_series(1, 10000) as i;