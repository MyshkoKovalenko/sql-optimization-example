-- Creating indices to fields that are queried a lot
CREATE INDEX IF NOT EXISTS idx_burger_price
    ON burgers(price);
CREATE INDEX IF NOT EXISTS idx_order_quantity
    ON orders(quantity);
CREATE INDEX IF NOT EXISTS idx_orders_client_id
    ON orders(client_id);
CREATE INDEX IF NOT EXISTS idx_orders_burger_id
    ON orders(burger_id);

-- Using CTEs to calculate the top 10 clients with the most spending and their favourite burgers (burgers that the client has bought the most times) once
EXPLAIN ANALYZE
WITH
client_spending_top_10 AS (
    SELECT
        c.id,
        c.name,
        c.email,
        c.status,
        ROUND(SUM(b.price * o.quantity)::NUMERIC, 2) as total_spending
    FROM clients c
    JOIN orders o ON c.id = o.client_id
    JOIN burgers b ON b.id = o.burger_id
    GROUP BY c.id
    ORDER BY total_spending DESC
    LIMIT 10
),
client_total_burgers_bought_across_orders AS (
    SELECT DISTINCT ON (cs.id)
        cs.id as client_id,
        b.id as burger_id,
        SUM(o.quantity) as burger_bought
    FROM burgers b
    JOIN orders o on b.id = o.burger_id
    JOIN client_spending_top_10 cs on o.client_id = cs.id
    GROUP BY cs.id, b.id
    ORDER BY cs.id, burger_bought DESC, b.id
)

-- The main query
SELECT
    cs.name,
    cs.email,
    cs.status,
    cs.total_spending,
    b.name as favourite_burger,
    RANK () OVER (
        ORDER BY total_spending DESC
    ) rank_num
FROM client_spending_top_10 cs
JOIN client_total_burgers_bought_across_orders ctbbao ON cs.id = ctbbao.client_id
JOIN burgers b ON ctbbao.burger_id = b.id
