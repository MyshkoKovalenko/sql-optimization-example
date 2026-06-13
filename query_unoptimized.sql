-- Dropping indices for demonstration and comparison purposes
DROP INDEX IF EXISTS idx_burger_price;
DROP INDEX IF EXISTS idx_order_quantity;
DROP INDEX IF EXISTS idx_orders_client_id;
DROP INDEX IF EXISTS idx_orders_burger_id;

EXPLAIN ANALYZE
-- The main query, which has subqueries
SELECT
    sub.name,
    sub.email,
    sub.status,
    sub.total as total_spending,
    (SELECT favourite
    FROM (
        SELECT
            c.name as n,
            b.name as favourite,
            sum(o.quantity) as burger_bought
        FROM burgers b
        JOIN orders o on b.id = o.burger_id
        JOIN clients c on o.client_id = c.id
        GROUP BY c.id, b.id
        ORDER BY burger_bought DESC
    )
    WHERE sub.name = n LIMIT 1) as favourite_burger,
    RANK () OVER (
            ORDER BY total DESC
    ) rank_num
    FROM (
        SELECT
            c.name,
            c.email,
            c.status,
            round(sum(o.quantity * b.price)::NUMERIC, 2) as total
        FROM clients c
        JOIN orders o ON o.client_id = c.id
        JOIN burgers b ON b.id = o.burger_id
        GROUP BY c.id
    ) sub
ORDER BY total_spending DESC
LIMIT 10