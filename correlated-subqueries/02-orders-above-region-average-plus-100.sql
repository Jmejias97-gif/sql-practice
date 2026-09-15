-- Business question:
--   Which orders came in more than $100 above their region's average order
--   amount — a way of spotting standout orders relative to local norms?
--
-- Technique:
--   This needs the same correlated subquery in two places: once to display the
--   region average, once to filter on it. Repeating the subquery in both SELECT
--   and WHERE would work but duplicates the same logic in two places, the same
--   fragility problem hit earlier with a repeated LEAD() expression.
--
--   WHERE runs before SELECT, so an alias defined in SELECT cannot be referenced
--   in that same query's WHERE clause. Wrapping the correlated SELECT in a CTE
--   solves this: cte_1 fully materializes region_avg_amount as a real column, and
--   the outer query's WHERE is filtering a completed result set, not the same
--   SELECT list that defines the alias.

WITH cte_1 AS (
    SELECT
        order_id,
        region,
        order_amount,
        (SELECT AVG(order_amount) FROM orders o2 WHERE o2.region = o1.region) AS region_avg_amount
    FROM orders o1
)
SELECT order_id, region, order_amount, region_avg_amount
FROM cte_1
WHERE order_amount > region_avg_amount + 100;
