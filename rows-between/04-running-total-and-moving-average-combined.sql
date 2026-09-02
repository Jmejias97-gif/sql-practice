-- Business question:
--   For each order, show the region's running total alongside a 3-order moving
--   average, and flag whether the order is running above or below that trend.
--
-- Technique:
--   Two different frame shapes computed in the same CTE: an unbounded running
--   total and a 3-row moving average, both partitioned by region and ordered by
--   date. The CASE lives in a second CTE, downstream of where both values are
--   computed, since a column cannot be referenced in the same SELECT list that
--   defines it.
--
--   On each region's first row, order_amount is compared against a moving average
--   built from only itself, so it is never strictly greater than its own value —
--   the first row always reads 'Below Trend' by construction, not because it
--   actually underperformed.

WITH cte_1 AS (
    SELECT
        order_id,
        region,
        order_date,
        order_amount,
        SUM(order_amount) OVER (
            PARTITION BY region
            ORDER BY order_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS running_total,
        AVG(order_amount) OVER (
            PARTITION BY region
            ORDER BY order_date
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ) AS moving_avg_3
    FROM orders
),
cte_2 AS (
    SELECT *,
        CASE
            WHEN order_amount > moving_avg_3 THEN 'Above Trend'
            ELSE 'Below Trend'
        END AS trend_flag
    FROM cte_1
)
SELECT order_id, region, order_date, order_amount, running_total, moving_avg_3, trend_flag
FROM cte_2;
