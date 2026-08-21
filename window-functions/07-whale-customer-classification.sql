-- Business question:
--   Among customers with 3 or more orders and more than $800 in lifetime spend,
--   what is their single largest order — and is that order large enough to
--   classify them as a whale?
--
-- Technique:
--   Three window functions over the same customer partition (rank, order count,
--   lifetime spend), then a CASE WHEN applied after filtering so the label is
--   assigned only to rows that survived the qualification criteria.

WITH cte_1 AS (
    SELECT
        order_id,
        customer_id,
        region,
        order_date,
        order_amount,
        RANK() OVER (PARTITION BY customer_id ORDER BY order_amount DESC) AS order_rank,
        COUNT(order_id) OVER (PARTITION BY customer_id) AS order_count,
        SUM(order_amount) OVER (PARTITION BY customer_id) AS total_spend
    FROM orders
),
cte_2 AS (
    SELECT *
    FROM cte_1
    WHERE order_rank = 1
      AND order_count >= 3
      AND total_spend > 800
)
SELECT
    order_id,
    customer_id,
    region,
    order_date,
    order_amount,
    order_rank,
    order_count,
    total_spend,
    CASE
        WHEN order_amount > 400 THEN 'Whale'
        ELSE 'Steady'
    END AS flag
FROM cte_2;
