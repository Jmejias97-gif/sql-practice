-- Business question:
--   What is each customer's single largest order, flagged only when that order
--   exceeds $300?
--
-- Technique:
--   RANK() partitioned by customer_id — partitioning by order_id here would be a
--   silent bug: every order is its own partition, so every row returns rank 1 and
--   nothing is actually compared.

WITH cte_1 AS (
    SELECT
        order_id,
        customer_id,
        order_amount,
        region,
        order_date,
        RANK() OVER (PARTITION BY customer_id ORDER BY order_amount DESC) AS ranked_per
    FROM orders
),
cte_2 AS (
    SELECT *
    FROM cte_1
    WHERE ranked_per = 1
      AND order_amount > 300
)
SELECT *
FROM cte_2;
