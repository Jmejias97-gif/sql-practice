-- Business question:
--   Who are the top 3 highest-spending customers in each region?
--
-- Technique:
--   RANK() partitioned by region, computed inside a CTE so the rank exists as a
--   column before it can be filtered. Window functions cannot be referenced in the
--   WHERE clause of the same query level that defines them.

WITH ranked_customers AS (
    SELECT
        customer_id,
        region,
        SUM(order_amount) AS total_spend,
        RANK() OVER (PARTITION BY region ORDER BY SUM(order_amount) DESC) AS region_rank
    FROM orders
    GROUP BY region, customer_id
)
SELECT region, customer_id, total_spend, region_rank
FROM ranked_customers
WHERE region_rank <= 3;
