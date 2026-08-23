-- Business question:
--   Which orders were followed by an unusually long gap before the customer ordered
--   again? Flag gaps over 60 days as at-risk, 30-60 days as watch, and ignore
--   anything shorter.
--
-- Technique:
--   LEAD() partitioned by customer. The gap is computed in cte_1 so that both the
--   CASE label and the WHERE filter downstream can reference it — an alias cannot
--   be used in the same SELECT list that defines it, since all columns in a SELECT
--   are computed together rather than top to bottom.
--
--   The next_order_date IS NOT NULL check is technically redundant: when it is NULL
--   the gap is NULL too, and NULL > 30 evaluates to NULL, which never passes a
--   WHERE clause. Kept as explicit documentation of intent.

WITH cte_1 AS (
    SELECT
        order_id,
        customer_id,
        region,
        order_date,
        LEAD(order_date) OVER (PARTITION BY customer_id ORDER BY order_date ASC) AS next_order_date,
        julianday(LEAD(order_date) OVER (PARTITION BY customer_id ORDER BY order_date ASC))
            - julianday(order_date) AS days_until_next_order
    FROM orders
),
cte_2 AS (
    SELECT *,
        CASE
            WHEN days_until_next_order > 60 THEN 'At Risk'
            ELSE 'Watch'
        END AS flag
    FROM cte_1
)
SELECT
    order_id,
    customer_id,
    region,
    order_date,
    next_order_date,
    days_until_next_order,
    flag
FROM cte_2
WHERE days_until_next_order > 30
  AND next_order_date IS NOT NULL;
