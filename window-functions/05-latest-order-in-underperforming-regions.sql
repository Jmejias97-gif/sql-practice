-- Business question:
--   What is the most recent order in each region, restricted to regions with total
--   revenue below $1,500? (Surfacing current activity in underperforming regions.)
--
-- Technique:
--   RANK() ordered by order_date DESC so rank 1 is the most recent, paired with
--   SUM() OVER for the regional revenue total. Both partition on region.

WITH cte_1 AS (
    SELECT
        order_id,
        region,
        order_date,
        order_amount,
        RANK() OVER (PARTITION BY region ORDER BY order_date DESC) AS order_rank,
        SUM(order_amount) OVER (PARTITION BY region) AS region_total_revenue
    FROM orders
),
cte_2 AS (
    SELECT *
    FROM cte_1
    WHERE order_rank = 1
      AND region_total_revenue < 1500
)
SELECT order_id, region, order_date, order_amount, order_rank, region_total_revenue
FROM cte_2;
